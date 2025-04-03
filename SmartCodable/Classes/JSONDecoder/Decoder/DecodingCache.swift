//
//  DecodingCache.swift
//  SmartCodable
//
//  Created by Mccc on 2024/3/5.
//

import Foundation


/// Caches default values during decoding operations
/// Used to provide fallback values when decoding fails
class DecodingCache: Cachable {
    
    typealias SomeSnapshot = DecodingSnapshot

    /// Stack of decoding snapshots
    var snapshots: [DecodingSnapshot] = []

    /// Creates and stores a snapshot of initial values for a Decodable type
    /// - Parameter type: The Decodable type to cache
    func cacheSnapshot<T>(for type: T.Type) {
        if let object = type as? SmartDecodable.Type {

            var snapshot = DecodingSnapshot()
            let instance = object.init()
            
            // Recursively captures initial values from a type and its superclasses
            func captureInitialValues(from mirror: Mirror) {
                mirror.children.forEach { child in
                    if let key = child.label {
                        snapshot.initialValues[key] = child.value
                    }
                }
                if let superclassMirror = mirror.superclassMirror {
                    captureInitialValues(from: superclassMirror)
                }
            }
            // Continue with superclass properties
            let mirror = Mirror(reflecting: instance)
            captureInitialValues(from: mirror)
            
            snapshot.objectType = object
            snapshot.transformers = object.mappingForValue() ?? []
            snapshots.append(snapshot)
        }
    }
    
    /// Removes the most recent snapshot for the given type
    /// - Parameter type: The type to remove from cache
    func removeSnapshot<T>(for type: T.Type) {
        guard T.self is SmartDecodable.Type else { return }
        if !snapshots.isEmpty {
            snapshots.removeLast()
        }
    }
}


extension DecodingCache {
    /// Retrieves a cached value for the given coding key
    /// - Parameter key: The coding key to look up
    /// - Returns: The cached value if available, nil otherwise
    func getValue<T>(forKey key: CodingKey) -> T? {
        
        guard let cacheValue = topSnapshot?.initialValues[key.stringValue] else {
            // Handle @propertyWrapper cases (prefixed with underscore)
            return handlePropertyWrapperCases(for: key)
        }
        
        // When the CGFloat type is resolved,
        // it is resolved as Double. So we need to do a type conversion.
        if let temp = cacheValue as? CGFloat {
            return Double(temp) as? T
        }
        
        if let value = cacheValue as? T {
            return value
        } else if let caseValue = cacheValue as? any SmartCaseDefaultable {
            return caseValue.rawValue as? T
        }
        
        return nil
    }
    
    
    /// Transforms a JSON value using the appropriate transformer
    /// - Parameters:
    ///   - value: The JSON value to transform
    ///   - key: The associated coding key (if available)
    /// - Returns: The transformed value or nil if no transformer applies
    func tranform(value: JSONValue, for key: CodingKey?) -> Any? {
        if let lastKey = key {
            let container = topSnapshot?.transformers.first(where: {
                $0.location.stringValue == lastKey.stringValue
            })
            if let tranformValue = container?.tranformer.transformFromJSON(value.peel) {
                return tranformValue
            }
        }
        return nil
    }
    
    /// Handles property wrapper cases (properties prefixed with underscore)
    private func handlePropertyWrapperCases<T>(for key: CodingKey) -> T? {
        if let cached = topSnapshot?.initialValues["_" + key.stringValue] {
            return extractWrappedValue(from: cached)
        }
        
        // Search through all snapshots for property wrapper values
        for item in snapshots.reversed() {
            if let cached = item.initialValues["_" + key.stringValue] {
                return extractWrappedValue(from: cached)
            }
        }
        
        return nil
    }
    
    /// Extracts wrapped value from potential property wrapper types
    private func extractWrappedValue<T>(from value: Any) -> T? {
        if let wrapper = value as? IgnoredKey<T> {
            return wrapper.wrappedValue
        } else if let wrapper = value as? SmartAny<T> {
            return wrapper.wrappedValue
        } else if let value = value as? T {
            return value
        }
        return nil
    }
}



/// Snapshot of decoding state for a particular model
struct DecodingSnapshot: Snapshot {
    
    typealias ObjectType = SmartDecodable.Type
    
    var objectType: (any SmartDecodable.Type)?
    
    var transformers: [SmartValueTransformer] = []
    
    /// Dictionary storing initial values of properties
    /// Key: Property name, Value: Initial value
    var initialValues: [String : Any] = [:]
}

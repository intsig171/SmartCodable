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
        
        // 减少动态派发开销，is 检查是编译时静态行为，比 as? 动态转换更高效。
        guard type is SmartDecodable.Type else { return }
        
        if let object = type as? SmartDecodable.Type {
            let snapshot = DecodingSnapshot()
            // [initialValues] Lazy initialization:
            // Generate initial values via reflection only when first accessed,
            // using the recorded objectType to optimize parsing performance.
            snapshot.objectType = object
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
    func initialValueIfPresent<T>(forKey key: CodingKey?) -> T? {
                
        guard let key = key else { return nil }
        
        
        // Lazy initialization: Generate initial values via reflection only when first accessed,
        // using the recorded objectType to optimize parsing performance
        if topSnapshot?.initialValues.isEmpty ?? true {
            populateInitialValues()
        }

        guard let cacheValue = topSnapshot?.initialValues[key.stringValue] else {
            // Handle @propertyWrapper cases (prefixed with underscore)
            return handlePropertyWrapperCases(for: key)
        }
        
        // When the CGFloat type is resolved,
        // it is resolved as Double. So we need to do a type conversion.
        if T.self == CGFloat.self, let temp = cacheValue as? CGFloat {
            return Double(temp) as? T
        }
        
        if let value = cacheValue as? T {
            return value
        } else if let caseValue = cacheValue as? any SmartCaseDefaultable {
            return caseValue.rawValue as? T
        }
        
        return nil
    }
    
    
    func initialValue<T>(forKey key: CodingKey?) throws -> T {
        guard let value: T = initialValueIfPresent(forKey: key) else {
            return try Patcher<T>.defaultForType()
        }
        return value
    }
    
    /// 获取转换器
    func valueTransformer(for key: CodingKey?) -> SmartValueTransformer? {
        guard let lastKey = key else { return nil }
        
        // Initialize transformers only once
        if topSnapshot?.transformers?.isEmpty ?? true {
            return nil
        }
        
        let transformer = topSnapshot?.transformers?.first(where: {
            $0.location.stringValue == lastKey.stringValue
        })
        return transformer
    }
    
    
    /// Handles property wrapper cases (properties prefixed with underscore)
    private func handlePropertyWrapperCases<T>(for key: CodingKey) -> T? {
        if let cached = topSnapshot?.initialValues["_" + key.stringValue] {
            return extractWrappedValue(from: cached)
        }
        
        return snapshots.reversed().lazy.compactMap {
            $0.initialValues["_" + key.stringValue]
        }.first.flatMap(extractWrappedValue)
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
    
    private func populateInitialValues() {
        guard let type = topSnapshot?.objectType else { return }
        
        // Recursively captures initial values from a type and its superclasses
        func captureInitialValues(from mirror: Mirror) {
            mirror.children.forEach { child in
                if let key = child.label {
                    snapshots.last?.initialValues[key] = child.value
                }
            }
            if let superclassMirror = mirror.superclassMirror {
                captureInitialValues(from: superclassMirror)
            }
        }
        
        let mirror = Mirror(reflecting: type.init())
        captureInitialValues(from: mirror)
    }
}



/// Snapshot of decoding state for a particular model
class DecodingSnapshot: Snapshot {
    
    typealias ObjectType = SmartDecodable.Type
    
    var objectType: (any SmartDecodable.Type)?
    
    lazy var transformers: [SmartValueTransformer]? = {
        objectType?.mappingForValue()
    }()
    
    /// Dictionary storing initial values of properties
    /// Key: Property name, Value: Initial value
    var initialValues: [String : Any] = [:]
}

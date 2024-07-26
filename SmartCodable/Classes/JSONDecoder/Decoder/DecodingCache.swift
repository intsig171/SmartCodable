//
//  DecodingCache.swift
//  SmartCodable
//
//  Created by qixin on 2024/3/5.
//

import Foundation


/// Records the default values of model properties during decoding, used for filling in when decoding fails.
class DecodingCache {
    
    
    /// Stores a snapshot of the Model being parsed.
    /// Why array records must be used
    /// - avoid parsing confusion with multi-level nested models
    private(set) var snapshots: [Snapshot] = []
    
    /// The type of the property being parsed
    var decodedType: SmartDecodable.Type?
    
    var topSnapshot: Snapshot? {
        return self.snapshots.last
    }
    
    /// Cache the initial state of a Decodable object.
    func cacheInitialState<T: Decodable>(for type: T.Type) {
        
        
        if let object = type as? SmartDecodable.Type {
        
            decodedType = object
            
            var snapshot = Snapshot()
            
            let instance = object.init()
            let mirror = Mirror(reflecting: instance)
            mirror.children.forEach { child in
                if let key = child.label {
                    snapshot.initialValues[key] = child.value
                }
            }
            snapshot.typeName = "\(type)"

            snapshot.transformers = object.mappingForValue() ?? []
            
            snapshots.append(snapshot)
        }
    }
    
    /// Clears the decoding status of the last record
    func clearLastState<T: Decodable>(for type: T.Type) {
        
        // If the current type being decoded does not inherit from SmartDecodable Model, it does not need to be processed.
        // The properties within the model being decoded should not be cleared. They can be cleared only after decoding is complete.
        if let _ = T.self as? SmartDecodable.Type {
            if snapshots.count > 0 {
                snapshots.removeLast()
            }
        }
    }
    
    /// Gets the initialization value of the attribute (key)
    func getValue<T>(forKey key: CodingKey) -> T? {
        
        if var cacheValue = snapshots.last?.initialValues[key.stringValue] {
            // When the CGFloat type is resolved, it is resolved as Double. So we need to do a type conversion.
            if let temp = cacheValue as? CGFloat {
                cacheValue = Double(temp)
            }
            
            if let value = cacheValue as? T {
                return value
            } else if let caseValue = cacheValue as? (any SmartCaseDefaultable) {
                return caseValue.rawValue as? T
            }
        } else { // @propertyWrapper type， value logic
            if let cached = snapshots.last?.initialValues["_" + key.stringValue] {
                if let value = cached as? IgnoredKey<T> {
                    return value.wrappedValue
                } else if let value = cached as? SmartAny<T> {
                    return value.wrappedValue
                } else if let value = cached as? T { // 当key缺失的时候，会进入
                    return value
                }
            }
        }

        return nil
    }
    
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
}


extension DecodingCache {
    struct Snapshot {
        /// The current decoding type
        var typeName: String = ""
        
        /// The current decoding path (ensuring the correspondence through the decoding path)
        var initialValues: [String: Any] = [:]
        
        /// Records the custom transformer for properties
        var transformers: [SmartValueTransformer] = []
    }
}

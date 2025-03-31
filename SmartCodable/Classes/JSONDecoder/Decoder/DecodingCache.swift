//
//  DecodingCache.swift
//  SmartCodable
//
//  Created by Mccc on 2024/3/5.
//

import Foundation


/// Records the default values of model properties during decoding, used for filling in when decoding fails.
class DecodingCache: Cachable {
    
    typealias SomeSnapshot = DecodingSnapshot

    /// Stores a snapshot of the Model being parsed.
    /// Why array records must be used
    /// - avoid parsing confusion with multi-level nested models
    var snapshots: [DecodingSnapshot] = []

    /// Cache the initial state of a Decodable object.
    func cacheSnapshot<T>(for type: T.Type) {
        if let object = type as? SmartDecodable.Type {
            var snapshot = DecodingSnapshot()
            
            let instance = object.init()
            // 递归处理所有的 superclassMirror
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
            // 获取当前类和所有父类的属性值
            let mirror = Mirror(reflecting: instance)
            captureInitialValues(from: mirror)
            
            snapshot.objectType = object
            snapshot.transformers = object.mappingForValue() ?? []
            snapshots.append(snapshot)
        }
    }
    
    /// Clears the decoding status of the last record
    func removeSnapshot<T>(for type: T.Type) {

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
        
        if var cacheValue = topSnapshot?.initialValues[key.stringValue] {
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
            if let cached = topSnapshot?.initialValues["_" + key.stringValue] {
                if let value = cached as? IgnoredKey<T> {
                    return value.wrappedValue
                } else if let value = cached as? SmartAny<T> {
                    return value.wrappedValue
                } else if let value = cached as? T { // 当key缺失的时候，会进入
                    return value
                }
            } else {
                // SmartAny 修饰一个可选的Model会走这里
                for item in snapshots.reversed() {
                    if let cached = item.initialValues["_" + key.stringValue] {
                        if let value = cached as? IgnoredKey<T> {
                            return value.wrappedValue
                        } else if let value = cached as? SmartAny<T> {
                            return value.wrappedValue
                        } else if let value = cached as? T { 
                            return value
                        }
                    }
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



struct DecodingSnapshot: Snapshot {
    var objectType: (any SmartDecodable.Type)?
    
    typealias ObjectType = SmartDecodable.Type
    
    var transformers: [SmartValueTransformer] = []
    
    /// 记录当前Container中，属性的默认值
    var initialValues: [String : Any] = [:]
}

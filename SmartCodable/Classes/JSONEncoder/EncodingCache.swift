//
//  EncodingCache.swift
//  SmartCodable
//
//  Created by qixin on 2024/6/3.
//

import Foundation


class EncodingCache: Cachable {
    
    typealias CacheType = SmartEncodable.Type

    var chaceType: (any SmartEncodable.Type)?
    var snapshots: [Snapshot] = []
    
    func cacheSnapshot<T>(for type: T.Type) {
        if let object = type as? SmartEncodable.Type {
            chaceType = object
            
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
}

extension EncodingCache {
    
    func tranform(from value: Any?, with key: CodingKey?) -> JSONValue? {
        if let trans = topSnapshot?.transformers {
            if let tran = trans.first(where: { $0.location.stringValue == key!.stringValue}) {
                if let decoded = tranform(decodedValue: value, transformer: tran.tranformer) {
                    return JSONValue.make(decoded)
                }
            }
        }
        return nil
    }
    
    /// Custom conversion strategy for decoded values
    private func tranform<Transform: ValueTransformable>(decodedValue: Any?, transformer: Transform) -> Any? {
        return transformer.transformToJSON(decodedValue as? Transform.Object)
    }
}









/// Records the default values of model properties during decoding, used for filling in when decoding fails.
class EncodingCache123123 {
    
    
    /// Stores a snapshot of the Model being parsed.
    /// Why array records must be used
    /// - avoid parsing confusion with multi-level nested models
    private(set) var snapshots: [Snapshot] = []
    
    /// 正在解析的属性类型
    var encodedType: SmartEncodable.Type?
    
    var topSnapshot: Snapshot? {
        return self.snapshots.last
    }
    
    /// Cache the initial state of a Decodable object.
    func cacheInitialState<T>(for type: T.Type) {
        
        if let object = type as? SmartEncodable.Type {
        
            encodedType = object
            
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
    func clearLastState<T>(for type: T.Type) {
        
        // If the current type being decoded does not inherit from SmartDecodable Model, it does not need to be processed.
        // The properties within the model being decoded should not be cleared. They can be cleared only after decoding is complete.
        if let _ = T.self as? SmartEncodable.Type {
            if snapshots.count > 0 {
                snapshots.removeLast()
            }
        }
    }
    
    /// Gets the initialization value of the attribute (key)
    func getValue<T>(forKey key: CodingKey) -> T? {
        
        if var cacheValue = snapshots.last?.initialValues[key.stringValue] {
            // 进行CGFloat类型解析时候，是当Double来解析的。所以需要进行类型转换一下。
            if let temp = cacheValue as? CGFloat {
                cacheValue = Double(temp)
            }
            
            if let value = cacheValue as? T {
                return value
            } else if let caseValue = cacheValue as? (any SmartCaseDefaultable) {
                return caseValue.rawValue as? T
            }
        } else { // @propertyWrapper type， value logic
            if let cacheValue1 = snapshots.last?.initialValues["_" + key.stringValue] {
                if let value = cacheValue1 as? IgnoredKey<T> {
                    return value.wrappedValue
                } else if let value = cacheValue1 as? T { // 当key缺失的时候，会进入
                    return value
                }
            }
        }

        return nil
    }
    
    /// Custom conversion strategy for decoded values
    private func tranform<Transform: ValueTransformable>(decodedValue: Any?, transformer: Transform) -> Any? {
        return transformer.transformToJSON(decodedValue as? Transform.Object)
    }
    
    func tranformToJsonValue(from value: Any?, for key: CodingKey?) -> JSONValue? {
        if let trans = topSnapshot?.transformers {
            if let tran = trans.first(where: { $0.location.stringValue == key!.stringValue}) {
                if let decoded = tranform(decodedValue: value, transformer: tran.tranformer) {
                    return JSONValue.make(decoded)
                }
            }
        }
        return nil
    }
}


//
//  EncodingCache.swift
//  SmartCodable
//
//  Created by Mccc on 2024/6/3.
//

import Foundation


class EncodingCache: Cachable {
    typealias SomeSnapshot = EncodingSnapshot

    var snapshots: [EncodingSnapshot] = []
    
    func cacheSnapshot<T>(for type: T.Type) {
        if let object = type as? SmartEncodable.Type {
            
            var snapshot = EncodingSnapshot()
            let instance = object.init()
            let mirror = Mirror(reflecting: instance)
            mirror.children.forEach { child in
                if let key = child.label {
                    snapshot.initialValues[key] = child.value
                }
            }
            snapshot.objectType = object
            snapshot.transformers = object.mappingForValue() ?? []
            snapshots.append(snapshot)
        }
    }
    
    func removeSnapshot<T>(for type: T.Type) {
        if let _ = T.self as? SmartEncodable.Type {
            if snapshots.count > 0 {
                snapshots.removeLast()
            }
        }
    }
}

extension EncodingCache {
    
    func tranform(from value: Any, with key: CodingKey?) -> JSONValue? {
        
        guard let top = topSnapshot, let key = key else { return nil }
        
        let trans = top.transformers
        
        let wantKey = key.stringValue
        let targetTran = trans.first(where: { transformer in
            if wantKey == transformer.location.stringValue {
                return true
            } else {
                
                if let keyTransformers = top.objectType?.mappingForKey() {
                    for keyTransformer in keyTransformers {
                        if keyTransformer.from.contains(wantKey) {
                            return true
                        }
                    }
                }
                return false
            }
        })
        
        
        if let tran = targetTran, let decoded = tranform(decodedValue: value, transformer: tran.tranformer) {
            return JSONValue.make(decoded)
        }
        
        return nil
    }
    
    /// Custom conversion strategy for decoded values
    private func tranform<Transform: ValueTransformable>(decodedValue: Any, transformer: Transform) -> Any? {
        if let value = decodedValue as? Transform.Object {
            return transformer.transformToJSON(value)
        }
        return nil
    }
}




struct EncodingSnapshot: Snapshot {
    var objectType: (any SmartEncodable.Type)?
    
    typealias ObjectType = SmartEncodable.Type
    
    var initialValues: [String : Any] = [:]
    
    var transformers: [SmartValueTransformer] = []
}



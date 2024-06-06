//
//  EncodingCache.swift
//  SmartCodable
//
//  Created by qixin on 2024/6/3.
//

import Foundation


class EncodingCache: Cachable {
    
    typealias CacheType = SmartEncodable.Type

    var cacheType: CacheType?
    var snapshots: [Snapshot] = []
    
    func cacheSnapshot<T>(for type: T.Type) {
        if let object = type as? SmartEncodable.Type {
            cacheType = object
            
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
    
    func tranform(from value: Any, with key: CodingKey?) -> JSONValue? {
 
        if let trans = topSnapshot?.transformers, let key = key {
            
            let wantKey = key.stringValue
            let tran = trans.first(where: { transformer in
                if wantKey == transformer.location.stringValue {
                    return true
                } else {
                    
                    if let keyTransformers = cacheType?.mappingForKey() {
                        for keyTransformer in keyTransformers {
                            if keyTransformer.from.contains(wantKey) {
                                return true
                            }
                        }
                    }
                    return false
                }
            })
            
            
            if let tran = tran, let decoded = tranform(decodedValue: value, transformer: tran.tranformer) {
                return JSONValue.make(decoded)
            }
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








//
//  DecodingDefaults.swift
//  SmartCodable
//
//  Created by qixin on 2024/3/5.
//

import Foundation


/// Records the default values of model properties during decoding, used for filling in when decoding fails.
struct DecodingDefaults {
    
    private(set) var recoders: [Recoder] = []
    
    var topContainer: Recoder? {
        assert(!self.recoders.isEmpty, "Empty container stack.")
        return self.recoders.last
    }
    
    mutating func recordAttributeValues<T: Decodable>(for type: T.Type) {
        if let object = type as? SmartDecodable.Type {
            
            var recoder = Recoder()
            
            let instance = object.init()
            let mirror = Mirror(reflecting: instance)
            mirror.children.forEach { child in
                if let key = child.label {
                    recoder.containers[key] = child.value
                }
            }
            recoder.typeName = "\(type)"

            recoder.transformers = object.mappingForValue() ?? []
            
            recoders.append(recoder)
        }
    }
    
    func getValue<T: Decodable>(forKey key: CodingKey, atPath path: [CodingKey]) -> T? {
        
        let value = recoders.last?.containers[key.stringValue] as? T
        return value
    }
    
    mutating func resetRecords<T: Decodable>(for type: T.Type) {
        
        // If the current type being decoded does not inherit from SmartDecodable Model, it does not need to be processed.
        // The properties within the model being decoded should not be cleared. They can be cleared only after decoding is complete.
        if let _ = T.self as? SmartDecodable.Type {
            if recoders.count > 0 {
                recoders.removeLast()
            }
        }
    }
}

extension DecodingDefaults {
    func tranformValue(_ value: Any?, key: CodingKey?) -> Any? {
        if let lastKey = key {
            let container = topContainer?.transformers.first(where: {
                $0.location.stringValue == lastKey.stringValue
            })
            if let tranformValue = container?.tranformer.transformFromJSON(value) as? Date {
                return tranformValue
            }
        }
        return nil
    }
}

extension DecodingDefaults {
    struct Recoder {
        /// The current decoding type
        var typeName: String = ""
        
        /// The current decoding path (ensuring the correspondence through the decoding path)
        var containers: [String: Any] = [:]
        
        /// Records the custom transformer for properties
        var transformers: [SmartValueTransformer] = []
    }
}

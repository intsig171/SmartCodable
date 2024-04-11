//
//  DecodingDefaults.swift
//  SmartCodable
//
//  Created by qixin on 2024/3/5.
//

import Foundation


/// Records the default values of model properties during decoding, used for filling in when decoding fails.
struct DecodingDefaults {
    
    private(set) var typeName: String = ""
    
    /// The current decoding path (ensuring the correspondence through the decoding path)
    private var codingPath: [CodingKey] = []
        
    /// Records the default values of model properties
    private var containers: [String: Any] = [:]
    
    /// Records the custom transformer for properties
    private(set) var transformers: [SmartValueTransformer] = []
    
    mutating func recordAttributeValues<T: Decodable>(for type: T.Type, codingPath: [CodingKey]) {
        if let object = type as? SmartDecodable.Type {
            let instance = object.init()
            let mirror = Mirror(reflecting: instance)
            mirror.children.forEach { child in
                if let key = child.label {
                    containers[key] = child.value
                }
            }
            self.typeName = "\(type)"
            self.codingPath = codingPath

            transformers = object.mappingForValue() ?? []
        }
    }
    
    func getValue<T: Decodable>(forKey key: CodingKey, atPath path: [CodingKey]) -> T? {
        guard areCodingKeysEqual(codingPath, path),
                let value = containers[key.stringValue] as? T else {
            return nil
        }
        return value
    }
    
    mutating func resetRecords<T: Decodable>(for type: T.Type) {
        
        // If the current type being decoded does not inherit from SmartDecodable Model, it does not need to be processed.
        // The properties within the model being decoded should not be cleared. They can be cleared only after decoding is complete.
        if let _ = T.self as? SmartDecodable.Type {
            self.typeName = ""
            self.codingPath = []
            self.containers.removeAll()
            self.transformers.removeAll()
        }
    }
    
    private func areCodingKeysEqual(_ keys1: [CodingKey], _ keys2: [CodingKey]) -> Bool {
        return keys1.count == keys2.count && !zip(keys1, keys2).contains { $0.stringValue != $1.stringValue }
    }
}




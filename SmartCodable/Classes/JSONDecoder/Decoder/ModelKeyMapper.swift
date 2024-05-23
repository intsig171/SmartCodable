//
//  ModelKeyMapper.swift
//  SmartCodable
//
//  Created by Mccc on 2024/3/4.
//

import Foundation
struct ModelKeyMapperNew {
    
    static func convertToMappedFormat(_ jsonValue: Any?, type: Any.Type) -> Any? {
        guard let type = type as? SmartDecodable.Type else { return jsonValue }
        
        if let stringValue = jsonValue as? String {
            return parseJSON(from: stringValue, as: type)
        } else if let dictValue = jsonValue as? [String: Any] {
            return mapDictionary(dict: dictValue, using: type)
        }
        return jsonValue
    }

    
    private static func parseJSON(from string: String, as type: SmartDecodable.Type) -> Any {
        guard let jsonObject = string.toJSONObject() else { return string }
        if let dict = jsonObject as? [String: Any] {
            return mapDictionary(dict: dict, using: type)
        } else {
            return jsonObject
        }
    }
    
    private static func mapDictionary(dict: [String: Any], using type: SmartDecodable.Type) -> [String: Any] {
        var newDict = dict
        type.mappingForKey()?.forEach { mapping in
            for oldKey in mapping.from {
                let newKey = mapping.to.stringValue
                if let value = newDict[oldKey], !(value is NSNull) {
                    newDict[newKey] = newDict[oldKey]
                    break
                } else { // Handles the case of a custom parsing path.
                    if newDict[newKey] == nil, let pathValue = newDict.getValue(forKeyPath: oldKey) {
                        newDict.updateValue(pathValue, forKey: newKey)
                    }
                }
            }
        }
        return newDict
    }
}



struct ModelKeyMapper<T> {
    /// Attempts to convert to a format related to a mapped model
    static func convertToMappedFormat(_ jsonValue: Any) -> Any {
        guard let type = T.self as? SmartDecodable.Type else { return jsonValue }
        
        if let stringValue = jsonValue as? String {
            return parseJSON(from: stringValue, as: type)
        } else if let dictValue = jsonValue as? [String: Any] {
            return mapDictionary(dict: dictValue, using: type)
        }
        return jsonValue
    }
    
    private static func parseJSON(from string: String, as type: SmartDecodable.Type) -> Any {
        guard let jsonObject = string.toJSONObject() else { return string }
        if let dict = jsonObject as? [String: Any] {
            return mapDictionary(dict: dict, using: type)
        } else {
            return jsonObject
        }
    }
    
    private static func mapDictionary(dict: [String: Any], using type: SmartDecodable.Type) -> [String: Any] {
        var newDict = dict
        type.mappingForKey()?.forEach { mapping in
            for oldKey in mapping.from {
                let newKey = mapping.to.stringValue
                if let value = newDict[oldKey], !(value is NSNull) {
                    newDict[newKey] = newDict[oldKey]
                    break
                } else { // Handles the case of a custom parsing path.
                    if newDict[newKey] == nil, let pathValue = newDict.getValue(forKeyPath: oldKey) {
                        newDict.updateValue(pathValue, forKey: newKey)
                    }
                }
            }
        }
        return newDict
    }
}


extension Dictionary {
    
    /// Retrieves the value corresponding to the path in the dictionary.
    ///  let dict = [
    ///      "inDict": [
    ///         "name": "Mccc"
    ///      ]
    ///  ]
    ///
    ///  keyPath is “inDict.name”
    ///
    ///  result： Mccc
    ///
    fileprivate func getValue(forKeyPath keyPath: String) -> Any? {
        guard keyPath.contains(".") else { return nil }
        let keys = keyPath.components(separatedBy: ".")
        var currentAny: Any = self
        for key in keys {
            if let currentDict = currentAny as? [String: Any] {
                if let value = currentDict[key] {
                    currentAny = value
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        return currentAny
    }
}



extension String {
    fileprivate func toJSONObject() -> Any? {
        guard starts(with: "{") || starts(with: "[") else { return nil }
        return data(using: .utf8).flatMap { try? JSONSerialization.jsonObject(with: $0) }
    }
}

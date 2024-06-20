//
//  KeysMapper.swift
//  SmartCodable
//
//  Created by qixin on 2024/5/27.
//

import Foundation
struct KeysMapper {
    
    static func convertFrom(_ jsonValue: JSONValue, type: Any.Type) -> JSONValue? {
        
        //type is not Model, there is no renaming requirement for key.
        guard let type = type as? SmartDecodable.Type else { return jsonValue }
        
        switch jsonValue {
        case .string(let stringValue):
            let value = parseJSON(from: stringValue, as: type)
            return JSONValue.make(value)
            
        case .object(let dictValue):
            if let dict = mapDictionary(dict: dictValue, using: type) as? [String: JSONValue] {
                return JSONValue.object(dict)
            }
            
        default:
            break
        }
        return nil
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
            } else if case JSONValue.object(let object) = currentAny, let temp = object[key] {
                currentAny = temp
            } else {
                return nil
            }
        }
        return currentAny
    }
}



extension String {
    func toJSONObject() -> Any? {
        guard starts(with: "{") || starts(with: "[") else { return nil }
        return data(using: .utf8).flatMap { try? JSONSerialization.jsonObject(with: $0) }
    }
}

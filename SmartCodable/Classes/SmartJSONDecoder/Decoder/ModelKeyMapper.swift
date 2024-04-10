//
//  ModelKeyMapper.swift
//  SmartCodable
//
//  Created by Mccc on 2024/3/4.
//

import Foundation




struct ModelKeyMapper<T> {
    /// 尝试转换为一个映射后的模型相关的格式
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
                if let value = newDict[oldKey], !(value is NSNull) { // 如果存在有效值(存在并不是null)
                    newDict[newKey] = newDict.removeValue(forKey: oldKey)
                    break
                } else { // 处理自定义解析路径的情况。
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
    
    // 添加或更新键值对，仅当键不存在时
    fileprivate mutating func updateIfAbsent(key: Key, value: Value) {
        guard self[key] == nil else { return }
        self[key] = value
    }
    
    
    /// 在字典中，获取路径对应的值。
    ///  let dict = [
    ///      "inDict": [
    ///         "name": "Mccc"
    ///      ]
    ///  ]
    ///
    ///  keyPath 为 “inDict.name”
    ///
    ///  输出： Mccc
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

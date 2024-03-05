//
//  ModelKeyMapper.swift
//  SmartCodable
//
//  Created by Mccc on 2024/3/4.
//

import Foundation

/// 映射关系
/// 将from对应的数据字段映射到to对应的模型属性上
public typealias MappingRelationship = (from: [String], to: CodingKey)

infix operator <--
public func <--(after: CodingKey, before: String) -> MappingRelationship { after <-- [before] }
public func <--(after: CodingKey, before: [String]) -> MappingRelationship { (before, after) }



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
        type.mapping()?.forEach { mapping in
            mapping.from.forEach { oldKey in
                if let _ = newDict[oldKey] {
                    let newKey = mapping.to.stringValue
                    newDict[newKey] = newDict.removeValue(forKey: oldKey)
                }
            }
        }
        return newDict
    }
}

extension String {
    fileprivate func toJSONObject() -> Any? {
        guard starts(with: "{") || starts(with: "[") else { return nil }
        return data(using: .utf8).flatMap { try? JSONSerialization.jsonObject(with: $0) }
    }
}

//
//  Helper.swift
//  SmartCodable
//
//  Created by qixin on 2023/11/16.
//

import Foundation



/// json值 获取器
struct JSONValueFinder {
    
    /// 存储信息，当前的解析器对应的要解析的json数据
    static var container: [String: Any] = [:]
    
    
    /// 获取当前要解析的json
    static func getJsonObject(decoder: Decoder) -> Any? {
        
        guard let userKey = CodingUserInfoKey.originData else { return nil }
        // 存入的时候是data类型
        guard let value = decoder.userInfo[userKey] else { return nil }
        return value
    }
}


extension JSONValueFinder {
    /// 通过CodingKey获取json数据中对应的value
    /// - Parameters:
    ///   - decoder: 解析器
    ///   - key: 当前的CodingKey
    /// - Returns: json中对应的值
    static func findValue(decoder: Decoder?, key: CodingKey) -> Any? {
        
        guard let decoder = decoder else { return nil}
   
        guard var lastJsonObject = getJsonObject(decoder: decoder) else { return nil }

        // 拼接成完整的当前解析的codingPath
        var codingKeys = decoder.codingPath
        codingKeys.append(key)
        
        var wantValue: Any? = nil
        
        for codingKey in codingKeys {
            if let index = codingKey.intValue { // 当前层级是数组
                if let tempArr = lastJsonObject as? [Any], tempArr.count > index {
                    lastJsonObject = tempArr[index]
                }  else { // 异常情况，中断兼容
                    break
                }
            } else { // 当前层级是字典或singleContainer
                
                // 字典容器层路径（忽略）
                if codingKey.stringValue == "super" { continue }
                
                if let dictObject = lastJsonObject as? [String: Any] { // 字典容器
                    // 对解码的key进行转化
                    let fieldName = codingKey.convertKeyNameToFieldName(decoder: decoder)
                    guard let jsonValue = dictObject[fieldName] else { return nil }
                    
                    if let _ = jsonValue as? [Any] { // 如果取到的值是数组类型，就承接住
                        lastJsonObject = jsonValue
                    } else if let _ = jsonValue as? [String: Any]  {// 如果取到的值是字典类型，就承接住
                        lastJsonObject = jsonValue
                    } else { // 当前是singleContainer
                        wantValue = jsonValue
                        break
                    }
                }  else { // 当前是singleContainer
                    wantValue = lastJsonObject
                    break
                }
            }
        }
        return wantValue
    }
}



extension CodingKey {
    // 将codingKey的命名转成字段名，以便获取对应的字段值。
    fileprivate func convertKeyNameToFieldName(decoder: Decoder) -> String {
        let keyName = self.stringValue
        
        guard let strategyKey = CodingUserInfoKey.keyDecodingStrategy, let strategy = decoder.userInfo[strategyKey] else {
            return keyName
        }

        if let strategy = strategy as? JSONDecoder.SmartDecodingKey {
            switch strategy {
            case .useDefaultKeys:
                return keyName
            case .convertFromSnakeCase:
                return keyName.convertCamelCaseToSnakeCase()
            case .globalMap(let maps):
                for map in maps {
                    if keyName == map.to {
                        return map.from
                    }
                }
                
            case .exactMap(let maps):
                for map in maps {
                    if keyName == map.to {
                        return map.from
                    }
                }
            }
        }
        return keyName
    }
}


extension String {
    // 转成下划线命名
    fileprivate func convertCamelCaseToSnakeCase() -> String {
        let stringKey = self
        guard !stringKey.isEmpty else { return stringKey }
        
        var newString = ""
        let scalarValues = stringKey.unicodeScalars.map { $0 }
        
        for (index, scalar) in scalarValues.enumerated() {
            if CharacterSet.uppercaseLetters.contains(scalar) {
                if index != 0 { newString += "_" }
                newString += String(Character(scalar)).lowercased()
            } else {
                newString += String(Character(scalar))
            }
        }
        return newString
    }
}


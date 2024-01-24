//
//  Helper.swift
//  SmartCodable
//
//  Created by qixin on 2023/11/16.
//

import Foundation



/// json值获取器
struct JSONValueFinder {
    
    /// 存储信息，当前的解析器对应的要解析的json数据
    static var container: [String: Any] = [:]
    
    
    /// 获取当前要解析的json
    static func getJsonObject(decoder: Decoder) -> Any? {
        guard let userKey = CodingUserInfoKey.originData,
              let value = decoder.userInfo[userKey] else { return nil }
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
        
        guard let decoder = decoder,
              var lastJsonObject = getJsonObject(decoder: decoder) else { return nil }
        
        // 拼接成完整的当前解析的codingPath
        let codingKeys = decoder.codingPath + [key]
        
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
    
    /// 将codingKey的命名转成字段名，以便获取对应的字段值。
    fileprivate func convertKeyNameToFieldName(decoder: Decoder) -> String {
        let keyName = self.stringValue
        guard let strategyKey = CodingUserInfoKey.keyDecodingStrategy,
              let strategy = decoder.userInfo[strategyKey] as? JSONDecoder.SmartDecodingKey else {
            return keyName
        }
        switch strategy {
        case .useDefaultKeys:
            return keyName
        case .convertFromSnakeCase:
            return keyName.convertCamelCaseToSnakeCase()
        case .globalMap(let maps):
            return maps.first(where: { $0.to == keyName })?.from ?? keyName
        case .exactMap(let maps):
            return maps.first(where: { $0.to == keyName })?.from ?? keyName
        }
    }
}


extension String {
    /// 驼峰转蛇形
    fileprivate func convertCamelCaseToSnakeCase() -> String {
        return unicodeScalars.reduce("") { (result, scalar) in
            if CharacterSet.uppercaseLetters.contains(scalar) {
                return result + (result.isEmpty ? "" : "_") + String(Character(scalar)).lowercased()
            } else {
                return result + String(Character(scalar))
            }
        }
    }
}

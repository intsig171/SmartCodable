//
//  SmartDecodable.swift
//  SmartCodable
//
//  Created by qixin on 2023/9/4.
//

import Foundation


public protocol SmartDecodable: Decodable {
    
    /// 映射完成的完成的回调
    mutating func didFinishMapping()
    
    init()
}


extension SmartDecodable {
    public mutating func didFinishMapping() { }
}



extension SmartDecodable {
    
    /// 反序列化成模型
    /// - Parameter dict: 字典
    /// - Parameter strategy: 解码策略
    /// - Returns: 模型
    public static func deserialize(dict: [AnyHashable: Any]?, strategy: JSONDecoder.KeyDecodingStrategy? = nil) -> Self? {
        guard let _dict = dict else {
            SmartLog.logDebug("\(Self.self)中，提供的字典为nil")
            return nil
        }
                
        do {
            return try _dict._deserialize(type: Self.self, strategy: strategy)
        } catch  {
            return nil
        }
    }
    
    /// 反序列化成模型
    /// - Parameter json: json字符串
    /// - Parameter strategy: 解码策略
    /// - Returns: 模型
    public static func deserialize(json: String?, strategy: JSONDecoder.KeyDecodingStrategy? = nil) -> Self? {
        guard let _json = json else {
            SmartLog.logDebug("\(Self.self)中，提供的json为nil")
            return nil
        }
        
        guard let dict = _json.toDictionary() else {
            SmartLog.logDebug("\(Self.self)中，提供的json为非法json")
            return nil
        }
        
        do {
            return try dict._deserialize(type: Self.self, strategy: strategy)
        } catch  {
            return nil
        }
    }
}




extension Array where Element: SmartDecodable {
    
    /// 反序列化为模型数组
    /// - Parameter array: 数组
    /// - Parameter strategy: 解码策略
    /// - Returns: 模型数组
    public static func deserialize(array: [Any]?, strategy: JSONDecoder.KeyDecodingStrategy? = nil) -> [Element?]? {

        guard let _arr = array else {
            SmartLog.logDebug("\(Self.self)提供的反序列化的数组为空")
            return nil
        }
        
        do {
            return try _arr._deserialize(type: Self.self, strategy: strategy)
        } catch  {
            return nil
        }
    }
    
    
    /// 反序列化为模型数组
    /// - Parameter json: json字符串
    /// - Parameter strategy: 解码策略
    /// - Returns: 模型数组
    public static func deserialize(json: String?, strategy: JSONDecoder.KeyDecodingStrategy? = nil) -> [Element?]? {
        guard let _json = json else {
            SmartLog.logDebug("提供的json为nil")
            return nil
        }
        
        guard let _arr = _json.toArray() else {
            SmartLog.logDebug("提供的json为非法json")
            return nil
        }
        
        do {
            return try _arr._deserialize(type: Self.self, strategy: strategy)
        } catch  {
            return nil
        }
    }
}


extension Dictionary {
    fileprivate func _deserialize<T>(type: T.Type, strategy: JSONDecoder.KeyDecodingStrategy?) throws -> T? where T: SmartDecodable {

        guard let json = toJSONString() else {
            SmartLog.logDebug("\(self)转json字符串失败")
            return nil
        }
        guard let jsonData = json.data(using: .utf8) else {
            SmartLog.logDebug("\(self) 转data失败")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            
            // 设置userInfo
            if let key = CodingUserInfoKey.typeName {
                var userInfo = decoder.userInfo
                userInfo.updateValue(type, forKey: key)
                
                if let userInfoKey = CodingUserInfoKey.originData {
                    userInfo.updateValue(self, forKey: userInfoKey)
                }
                decoder.userInfo = userInfo
            }
            
            if let strategy = strategy {
                decoder.keyDecodingStrategy = strategy
            }
            var obj = try decoder.decode(type, from: jsonData)
                    
            obj.didFinishMapping()

            return obj
        } catch let error {
            SmartLog.logError(error, className: "\(type)")
            return nil
        }
    }
}


extension Array {
    
    fileprivate func _deserialize<T>(type: [T].Type, strategy: JSONDecoder.KeyDecodingStrategy?) throws -> [T]? where T: SmartDecodable {

        guard let json = toJSONString() else {
            SmartLog.logDebug("\(self)转json字符串失败")
            return nil
        }
        
        guard let jsonData = json.data(using: .utf8) else {
            SmartLog.logDebug("\(self) 转data失败")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            
            // 设置userInfo
            if let key = CodingUserInfoKey.typeName {
                var userInfo = decoder.userInfo
                userInfo.updateValue(type, forKey: key)
                
                if let userInfoKey = CodingUserInfoKey.originData {
                    userInfo.updateValue(self, forKey: userInfoKey)
                }
                decoder.userInfo = userInfo
            }
                        
            if let strategy = strategy {
                decoder.keyDecodingStrategy = strategy
            }
            let decodeValue = try decoder.decode(type, from: jsonData)
            
            var finishValue: [SmartDecodable] = []
            for var item in decodeValue {
                item.didFinishMapping()
                finishValue.append(item)
            }
            return finishValue as? [T]
        } catch let error {
            SmartLog.logError(error, className: "\(type)")
            return nil
        }
    }
}




// MARK: - 扩展实现
extension Dictionary {
    /// 字典转Json字符串
    fileprivate func toJSONString() -> String? {
        if (!JSONSerialization.isValidJSONObject(self)) {
            return nil
        }
        
        if let data = try? JSONSerialization.data(withJSONObject: self) {
            if let json = String(data: data, encoding: String.Encoding.utf8) {
                return json
            }
        }
        return nil
    }
}

extension String {
    /// JSONString转换为字典
    fileprivate func toDictionary() -> Dictionary<String, Any>? {
        guard let jsonData:Data = data(using: .utf8) else { return nil }
        if let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
            if let temp = dict as? Dictionary<String, Any> {
                return temp
            }
        }
        return nil
    }

    /// JSONString转换为数组
    fileprivate func toArray() -> Array<Any>? {
        guard let jsonData:Data = data(using: .utf8) else { return nil }
        if let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
            if let temp = array as? Array<Any> {
                return temp
            }
        }
        return nil
    }
}
extension Array {
    /// 数组转json字符串
    fileprivate func toJSONString() -> String? {
        if (!JSONSerialization.isValidJSONObject(self)) {
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            let json = String(data: data, encoding: String.Encoding.utf8)
            return json
        } catch {
            return nil
        }
    }
}

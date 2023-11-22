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




/// key解码策略
public enum SmartKeyDecodingStrategy {
    case useDefaultKeys
    case convertFromSnakeCase
    case custom([String: String])
    
    func toSystem() -> JSONDecoder.KeyDecodingStrategy {
        switch self {
        case .useDefaultKeys:
            return JSONDecoder.KeyDecodingStrategy.useDefaultKeys
        case .convertFromSnakeCase:
            return JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
        case .custom(let t):
            return JSONDecoder.KeyDecodingStrategy.mapper(
                t
            )
        }
    }
}


extension SmartDecodable {
    
    /// 反序列化成模型
    /// - Parameter dict: 字典
    /// - Parameter strategy: 解码策略
    /// - Returns: 模型
    public static func deserialize(dict: [AnyHashable: Any]?, strategy: SmartKeyDecodingStrategy? = nil) -> Self? {
        guard let _dict = dict else {
            SmartLog.logDebug("\(Self.self)中，提供的字典为nil")
            return nil
        }
        
        guard let _json = _dict.toJSONString() else {
            SmartLog.logDebug("\(self)转json字符串失败")
            return nil
        }
        guard let _jsonData = _json.data(using: .utf8) else {
            SmartLog.logDebug("\(self) 转data失败")
            return nil
        }
        
        return deserialize(data: _jsonData, strategy: strategy)
    }
    
    /// 反序列化成模型
    /// - Parameter json: json字符串
    /// - Parameter decoder: 解码器，可以通过此完成一些配置，例如：keyDecodingStrategy。
    /// - Returns: 模型
    public static func deserialize(json: String?, strategy: SmartKeyDecodingStrategy? = nil) -> Self? {
        guard let _json = json else {
            SmartLog.logDebug("\(Self.self)中，提供的json为nil")
            return nil
        }
    
        guard let jsonData = _json.data(using: .utf8) else {
            SmartLog.logDebug("\(self) 转data失败")
            return nil
        }
        
        return deserialize(data: jsonData, strategy: strategy)
    }
    
    
    public static func deserialize(data: Data?, strategy: SmartKeyDecodingStrategy? = nil) -> Self? {
        guard let _data = data else {
            SmartLog.logDebug("\(Self.self)中，提供的data为nil")
            return nil
        }
        
        do {
            return try _data._deserializeDict(type: Self.self, strategy: strategy)
        } catch  {
            return nil
        }
    }
}




extension Array where Element: SmartDecodable {
    
    /// 反序列化为模型数组
    /// - Parameter array: 数组
    /// - Parameter decoder: 解码器，可以通过此完成一些配置，例如：keyDecodingStrategy。
    /// - Returns: 模型数组
    public static func deserialize(array: [Any]?, strategy: SmartKeyDecodingStrategy? = nil) -> [Element?]? {

        guard let _arr = array else {
            SmartLog.logDebug("\(Self.self)提供的反序列化的数组为空")
            return nil
        }
        
        guard let _json = _arr.toJSONString() else {
            SmartLog.logDebug("\(self)转json字符串失败")
            return nil
        }
        
        guard let _jsonData = _json.data(using: .utf8) else {
            SmartLog.logDebug("\(self) 转data失败")
            return nil
        }
        return deserialize(data: _jsonData, strategy: strategy)
    }
    
    
    /// 反序列化为模型数组
    /// - Parameter json: json字符串
    /// - Parameter decoder: 解码器，可以通过此完成一些配置，例如：keyDecodingStrategy。
    /// - Returns: 模型数组
    public static func deserialize(json: String?, strategy: SmartKeyDecodingStrategy? = nil) -> [Element?]? {
        guard let _json = json else {
            SmartLog.logDebug("提供的json为nil")
            return nil
        }
        
        
        guard let _jsonData = _json.data(using: .utf8) else {
            SmartLog.logDebug("\(self) 转data失败")
            return nil
        }
        
        return deserialize(data: _jsonData, strategy: strategy)
    }
    
    
    public static func deserialize(data: Data?, strategy: SmartKeyDecodingStrategy? = nil) -> [Element?]? {
        guard let _data = data else {
            SmartLog.logDebug("\(Self.self)中，提供的data为nil")
            return nil
        }
        
        do {
            return try _data._deserializeArray(type: Self.self, strategy: strategy)
        } catch  {
            return nil
        }
    }
}


extension Data {

    fileprivate func createDecoder<T>(type: T.Type, strategy: SmartKeyDecodingStrategy? = nil) -> JSONDecoder {
        let _decoder = JSONDecoder()
        var userInfo = _decoder.userInfo

        // 设置userInfo
        if let key = CodingUserInfoKey.typeName {
            userInfo.updateValue(type, forKey: key)
        }
        
        if let userInfoKey = CodingUserInfoKey.originData, let jsonObj = serialize() {
            userInfo.updateValue(jsonObj, forKey: userInfoKey)
        }
        
        if let temp = strategy, let key = CodingUserInfoKey.strategy {
            _decoder.keyDecodingStrategy = temp.toSystem()
            userInfo.updateValue(temp, forKey: key)
        }
        _decoder.userInfo = userInfo
        
        return _decoder
    }
    
    
    /// 字典
    fileprivate func _deserializeDict<T>(type: T.Type, strategy: SmartKeyDecodingStrategy? = nil) throws -> T? where T: SmartDecodable {

        do {
            let _decoder = createDecoder(type: type, strategy: strategy)
            var obj = try _decoder.decode(type, from: self)
            obj.didFinishMapping()
            return obj
        } catch {
            SmartLog.logError(error, className: "\(type)")
            return nil
        }
    }
    
    
    /// 数组
    fileprivate func _deserializeArray<T>(type: [T].Type, strategy: SmartKeyDecodingStrategy? = nil) throws -> [T]? where T: SmartDecodable {

        do {
            let _decoder = createDecoder(type: type, strategy: strategy)
                        
            let decodeValue = try _decoder.decode(type, from: self)
            var finishValue: [SmartDecodable] = []
            for var item in decodeValue {
                item.didFinishMapping()
                finishValue.append(item)
            }
            return finishValue as? [T]
        } catch {
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

extension Data {
    fileprivate func serialize() -> Any? {
        let value = try? JSONSerialization.jsonObject(with: self, options: .allowFragments)
        return value
    }
}

//
//  SmartDecodable.swift
//  SmartCodable
//
//  Created by qixin on 2023/9/4.
//

import Foundation


public typealias SmartMapping = (from: String, to: CodingKey)


/// Smart的解码协议
public protocol SmartDecodable: Decodable {
    /// 映射完成的完成的回调
    mutating func didFinishMapping()
  
    static func mapping() -> [SmartMapping]?
    
    init()
}


extension SmartDecodable {
    public mutating func didFinishMapping() { }
    public static func mapping() -> [SmartMapping]? { return nil }
}


extension JSONDecoder {
    /// SmartCodable解析的选项
    public enum SmartOption {
        
        /// 用于解码 “Date” 值的策略
        case dateStrategy(JSONDecoder.DateDecodingStrategy)
        
        /// 用于解码 “Data” 值的策略
        case dataStrategy(JSONDecoder.DataDecodingStrategy)
        
        /// 用于不符合json的浮点值(IEEE 754无穷大和NaN)的策略
        case floatStrategy(JSONDecoder.NonConformingFloatDecodingStrategy)
    }
}




extension SmartDecodable {
    
    /// 反序列化成模型
    /// - Parameter dict: 字典
    /// - Parameter options: 解码策略
    /// - Returns: 模型
    public static func deserialize(dict: [AnyHashable: Any]?, keyStrategy: JSONDecoder.SmartDecodingKey? = nil, options: [JSONDecoder.SmartOption]? = nil) -> Self? {
        guard let _dict = dict else {
            SmartLog.logDebug("要解析的字典为nil", className: "\(self)")
            return nil
        }
        
        guard let _json = _dict.toJSONString() else {
            SmartLog.logDebug("要解析的字典转json失败", className: "\(self)")
            return nil
        }
        guard let _jsonData = _json.data(using: .utf8) else {
            SmartLog.logDebug("要解析的字典转data失败", className: "\(self)")
            return nil
        }
        
        return deserialize(data: _jsonData, keyStrategy: keyStrategy, options: options)
    }
    
    /// 反序列化成模型
    /// - Parameter json: json字符串
    /// - Parameter options: 解码策略
    /// - Returns: 模型
    public static func deserialize(json: String?, keyStrategy: JSONDecoder.SmartDecodingKey? = nil, options: [JSONDecoder.SmartOption]? = nil) -> Self? {
        guard let _json = json else {
            SmartLog.logDebug("要解析的json字符串为nil", className: "\(self)")
            return nil
        }
    
        guard let jsonData = _json.data(using: .utf8) else {
            SmartLog.logDebug("要解析的json字符串转data失败", className: "\(self)")
            return nil
        }
        
        return deserialize(data: jsonData, keyStrategy: keyStrategy, options: options)
    }
    
    
    public static func deserialize(data: Data?, keyStrategy: JSONDecoder.SmartDecodingKey? = nil, options: [JSONDecoder.SmartOption]? = nil) -> Self? {
        guard let _data = data else {
            SmartLog.logDebug("要解析的data数据为nil", className: "\(self)")
            return nil
        }
        
        do {
            return try _data._deserializeDict(type: Self.self, keyStrategy: keyStrategy, options: options)
        } catch  {
            return nil
        }
    }
}




extension Array where Element: SmartDecodable {
    
    /// 反序列化为模型数组
    /// - Parameter array: 数组
    /// - Parameter options: 解码策略
    /// - Returns: 模型数组
    public static func deserialize(array: [Any]?, keyStrategy: JSONDecoder.SmartDecodingKey? = nil, options: [JSONDecoder.SmartOption]? = nil) -> [Element?]? {

        guard let _arr = array else {
            SmartLog.logDebug("要解析的数组为nil", className: "\(self)")
            return nil
        }
        
        guard let _json = _arr.toJSONString() else {
            SmartLog.logDebug("要解析的数组转json字符串失败", className: "\(self)")
            return nil
        }
        
        guard let _jsonData = _json.data(using: .utf8) else {
            SmartLog.logDebug("要解析的数组转data失败", className: "\(self)")
            return nil
        }
        return deserialize(data: _jsonData, keyStrategy: keyStrategy, options: options)
    }
    
    
    /// 反序列化为模型数组
    /// - Parameter json: json字符串
    /// - Parameter options: 解码策略
    /// - Returns: 模型数组
    public static func deserialize(json: String?, keyStrategy: JSONDecoder.SmartDecodingKey? = nil, options: [JSONDecoder.SmartOption]? = nil) -> [Element?]? {
        guard let _json = json else {
            SmartLog.logDebug("要解析的json为nil", className: "\(self)")
            return nil
        }
        
        
        guard let _jsonData = _json.data(using: .utf8) else {
            SmartLog.logDebug("要解析的json转data失败", className: "\(self)")
            return nil
        }
        
        return deserialize(data: _jsonData, keyStrategy: keyStrategy, options: options)
    }
    
    
    public static func deserialize(data: Data?, keyStrategy: JSONDecoder.SmartDecodingKey? = nil, options: [JSONDecoder.SmartOption]? = nil) -> [Element?]? {
        guard let _data = data else {
            SmartLog.logDebug("要解析的data数据为nil", className: "\(self)")
            return nil
        }
        
        do {
            return try _data._deserializeArray(type: Self.self, keyStrategy: keyStrategy, options: options)
        } catch  {
            return nil
        }
    }
}


extension Data {

    fileprivate func createDecoder<T>(type: T.Type, keyStrategy: JSONDecoder.SmartDecodingKey? = nil, options: [JSONDecoder.SmartOption]? = nil) -> JSONDecoder {
        let _decoder = SmartJSONDecoder()
        
        var userInfo = _decoder.userInfo

        // 设置userInfo
        if let key = CodingUserInfoKey.typeName {
            userInfo.updateValue(type, forKey: key)
        }
        
        if let userInfoKey = CodingUserInfoKey.originData, let jsonObj = serialize() {
            userInfo.updateValue(jsonObj, forKey: userInfoKey)
        }
        
        if let _options = options {
            for _option in _options {
                switch _option {
                case .dataStrategy(let strategy):
                    _decoder.dataDecodingStrategy = strategy
                    
                case .dateStrategy(let strategy):
                    _decoder.dateDecodingStrategy = strategy
                    
                case .floatStrategy(let strategy):
                    _decoder.nonConformingFloatDecodingStrategy = strategy
                }
            }
        }
        
        if let strategy = keyStrategy {
            _decoder.keyDecodingStrategy = strategy.toSystem()
            if let key = CodingUserInfoKey.keyDecodingStrategy {
                userInfo.updateValue(strategy, forKey: key)
            }
        }
        
        _decoder.userInfo = userInfo
        
        return _decoder
    }
    
    
    /// 字典
    fileprivate func _deserializeDict<T>(type: T.Type, keyStrategy: JSONDecoder.SmartDecodingKey? = nil, options: [JSONDecoder.SmartOption]? = nil) throws -> T? where T: SmartDecodable {

        do {
            let _decoder = createDecoder(type: type, keyStrategy: keyStrategy, options: options)
            var obj = try _decoder.decode(type, from: self)
            obj.didFinishMapping()
            return obj
        } catch {
            SmartLog.logError(error, className: "\(type)")
            return nil
        }
    }
    
    
    /// 数组
    fileprivate func _deserializeArray<T>(type: [T].Type, keyStrategy: JSONDecoder.SmartDecodingKey? = nil, options: [JSONDecoder.SmartOption]? = nil) throws -> [T]? where T: SmartDecodable {

        do {
            let _decoder = createDecoder(type: type, keyStrategy: keyStrategy, options: options)
                        
            let decodeValue = try _decoder.decode(type, from: self)
            return decodeValue
            // didFinishMapping 内部解码的时候已经实现了 废弃。
//            var finishValue: [SmartDecodable] = []
//            for var item in decodeValue {
//                item.didFinishMapping()
//                finishValue.append(item)
//            }
//            return finishValue as? [T]
        } catch {
            SmartLog.logError(error, className: "\(type)")
            return nil
        }
    }
}

/// [SmartCodable] 类型的数组支持解析。 内部已经实现，废弃。
//extension Array: SmartDecodable where Element: SmartDecodable {
//    public mutating func didFinishMapping() {
//        // 数组下标的遍历，完成didFinishMapping的调用
//        for index in indices {
//            self[index].didFinishMapping()
//        }
//    }
//}

extension CodingUserInfoKey {
    /// 类型的名称
    static var typeName = CodingUserInfoKey.init(rawValue: "Stamrt.typeName")
    /// 原始的字典
    static var originData = CodingUserInfoKey.init(rawValue: "Stamrt.originData")
    /// 解码策略
    static var keyDecodingStrategy = CodingUserInfoKey.init(rawValue: "Stamrt.keyDecodingStrategy")
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

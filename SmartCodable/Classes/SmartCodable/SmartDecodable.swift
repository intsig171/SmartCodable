//
//  SmartDecodable.swift
//  SmartCodable
//
//  Created by qixin on 2023/9/4.
//

import Foundation

/** mapping 的功能支持以及扩展性的考量
 * 1. 支持字段的重命名。
 * 2. ❓支持字段的解析忽略。【是否有技术手段】
 * 3. 支持自定义解析策略。（URL， Date， Data，Color...）
 
 

 * 如何考量后续的扩展性？
 * 使用一个基础协议。通过协议的继承的方式。
 
 */



/**
 前： key的映射， nickname -> name
 中： 内部的数据解析完的转义，时间戳转Date。
 后： 内部解码完成的回调, 就是：didFinishMapping
 */




/// Smart的解码协议
public protocol SmartDecodable: Decodable {
    /// 映射完成的完成的回调
    mutating func didFinishMapping()
  
    /// 映射关系
    static func mappingForKey() -> [SmartKeyTransformer]?
    
    static func mappingForValue() -> [SmartValueTransformer]?
    
    init()
}


extension SmartDecodable {
    public mutating func didFinishMapping() { }
    public static func mappingForKey() -> [SmartKeyTransformer]? { return nil }
    public static func mappingForValue() -> [SmartValueTransformer]? { return nil }
}


/// SmartCodable解析的选项
public enum SmartDecodingOption: Hashable {
    
    /// 用于解码 “Date” 值的策略
    case date(JSONDecoder.DateDecodingStrategy)
    
    /// 用于解码 “Data” 值的策略
    case data(JSONDecoder.DataDecodingStrategy)
    
    /// 用于不符合json的浮点值(IEEE 754无穷大和NaN)的策略
    case float(JSONDecoder.NonConformingFloatDecodingStrategy)
    
    case key(JSONDecoder.SmartKeyDecodingStrategy)
    
    /// 处理哈希值，忽略关联值的影响。
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .date:
            hasher.combine(0)
        case .data:
            hasher.combine(1)
        case .float:
            hasher.combine(2)
        case .key:
            hasher.combine(3)
        }
    }
    
    public static func == (lhs: SmartDecodingOption, rhs: SmartDecodingOption) -> Bool {
        switch (lhs, rhs) {
        case (.date, .date):
            return true
        case (.data, .data):
            return true
        case (.float, .float):
            return true
        case (.key, .key):
            return true
        default:
            return false
        }
    }
}


extension SmartDecodable {
    
    /// 反序列化成模型
    /// - Parameter dict: 字典
    /// - Parameter options: 解码策略
    ///   不允许出现相同的枚举项，eg：不可以传入多个keyStrategy【只有第一个有效】。
    /// - Returns: 模型
    public static func deserialize(from dict: [String: Any]?, options: Set<SmartDecodingOption>? = nil) -> Self? {
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
        
        return deserialize(from: _jsonData, options: options)
    }
    
    /// 反序列化成模型
    /// - Parameter json: json字符串
    /// - Parameter options: 解码策略
    ///   不允许出现相同的枚举项，eg：不可以传入多个keyStrategy【只有第一个有效】。
    /// - Returns: 模型
    public static func deserialize(from json: String?, options: Set<SmartDecodingOption>? = nil) -> Self? {
        guard let _json = json else {
            SmartLog.logDebug("要解析的json字符串为nil", className: "\(self)")
            return nil
        }
    
        guard let jsonData = _json.data(using: .utf8) else {
            SmartLog.logDebug("要解析的json字符串转data失败", className: "\(self)")
            return nil
        }
        
        return deserialize(from: jsonData, options: options)
    }
    
    
    /// 反序列化成模型
    /// - Parameter data: data
    /// - Parameter options: 解码策略
    ///   不允许出现相同的枚举项，eg：不可以传入多个keyStrategy【只有第一个有效】。
    /// - Returns: 模型
    public static func deserialize(from data: Data?, options: Set<SmartDecodingOption>? = nil) -> Self? {
        guard let _data = data else {
            SmartLog.logDebug("要解析的data数据为nil", className: "\(self)")
            return nil
        }
        
        do {
            return try _data._deserializeDict(type: Self.self, options: options)
        } catch  {
            return nil
        }
    }
}




extension Array where Element: SmartDecodable {
    
    /// 反序列化为模型数组
    /// - Parameter array: 数组
    /// - Parameter options: 解码策略
    ///   不允许出现相同的枚举项，eg：不可以传入多个keyStrategy【只有第一个有效】。
    /// - Returns: 模型数组
    public static func deserialize(from array: [Any]?, options: Set<SmartDecodingOption>? = nil) -> [Element]? {

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
        return deserialize(from: _jsonData, options: options)
    }
    
    
    /// 反序列化为模型数组
    /// - Parameter json: json字符串
    /// - Parameter options: 解码策略
    ///   只允许出现一个枚举项，eg：不可以传入多个keyStrategy【只有第一个有效】
    /// - Returns: 模型数组
    public static func deserialize(from json: String?, options: Set<SmartDecodingOption>? = nil) -> [Element]? {
        guard let _json = json else {
            SmartLog.logDebug("要解析的json为nil", className: "\(self)")
            return nil
        }
        
        
        guard let _jsonData = _json.data(using: .utf8) else {
            SmartLog.logDebug("要解析的json转data失败", className: "\(self)")
            return nil
        }
        
        return deserialize(from: _jsonData, options: options)
    }
    
    /// 反序列化为模型数组
    /// - Parameter data: data
    /// - Parameter options: 解码策略
    ///   不允许出现相同的枚举项，eg：不可以传入多个keyStrategy【只有第一个有效】
    /// - Returns: 模型数组
    public static func deserialize(from data: Data?, options: Set<SmartDecodingOption>? = nil) -> [Element]? {
        guard let _data = data else {
            SmartLog.logDebug("要解析的data数据为nil", className: "\(self)")
            return nil
        }
        
        do {
            return try _data._deserializeArray(type: Self.self, options: options)
        } catch  {
            return nil
        }
    }
}


extension Data {

    fileprivate func createDecoder<T>(type: T.Type, options: Set<SmartDecodingOption>? = nil) -> JSONDecoder {
        let _decoder = SmartJSONDecoder()
        

        if let _options = options {
            for _option in _options {
                switch _option {
                case .data(let strategy):
                    _decoder.dataDecodingStrategy = strategy
                    
                case .date(let strategy):
                    _decoder.dateDecodingStrategy = strategy
                    
                case .float(let strategy):
                    _decoder.nonConformingFloatDecodingStrategy = strategy
                case .key(let strategy):
                    _decoder.smartKeyDecodingStrategy = strategy
                }
            }
        }
        
        return _decoder
    }
    
    
    /// 字典
    fileprivate func _deserializeDict<T>(type: T.Type, options: Set<SmartDecodingOption>? = nil) throws -> T? where T: SmartDecodable {

        do {
            let _decoder = createDecoder(type: type, options: options)
            var obj = try _decoder.decode(type, from: self)
            obj.didFinishMapping()
            return obj
        } catch {
            SmartLog.logError(error, className: "\(type)")
            return nil
        }
    }
    
    
    /// 数组
    fileprivate func _deserializeArray<T>(type: [T].Type, options: Set<SmartDecodingOption>? = nil) throws -> [T]? where T: SmartDecodable {

        do {
            let _decoder = createDecoder(type: type, options: options)
            let decodeValue = try _decoder.decode(type, from: self)
            return decodeValue
        } catch {
            SmartLog.logError(error, className: "\(type)")
            return nil
        }
    }
}


// MARK: - 扩展实现
extension Dictionary where Key == String {
    /// 字典转Json字符串
    fileprivate func toJSONString() -> String? {

        let peeledDict = self.peelIfPresent
        guard JSONSerialization.isValidJSONObject(peeledDict) else { return nil }
        
        if let data = try? JSONSerialization.data(withJSONObject: peeledDict) {
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
        let peeledArr = self.peelIfPresent
        guard JSONSerialization.isValidJSONObject(peeledArr) else { return nil }
        do {
            let data = try JSONSerialization.data(withJSONObject: peeledArr, options: [])
            let json = String(data: data, encoding: String.Encoding.utf8)
            return json
        } catch {
            return nil
        }
    }
}


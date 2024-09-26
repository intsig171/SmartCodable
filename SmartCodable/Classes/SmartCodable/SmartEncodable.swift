//
//  SmartEncodable.swift
//  SmartCodable
//
//  Created by Mccc on 2023/9/4.
//

import Foundation


public protocol SmartEncodable: Encodable {
    /// The callback for when mapping is complete
    mutating func didFinishMapping()
  
    /// The mapping relationship of decoding keys
    static func mappingForKey() -> [SmartKeyTransformer]?
    
    /// The strategy for decoding values
    static func mappingForValue() -> [SmartValueTransformer]?
    
    init()
}


/// Options for SmartCodable parsing
public enum SmartEncodingOption: Hashable {
    
    
    /// date的默认策略是ReferenceDate（参考日期是指2001年1月1日 00:00:00 UTC），以秒为单位。
    case date(JSONEncoder.DateEncodingStrategy)
    
    case data(JSONEncoder.DataEncodingStrategy)
    
    case float(JSONEncoder.NonConformingFloatEncodingStrategy)
    
    /// The mapping strategy for keys during parsing
    case key(JSONEncoder.SmartKeyEncodingStrategy)
    
    /// Handles the hash value, ignoring the impact of associated values.
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
    
    public static func == (lhs: SmartEncodingOption, rhs: SmartEncodingOption) -> Bool {
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


extension SmartEncodable {

    /// Serializes into a dictionary
    /// - Parameter useMappedKeys: Whether to use the mapped key during encoding. The default value is false.
    /// - Parameter options: encoding options
    /// - Returns: dictionary
    public func toDictionary(useMappedKeys: Bool = false, options: Set<SmartEncodingOption>? = nil) -> [String: Any]? {
        return _transformToJson(self, type: Self.self, useMappedKeys: useMappedKeys, options: options)
    }
    
    /// Serializes into a JSON string
    /// - Parameter useMappedKeys: Whether to use the mapped key during encoding. The default value is false.
    /// - Parameter options: encoding options
    /// - Parameter prettyPrint: Whether to format print (adds line breaks in the JSON)
    /// - Returns: JSON string
    public func toJSONString(useMappedKeys: Bool = false, options: Set<SmartEncodingOption>? = nil, prettyPrint: Bool = false) -> String? {
        if let anyObject = toDictionary(useMappedKeys: useMappedKeys, options: options) {
            return _transformToJsonString(object: anyObject, prettyPrint: prettyPrint, type: Self.self)
        }
        return nil
    }
}


extension Array where Element: SmartEncodable {
    /// Serializes into a array
    /// - Parameter useMappedKeys: Whether to use the mapped key during encoding. The default value is false.
    /// - Returns: array
    public func toArray(useMappedKeys: Bool = false, options: Set<SmartEncodingOption>? = nil) -> [Any]? {
        return _transformToJson(self,type: Element.self, useMappedKeys: useMappedKeys, options: options)
    }
    
    /// Serializes into a JSON string
    /// - Parameter useMappedKeys: Whether to use the mapped key during encoding. The default value is false.
    /// - Parameter options: encoding options
    /// - Parameter prettyPrint: Whether to format print (adds line breaks in the JSON)
    /// - Returns: JSON string
    public func toJSONString(useMappedKeys: Bool = false, options: Set<SmartEncodingOption>? = nil, prettyPrint: Bool = false) -> String? {
        if let anyObject = toArray(useMappedKeys: useMappedKeys, options: options) {
            return _transformToJsonString(object: anyObject, prettyPrint: prettyPrint, type: Element.self)
        }
        return nil
    }
}



fileprivate func _transformToJson<T>(_ some: Encodable, type: Any.Type, useMappedKeys: Bool, options: Set<SmartEncodingOption>? = nil) -> T? {
    
    let jsonEncoder = SmartJSONEncoder()
    
    if useMappedKeys, let key = CodingUserInfoKey.useMappedKeys {
        var userInfo = jsonEncoder.userInfo
        userInfo.updateValue(true, forKey: key)
        jsonEncoder.userInfo = userInfo
    }
    
    if let _options = options {
        for _option in _options {
            switch _option {
            case .data(let strategy):
                jsonEncoder.dataEncodingStrategy = strategy
                
            case .date(let strategy):
                jsonEncoder.dateEncodingStrategy = strategy
                
            case .float(let strategy):
                jsonEncoder.nonConformingFloatEncodingStrategy = strategy
            case .key(let strategy):
                jsonEncoder.smartKeyEncodingStrategy = strategy
            }
        }
    }
    
    
    if let jsonData = try? jsonEncoder.encode(some) {
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .fragmentsAllowed)
            if let temp = json as? T {
                return temp
            } else {
                SmartLog.logVerbose("\(json)) is not a valid Type", in: "\(type)")
            }
        } catch {
            SmartLog.logVerbose("\(error)", in: "\(type)")
        }
    }
    return nil
}



fileprivate func _transformToJsonString(object: Any, prettyPrint: Bool = false, type: Any.Type) -> String? {
    if JSONSerialization.isValidJSONObject(object) {
        do {
            let options: JSONSerialization.WritingOptions = prettyPrint ? [.prettyPrinted] : []
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: options)
            return String(data: jsonData, encoding: .utf8)
            
        } catch {
            SmartLog.logVerbose("\(error)", in: "\(type)")
        }
    } else {
        SmartLog.logVerbose("\(object)) is not a valid JSON Object", in: "\(type)")
    }
    return nil
}

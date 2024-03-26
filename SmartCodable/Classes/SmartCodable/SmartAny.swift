//
//  SmartAny.swift
//  SmartCodable
//
//  Created by qixin on 2023/12/1.
//

import Foundation

/** SmartAny:
 * Codable不支持对Any类型解析，那么对应的Any类型，字典类型（[String: Any]），数组类型[Any] 都无法解析。
 *
 */

/// 任意Smart类型，可以简单的理解为Any。
///
/// Codable不支持对Any类型解析，那么对应的Any类型，字典类型（[String: Any]），数组类型[Any] 都无法解析。
/// 通过SmartAny包裹一层，达到可以对Any解析的目的。
///
/// 获取的原始的值需要调用 '.peel' 进行去壳。
public enum SmartAny {
    
    case bool(Bool)
    
    case string(String)
    
    case double(Double)
    case cgFloat(CGFloat)
    case float(Float)
    
    case int(Int)
    case int8(Int8)
    case int16(Int16)
    case int32(Int32)
    case int64(Int64)
    
    case uInt(UInt)
    case uInt8(UInt8)
    case uInt16(UInt16)
    case uInt32(UInt32)
    case uInt64(UInt64)
    
    
    case dict([String: SmartAny])
    case array([SmartAny])
    
    
    case null(NSNull)
}

extension Dictionary where Key == String, Value == SmartAny {
    /// 解析完成会被SmartAny包裹，使用该属性去壳。
    public var peel: [String: Any] {
        // mapValues 是 Swift 标准库中 Dictionary 类型的一个方法，它用于对字典中的所有值进行转换，同时保持键不变。
        mapValues { $0.peel }
    }
}

extension Array where Element == SmartAny {
    /// 解析完成会被SmartAny包裹，使用该属性去壳。
    public var peel: [Any] {
        map { $0.peel }
    }
}

extension SmartAny {
    /// 获取原本的值
    public var peel: Any {
        switch self {
        case .bool(let v):
            return v
            
        case .string(let v):
            return v
            
        case .double(let v):
            return v
        case .cgFloat(let v):
            return v
        case .float(let v):
            return v
            
        case .int(let v):
            return v
        case .int8(let v):
            return v
        case .int16(let v):
            return v
        case .int32(let v):
            return v
        case .int64(let v):
            return v
            
            
        case .uInt(let v):
            return v
        case .uInt8(let v):
            return v
        case .uInt16(let v):
            return v
        case .uInt32(let v):
            return v
        case .uInt64(let v):
            return v
            
        case .dict(let v):
            return v.peel
        case .array(let v):
            return v.peel
            
        case .null:
            return NSNull()
            
        }
    }
}





extension SmartAny: Codable {
    // 实现 Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        
        
        guard let decoder = decoder as? _SmartJSONDecoder else {
            throw DecodingError.typeMismatch(SmartAny.self, DecodingError.Context(
                codingPath: decoder.codingPath, debugDescription: "Expected \(Self.self) value，but an exception occurred！Please report this issue（请上报该问题）")
            )
        }
        
        if container.decodeNil() {
            self = .null(NSNull())
        }
        if let value = try? decoder.unbox(decoder.storage.topContainer, as: SmartAny.self) {
            self = value
        } else if let value = try? decoder.unbox(decoder.storage.topContainer, as: [String: SmartAny].self) {
            self = .dict(value)
        } else if let value = try? decoder.unbox(decoder.storage.topContainer, as: [SmartAny].self) {
            self = .array(value)
        }
        
        else {
            throw DecodingError.typeMismatch(SmartAny.self, DecodingError.Context(
                codingPath: decoder.codingPath, debugDescription: "Expected \(Self.self) value，but an exception occurred！Please report this issue（请上报该问题）")
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .null:
            try container.encodeNil()
            
        case .bool(let value):
            try container.encode(value)
            
        case .string(let value):
            try container.encode(value)
            
        case .double(let value):
            try container.encode(value)
        case .cgFloat(let value):
            try container.encode(value)
        case .float(let value):
            try container.encode(value)
            
        case .int(let intValue):
            try container.encode(intValue)
        case .int8(let value):
            try container.encode(value)
        case .int16(let value):
            try container.encode(value)
        case .int32(let value):
            try container.encode(value)
        case .int64(let value):
            try container.encode(value)
            
        case .uInt(let intValue):
            try container.encode(intValue)
        case .uInt8(let value):
            try container.encode(value)
        case .uInt16(let value):
            try container.encode(value)
        case .uInt32(let value):
            try container.encode(value)
        case .uInt64(let value):
            try container.encode(value)
            
        case .dict(let dictValue):
            try container.encode(dictValue)
        case .array(let dictValue):
            try container.encode(dictValue)
        }
    }
}


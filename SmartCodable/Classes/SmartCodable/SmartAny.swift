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
    case double(Double), cgFloat(CGFloat), float(Float)
    case int(Int), int8(Int8), int16(Int16), int32(Int32), int64(Int64)
    case uInt(UInt), uInt8(UInt8), uInt16(UInt16), uInt32(UInt32), uInt64(UInt64)
    case dict([String: SmartAny])
    case array([SmartAny])
    case null(NSNull)
    
    /// 从 Any 类型转换为 SmartAny
    public init(from value: Any) {
        self = .convertToSmartAny(value)
    }
}

extension Dictionary where Key == String, Value == Any {
    /// 从 [String: Any] 类型转换为 [String: SmartAny]
    public var cover: [String: SmartAny] {
        mapValues { SmartAny(from: $0) }
    }
}

extension Array where Element == Any {
    /// 从 [Any] 类型转换为 [SmartAny]
    public var cover: [ SmartAny] {
        map { SmartAny(from: $0) }
    }
}


extension Dictionary where Key == String, Value == SmartAny {
    /// 解析完成会被SmartAny包裹，使用该属性去壳。
    public var peel: [String: Any] {
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
        case .bool(let v):    return v
        case .string(let v):  return v
        case .double(let v):  return v
        case .cgFloat(let v): return v
        case .float(let v):   return v
        case .int(let v):     return v
        case .int8(let v):    return v
        case .int16(let v):   return v
        case .int32(let v):   return v
        case .int64(let v):   return v
        case .uInt(let v):    return v
        case .uInt8(let v):   return v
        case .uInt16(let v):  return v
        case .uInt32(let v):  return v
        case .uInt64(let v):  return v
        case .dict(let v):    return v.peel
        case .array(let v):   return v.peel
        case .null:           return NSNull()
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
        } else {
            throw DecodingError.typeMismatch(SmartAny.self, DecodingError.Context(
                codingPath: decoder.codingPath, debugDescription: "Expected \(Self.self) value，but an exception occurred！Please report this issue（请上报该问题）")
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .null:                 try container.encodeNil()
        case .bool(let value):      try container.encode(value)
        case .string(let value):    try container.encode(value)
        case .double(let value):    try container.encode(value)
        case .cgFloat(let value):   try container.encode(value)
        case .float(let value):     try container.encode(value)
        case .int(let intValue):    try container.encode(intValue)
        case .int8(let value):      try container.encode(value)
        case .int16(let value):     try container.encode(value)
        case .int32(let value):     try container.encode(value)
        case .int64(let value):     try container.encode(value)
        case .uInt(let intValue):   try container.encode(intValue)
        case .uInt8(let value):     try container.encode(value)
        case .uInt16(let value):    try container.encode(value)
        case .uInt32(let value):    try container.encode(value)
        case .uInt64(let value):    try container.encode(value)
        case .dict(let dictValue):  try container.encode(dictValue)
        case .array(let dictValue): try container.encode(dictValue)
        }
    }
}



extension SmartAny {
    // 辅助函数，将 Any 类型的值转换为 SmartAny
    private static func convertToSmartAny(_ value: Any) -> SmartAny {
        switch value {
        case let v as Bool:          return .bool(v)
        case let v as String:        return .string(v)
        case let v as Double:        return .double(v)
        case let v as CGFloat:       return .cgFloat(v)
        case let v as Float:         return .float(v)
        case let v as Int:           return .int(v)
        case let v as Int8:          return .int8(v)
        case let v as Int16:         return .int16(v)
        case let v as Int32:         return .int32(v)
        case let v as Int64:         return .int64(v)
        case let v as UInt:          return .uInt(v)
        case let v as UInt8:         return .uInt8(v)
        case let v as UInt16:        return .uInt16(v)
        case let v as UInt32:        return .uInt32(v)
        case let v as UInt64:        return .uInt64(v)
        case let v as [String: Any]: return .dict(v.mapValues { convertToSmartAny($0) })
        case let v as [Any]:         return .array(v.map { convertToSmartAny($0) })
        case is NSNull:              return .null(NSNull())
        default:                      return .null(NSNull()) // 对于不支持的类型，返回 null
        }
    }
}

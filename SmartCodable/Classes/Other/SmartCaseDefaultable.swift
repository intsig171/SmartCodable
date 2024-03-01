//
//  CaseDefaultable.swift
//  BTCodable
//
//  Created by Mccc on 2023/8/1.
//

// 参考： https://github.com/line/line-sdk-ios-swift/blob/master/LineSDK/LineSDK/Networking/Model/CustomizeCoding/CodingExtension.swift

import Foundation

/// 枚举解码失败的默认值
public protocol SmartCaseDefaultable: RawRepresentable, Codable {
    /// 使用接收到的数据，无法用枚举类型中的任何值表示而导致解析失败，使用此默认值。
    static var defaultCase: Self { get }
}

public extension SmartCaseDefaultable where Self: Decodable, Self.RawValue: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decoded = try container.decode(RawValue.self)
        if let v = Self.init(rawValue: decoded) {
            self = v
        } else {
            // 解码失败抛出异常，让上层container选择性处理，如果是可选就返回nil，如果是非可选就返回defaultCase。
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"))
        }
    }
}



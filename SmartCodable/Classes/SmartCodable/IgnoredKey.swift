//
//  Ignored.swift
//  SmartCodable
//
//  Created by qixin on 2024/4/30.
//

import Foundation

@propertyWrapper
public struct IgnoredKey<T>: Codable {
    public var wrappedValue: T

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        guard let decoder = decoder as? _SmartJSONDecoder else {
            throw DecodingError.typeMismatch(IgnoredKey<T>.self, DecodingError.Context(
                codingPath: decoder.codingPath, debugDescription: "Expected \(Self.self) value，but an exception occurred！Please report this issue（请上报该问题）")
            )
        }
        wrappedValue = try decoder.smartDecode(type: T.self)
    }

    public func encode(to encoder: Encoder) throws {
        // 如果 wrappedValue 符合 Encodable 协议，则手动进行编码
        if let encodableValue = wrappedValue as? Encodable {
            try encodableValue.encode(to: encoder)
        } else {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}
extension _SmartJSONDecoder {
    fileprivate func smartDecode<T>(type: T.Type) throws -> T {

        if let key = codingPath.last, let value: T = cache.getValue(forKey: key) {
            return value
        } else {
            return try Patcher<T>.defaultForType()
        }
    }
}

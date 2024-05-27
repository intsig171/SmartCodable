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
        
        // 将异常抛出，在解析容器中进行兼容。
        throw DecodingError.typeMismatch(IgnoredKey<T>.self, DecodingError.Context(
            codingPath: decoder.codingPath, debugDescription: "\(Self.self) does not participate in the parsing, please ignore it.")
        )
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

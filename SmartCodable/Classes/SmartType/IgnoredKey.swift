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
        
        guard let impl = decoder as? JSONDecoderImpl else {
            wrappedValue = try Patcher<T>.defaultForType()
            return
        }
        
        // 属性被IgnoredKey修饰的时，如果自定义了该属性的解析策略，在此支持
        if let key = impl.codingPath.last {
            if let decoded = impl.cache.tranform(value: impl.json, for: key) as? T {
                wrappedValue = decoded
                return
            }
        }
        
        /// Only those using the SmartJSONDecoder parser have the ability to be compatible with thrown exceptions.
        if let key = CodingUserInfoKey.parsingMark, let _ = impl.userInfo[key] {
            // 将异常抛出，在解析容器中进行兼容。
            throw DecodingError.typeMismatch(IgnoredKey<T>.self, DecodingError.Context(
                codingPath: decoder.codingPath, debugDescription: "\(Self.self) does not participate in the parsing, please ignore it.")
            )
        }
        
        /// The resolution triggered by the other three parties may be resolved here.
        wrappedValue = try impl.smartDecode(type: T.self)
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
extension JSONDecoderImpl {
    fileprivate func smartDecode<T>(type: T.Type) throws -> T {

        if let key = codingPath.last, let value: T = cache.getValue(forKey: key) {
            return value
        } else {
            return try Patcher<T>.defaultForType()
        }
    }
}

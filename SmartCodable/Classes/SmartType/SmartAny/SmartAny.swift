//
//  SmartAny.swift
//  SmartCodable
//
//  Created by qixin on 2024/6/13.
//

/// Attribute wrapper, used to wrap Any.SmartAny allows only Any, [Any], and [String: Any] types to be modified.
@propertyWrapper
public struct SmartAny<T>: Codable {
    public var wrappedValue: T

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        guard let decoder = decoder as? JSONDecoderImpl else {
            throw DecodingError.typeMismatch(SmartAnyImpl.self, DecodingError.Context(
                codingPath: decoder.codingPath, debugDescription: "Expected \(Self.self) value，but an exception occurred！Please report this issue（请上报该问题）")
            )
        }
        let value = decoder.json
        if let key = decoder.codingPath.last {
            // Note the case where T is nil. nil as? T is true.
            if let cached = decoder.cache.tranform(value: value, for: key),
               let decoded = cached as? T {
                self = .init(wrappedValue: decoded)
                return
            }
        }
                
        if let new = try? decoder.unwrap(as: SmartAnyImpl.self),
           let peel = new.peel as? T {
            self = .init(wrappedValue: peel)
        } else {
            // Exceptions thrown in the parse container will be compatible.
            throw DecodingError.typeMismatch(Self.self, DecodingError.Context(
                codingPath: decoder.codingPath, debugDescription: "Expected \(Self.self) value，but an exception occurred！")
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        
        if let dict = wrappedValue as? [String: Any] {
            let value = dict.cover
            try container.encode(value)
        } else if let arr = wrappedValue as? [Any] {
            let value = arr.cover
            try container.encode(value)
        } else if let model = wrappedValue as? SmartCodable {
            try container.encode(model)
        } else {
            let value = SmartAnyImpl(from: wrappedValue)
            try container.encode(value)
        }
    }
}



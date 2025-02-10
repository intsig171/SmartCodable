//
//  NullEncoding.swift
//  
//
//  Created by PJ Fechner on 7/12/20.
//

import Foundation
//MARK: - EncodeNulls

public protocol AnyNullEncoder {
    associatedtype T: Encodable
    static func encode(value: T, to encoder: Encoder) throws
}

/// Encodes a nil value in a singleValueContainer using `encodeNil` rather than it being omitted.
public struct NullStaticEncoder<T: Encodable>: StaticEncoder, AnyNullEncoder where T: ExpressibleByNilLiteral {
    public static func encode(value: T, to encoder: Encoder) throws {

        if case Optional<Any>.none = value as Any {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
            return
        }
        try value.encode(to: encoder)
    }
}


extension KeyedEncodingContainer {
    // Used to make bybass the `OptionalCodingWrappers` which encodes no value when it's wrappedValue is nil.
    public mutating func encode<T>(_ value: T, forKey key: KeyedEncodingContainer<K>.Key) throws where T: OptionalEncodingWrapper & StaticEncoderWrapper, T.CustomEncoder: AnyNullEncoder {
        try T.CustomEncoder.encode(value: value.wrappedValue, to: superEncoder(forKey: key))
    }
    
    // Used to bybass the `OptionalCodingWrappers` when wrapped in an `Immutable`, which encodes no value when it's wrappedValue.wrappedValue is nil.
    public mutating func encode<T>(_ value: T, forKey key: KeyedEncodingContainer<K>.Key) throws where T: Encodable, T: AnyImmutableWrapper, T.T: OptionalEncodingWrapper & StaticEncoderWrapper, T.T.CustomEncoder: AnyNullEncoder {
        try T.T.CustomEncoder.encode(value: value.wrappedValue.wrappedValue, to: superEncoder(forKey: key))
    }
}

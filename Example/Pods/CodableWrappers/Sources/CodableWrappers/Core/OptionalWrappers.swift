//
//  OptionalWrappers.swift
//
//  Copyright © 2019 PJ Fechner. All rights reserved.

import Foundation

//MARK: - OptionalWrapper

public protocol OptionalEncodingWrapper {
    associatedtype WrappedType: ExpressibleByNilLiteral
    var wrappedValue: WrappedType { get }
}

public protocol OptionalDecodingWrapper {
    associatedtype WrappedType: ExpressibleByNilLiteral
    init(wrappedValue: WrappedType)
}
/// Protocol for a PropertyWrapper to properly handle Coding when the wrappedValue is Optional
public typealias OptionalCodingWrapper = OptionalEncodingWrapper & OptionalDecodingWrapper


extension KeyedDecodingContainer {
    // This is used to override the default decoding behavior for OptionalWrapper to avoid a missing key Error
    public func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T : Decodable, T: OptionalDecodingWrapper {
        return try decodeIfPresent(T.self, forKey: key) ?? T(wrappedValue: nil)
    }
}

extension KeyedEncodingContainer {
    // Used to make make sure OptionalCodingWrappers encode no value when it's wrappedValue is nil.
    public mutating func encode<T>(_ value: T, forKey key: KeyedEncodingContainer<K>.Key) throws where T: Encodable, T: OptionalEncodingWrapper {

        if case Optional<Any>.none = value.wrappedValue as Any {
            return
        }

        try encodeIfPresent(value, forKey: key)
    }
}

//MARK: - OptionalCoding and Wrapper

/// Contract for a Type that wraps a StaticEncoder and makes it usable when the WrappedType is Optional
public protocol OptionalEncodable: Encodable, OptionalEncodingWrapper where WrappedType == EncoderWrapper.CustomEncoder.OriginalType? {
    associatedtype EncoderWrapper: StaticEncoderWrapper
}

public extension OptionalEncodable {
    // Encodes the wrappedValue using the CustomEncoder if the value exists
    func encode(to encoder: Encoder) throws {
        if let wrappedValue = wrappedValue {
            try EncoderWrapper.CustomEncoder.encode(value: wrappedValue, to: encoder)
        }
    }
}

/// Contract for a Type that wraps a StaticDecoder and makes it usable the WrappedType is Optional
public protocol OptionalDecodable: Decodable, OptionalDecodingWrapper where WrappedType == DecoderWrapper.CustomDecoder.DecodedType? {
    associatedtype DecoderWrapper: StaticDecoderWrapper
}

extension OptionalDecodable {
    // Decodes using the DecoderWrapper's CustomDecoder
    // This should never be called due to KeyedDecodingContainer.decode overriding it.
    public init(from decoder: Decoder) throws {
        self.init(wrappedValue: try? DecoderWrapper.CustomDecoder.decode(from: decoder))
    }
}

/// Combination of OptionalStaticDecoding and OptionalStaticEncoding
public typealias OptionalCodable = OptionalDecodable & OptionalEncodable

/// Wraps `StaticEncoderWrapper` generically to allow the wrapped property to be Optional
@propertyWrapper
public struct OptionalEncoding<CustomDecoderWrapper: StaticEncoderWrapper>: OptionalEncodable {
    public typealias EncoderWrapper = CustomDecoderWrapper

    public var wrappedValue: CustomDecoderWrapper.CustomEncoder.OriginalType?
    public init(wrappedValue: CustomDecoderWrapper.CustomEncoder.OriginalType?) {
        self.wrappedValue = wrappedValue
    }
}

/// Wraps `StaticDecoderWrapper` generically to allow the wrapped property to be Optional
@propertyWrapper
public struct OptionalDecoding<CustomDecoderWrapper: StaticDecoderWrapper>: OptionalDecodable {
    public typealias DecoderWrapper = CustomDecoderWrapper

    public var wrappedValue: CustomDecoderWrapper.CustomDecoder.DecodedType?
    public init(wrappedValue: CustomDecoderWrapper.CustomDecoder.DecodedType?) {
        self.wrappedValue = wrappedValue
    }
}

/// Wraps `StaticCodingWrapper` generically to allow the wrapped property to be Optional
@propertyWrapper
public struct OptionalCoding<CustomCoderWrapper: StaticCodingWrapper>: OptionalCodable {

    public typealias DecoderWrapper = CustomCoderWrapper
    public typealias EncoderWrapper = CustomCoderWrapper

    public var wrappedValue: CustomCoderWrapper.CustomEncoder.OriginalType?
    public init(wrappedValue: CustomCoderWrapper.CustomDecoder.DecodedType?) {
        self.wrappedValue = wrappedValue
    }
}

//MARK: Enable Customizing one direction

/// Ensures there isn't an extra level added
extension OptionalEncoding: Decodable, TransientDecodable where CustomDecoderWrapper.CustomEncoder.OriginalType: Decodable { }
/// Ensures there isn't an extra level added
extension OptionalDecoding: Encodable, TransientEncodable where CustomDecoderWrapper.CustomDecoder.DecodedType: Encodable { }

//MARK: Conditional Equatable Conformance

extension OptionalEncoding: Equatable where CustomDecoderWrapper.CustomEncoder.OriginalType: Equatable {}
extension OptionalDecoding: Equatable where CustomDecoderWrapper.CustomDecoder.DecodedType: Equatable {}
extension OptionalCoding: Equatable where CustomCoderWrapper.CustomEncoder.OriginalType: Equatable {}

//MARK: Conditional Hashable Conformance

extension OptionalEncoding: Hashable where CustomDecoderWrapper.CustomEncoder.OriginalType: Hashable {}
extension OptionalDecoding: Hashable where CustomDecoderWrapper.CustomDecoder.DecodedType: Hashable {}
extension OptionalCoding: Hashable where CustomCoderWrapper.CustomEncoder.OriginalType: Hashable {}



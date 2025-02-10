//
//  CustomPropertyCoding.swift
//  
//
//  Created by PJ Fechner on 9/26/19.
//  Copyright © 2019 PJ Fechner. All rights reserved.

import Foundation

//MARK: - Custom Coding Property Wrappers

/// Customize the encoding of a property using the `CustomEncoder`
@propertyWrapper
public struct EncodingUses<CustomEncoder: StaticEncoder>: StaticEncoderWrapper {

    public var wrappedValue: CustomEncoder.OriginalType
    public init(wrappedValue: CustomEncoder.OriginalType) {
        self.wrappedValue = wrappedValue
    }
}

/// Customize the decoding of a property using the `CustomDecoder`
@propertyWrapper
public struct DecodingUses<CustomDecoder: StaticDecoder>: StaticDecoderWrapper {

    public var wrappedValue: CustomDecoder.DecodedType
    public init(wrappedValue: CustomDecoder.DecodedType) {
        self.wrappedValue = wrappedValue
    }
}

/// Customize the encoding and decoding of a property using the `CustomCoder`
@propertyWrapper
public struct CodingUses<CustomCoder: StaticCoder>: StaticCodingWrapper {
    public typealias CustomEncoder = CustomCoder
    public typealias CustomDecoder = CustomCoder

    public var wrappedValue: CustomCoder.CodingType
    public init(wrappedValue: CustomCoder.CodingType) {
        self.wrappedValue = wrappedValue
    }
}

//MARK: - Static Coding Wrapper Protocols

/// Contract for a Static Encoding Property Wrapper
/// This allows multiple wrappers to use the same `encode(to encoder: Encoder)` rather than reimplementing it.
public protocol StaticEncoderWrapper: Encodable {
    associatedtype CustomEncoder: StaticEncoder
    /// The value to be encoded
    var wrappedValue: CustomEncoder.OriginalType { get }
}

extension StaticEncoderWrapper {
    /// Encodes the `wrappedValue` using the `CustomEncoder`
    public func encode(to encoder: Encoder) throws {
        try CustomEncoder.encode(value: wrappedValue, to: encoder)
    }
}

/// Contract for a Static Decoding Property Wrapper
/// This allows multiple wrappers to use the same `init(from decoder: Decoder)` rather than reimplementing it.
public protocol StaticDecoderWrapper: Decodable {
    associatedtype CustomDecoder: StaticDecoder
    init(wrappedValue: CustomDecoder.DecodedType)
}

extension StaticDecoderWrapper {
    /// Decodes the `wrappedValue`  using the `CustomDecoder`
    public init(from decoder: Decoder) throws {
        self.init(wrappedValue: try CustomDecoder.decode(from: decoder))
    }
}

/// Combines `StaticEncoderWrapper` and `StaticDecoderWrapper`
public protocol StaticCodingWrapper: StaticEncoderWrapper & StaticDecoderWrapper where CustomEncoder.OriginalType == CustomDecoder.DecodedType {
    associatedtype CustomCoder: StaticCoder
}

//MARK: Enable Customizing one direction

/// Ensures there isn't an extra level added
extension EncodingUses: Decodable, TransientDecodable where CustomEncoder.OriginalType: Decodable { }
/// Ensures there isn't an extra level added
extension DecodingUses: Encodable, TransientEncodable where CustomDecoder.DecodedType: Encodable { }


//MARK: - Conditional Equatable Conformance

extension EncodingUses: Equatable where CustomEncoder.OriginalType: Equatable {}
extension DecodingUses: Equatable where CustomDecoder.DecodedType: Equatable {}
extension CodingUses: Equatable where CustomCoder.CodingType: Equatable {}

//MARK: - Conditional Hashable Conformance

extension EncodingUses: Hashable where CustomEncoder.OriginalType: Hashable {}
extension DecodingUses: Hashable where CustomDecoder.DecodedType: Hashable {}
extension CodingUses: Hashable where CustomCoder.CodingType: Hashable {}

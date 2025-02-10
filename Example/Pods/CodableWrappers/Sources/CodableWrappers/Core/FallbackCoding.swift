//
//  FallbackCoding.swift
//  
//
//  Created by PJ Fechner on 7/7/20.
//

import Foundation

//MARK: - FallbackWrappers

//MARK: Protocols

/// Contract for providing a default value of a Type
public protocol FallbackValueProvider {
    associatedtype ValueType
    static var defaultValue: ValueType { get }
}

/// Contract for an Encoding Fallback Wrapper. Used to unify logic for Encodable/Codable version
public protocol FallbackEncodingWrapper: Encodable {
    associatedtype ValueProvider: FallbackValueProvider where ValueProvider.ValueType: Encodable
    var wrappedValue: ValueProvider.ValueType? { get }
}

extension FallbackEncodingWrapper {
    public func encode(to encoder: Encoder) throws {

        guard let wrappedValue = wrappedValue else {
            try ValueProvider.defaultValue.encode(to: encoder)
            return
        }
        try wrappedValue.encode(to: encoder)
    }
}

/// Contract for an Decoding Fallback Wrapper. Used to unify logic for Decodable/Codable version
public protocol FallbackDecodingWrapper: Decodable {
    associatedtype ValueProvider: FallbackValueProvider where ValueProvider.ValueType: Decodable
    init(wrappedValue: ValueProvider.ValueType)
}

extension FallbackDecodingWrapper {
    public init(from decoder: Decoder) throws {
        let foundValue = try? ValueProvider.ValueType(from: decoder)
        // The second half of this should never run due to the KeyedDecodingContainer.decode extension, but just in case, possible when a value is "null"
        self.init(wrappedValue: foundValue ?? ValueProvider.defaultValue)
    }
}

public typealias FallbackCodingWrapper = FallbackEncodingWrapper & FallbackDecodingWrapper

//MARK: Wrappers


/// If `wrappedValue` is nil encodes the `ValueProvider.defaultValue` value.
/// - Note: WrappedType must be Optional or encoding is irrelevant. Use`FallbackDecoding` for decoding-only cases
@propertyWrapper
public struct FallbackEncoding<ValueProvider: FallbackValueProvider>: FallbackEncodingWrapper where ValueProvider.ValueType: Encodable {

    public var wrappedValue: ValueProvider.ValueType?

    public init(wrappedValue: ValueProvider.ValueType?) {
        self.wrappedValue = wrappedValue
    }
}

/// If a value is not found while decoding, will be initialized with the `ValueProvider.defaultValue` value.
@propertyWrapper
public struct FallbackDecoding<ValueProvider: FallbackValueProvider>: FallbackDecodingWrapper where ValueProvider.ValueType: Decodable {

    public var wrappedValue: ValueProvider.ValueType

    public init(wrappedValue: ValueProvider.ValueType) {
        self.wrappedValue = wrappedValue
    }
}

/// Encoding: If `wrappedValue` is nil encodes the `ValueProvider.defaultValue` value.
/// Decoding: If a value is not found, will be initialized with the `ValueProvider.defaultValue` value.
/// - Note: WrappedType must be Optional or encoding is irrelevant. `FallbackDecoding` is available for decoding-only cases
@propertyWrapper
public struct FallbackCoding<ValueProvider: FallbackValueProvider>: FallbackCodingWrapper, Codable where ValueProvider.ValueType: Codable {

    public var wrappedValue: ValueProvider.ValueType?

    public init(wrappedValue: ValueProvider.ValueType?) {
        self.wrappedValue = wrappedValue
    }

    // Need this in order to work with `EmptyFallbackDecodableWrapper`
    public init(wrappedValue: ValueProvider.ValueType) {
        self.wrappedValue = wrappedValue
    }
}

extension KeyedDecodingContainer {
    // This is used to override the default decoding behavior for `EmptyFallbackDecodableWrapper` to allow a value to avoid a missing key Error
    public func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T: FallbackDecodingWrapper {
        return try decodeIfPresent(T.self, forKey: key) ?? T(wrappedValue: T.ValueProvider.defaultValue)
    }
}

//MARK: Enable Customizing one direction

/// Ensures there isn't an extra level added
extension FallbackEncoding: Decodable, TransientDecodable where ValueProvider.ValueType: Decodable { }
/// Ensures there isn't an extra level added
extension FallbackDecoding: Encodable, TransientEncodable where ValueProvider.ValueType: Encodable { }


//MARK: Conditional Equatable Conformance

extension FallbackEncoding: Equatable where ValueProvider.ValueType: Equatable {}
extension FallbackDecoding: Equatable where ValueProvider.ValueType: Equatable {}
extension FallbackCoding: Equatable where ValueProvider.ValueType: Equatable {}

//MARK: Conditional Hashable Conformance

extension FallbackEncoding: Hashable where ValueProvider.ValueType: Hashable {}
extension FallbackDecoding: Hashable where ValueProvider.ValueType: Hashable {}
extension FallbackCoding: Hashable where ValueProvider.ValueType: Hashable {}



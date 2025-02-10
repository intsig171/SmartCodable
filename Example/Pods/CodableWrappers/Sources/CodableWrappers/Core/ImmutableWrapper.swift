//
//  ImmutableWrapper.swift
//  
//
//  Created by PJ Fechner on 7/7/20.
//

import Foundation

//MARK: - Immutable Wrapper

public protocol AnyImmutableWrapper {
    associatedtype T
    var wrappedValue: T { get }
    init(wrappedValue: T)
}

/// Wraps the type to make it Immutable, (en/de)coding is transient and won't affect it's wrapped Type
@propertyWrapper
public struct Immutable<T>: AnyImmutableWrapper {
    public let wrappedValue: T

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}


//MARK: - Conditional Equatable Conformances


// TransientCodable will handle the (en/de)coding here when needed without adding additional layers
extension Immutable: Encodable, TransientEncodable where T: Encodable { }
extension Immutable: Decodable, TransientDecodable where T: Decodable { }
extension Immutable: TransientCodable where T: Codable { }

extension Immutable: Equatable where T: Equatable { }
extension Immutable: Hashable where T: Hashable { }

// MARK: - Handling Immutable and Optional interaction

extension Immutable: OptionalDecodingWrapper where T: Decodable & ExpressibleByNilLiteral { }
extension Immutable: OptionalEncodingWrapper where T: Encodable & ExpressibleByNilLiteral { }

extension KeyedDecodingContainer {
    // This is used to override the default decoding behavior for OptionalWrapper to avoid a missing key Error
    public func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T : Decodable, T: AnyImmutableWrapper, T.T: OptionalDecodingWrapper  {
        return try decodeIfPresent(T.self, forKey: key) ?? T(wrappedValue: .init(wrappedValue: nil))
    }
}

extension KeyedEncodingContainer {
    // Used to make make sure OptionalCodingWrappers encode no value when it's wrappedValue is nil.
    public mutating func encode<T>(_ value: T, forKey key: KeyedEncodingContainer<K>.Key) throws where T: Encodable, T: AnyImmutableWrapper, T.T: OptionalEncodingWrapper  {

        if case Optional<Any>.none = value.wrappedValue.wrappedValue as Any {
            return
        } else {
            try encodeIfPresent(value, forKey: key)
        }
    }
}

// MARK: - Handling interaction with FallbackDecodingWrapper

extension KeyedDecodingContainer {
    // This is used to override the default decoding behavior for `EmptyFallbackDecodableWrapper` to allow a value to avoid a missing key Error
    public func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T : Decodable, T: AnyImmutableWrapper, T.T: FallbackDecodingWrapper {
        return try decodeIfPresent(T.self, forKey: key) ?? T(wrappedValue: T.T(wrappedValue: T.T.ValueProvider.defaultValue))
    }
}

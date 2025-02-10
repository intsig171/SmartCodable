//
//  TransientCoding.swift
//  
//
//  Created by PJ Fechner on 7/7/20.
//

import Foundation

//MARK: - Transient Property Wrappers


/// Indicates the encoding should be done with the wrapped value directly rather than in a nested container
@propertyWrapper
public struct TransientEncoding<T:Codable>: TransientEncodable {

    public var wrappedValue: T
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}

/// Indicates the decoding should be done from the current container rather a new level of nesting
@propertyWrapper
public struct TransientDecoding<T:Codable>: TransientDecodable {

    public var wrappedValue: T
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}


/// Indicates the (en/de)coding should be done directly rather than at a new level of nesting
@propertyWrapper
public struct TransientCoding<T:Codable>: TransientCodable {

    public var wrappedValue: T
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}


//MARK: - Transient Protocols

/// Contract for a Type that encodes it's value directly rather than encoding an extra level for itself.
public protocol TransientEncodable: Encodable {
    associatedtype ValueType: Encodable
    // The value to be encoded
    var wrappedValue: ValueType { get }
}

public extension TransientEncodable {
    // Encodes the wrapped value directly at the current level
    func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

/// Contract for Type that decodes it's value at the currently level of the encoding rather than from a nested container
public protocol TransientDecodable: Decodable {
    associatedtype InitType: Decodable
    // The init to use when decoding
    init(wrappedValue: InitType)
}
public extension TransientDecodable {
    // Decodes the value directly at the current level of encoding
    init(from decoder: Decoder) throws {
        self.init(wrappedValue: try InitType(from: decoder))
    }
}
/// Combination of TransientEncodable & TransientEncodable
public protocol TransientCodable: TransientEncodable, TransientDecodable where ValueType == InitType { }


//MARK: Enable Customizing one direction

extension TransientEncoding: Decodable where T: Decodable {
    //Ensures there isn't an extra level added
    public init(from decoder: Decoder) throws {
        wrappedValue = try T(from: decoder)
    }
}

extension TransientDecoding: Encodable where T: Encodable {
    //Ensures there isn't an extra level added
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}


//MARK: - Conditional Equatable Conformance

extension TransientEncoding: Equatable where T: Equatable {}
extension TransientDecoding: Equatable where T: Equatable {}
extension TransientCoding: Equatable where T: Equatable {}

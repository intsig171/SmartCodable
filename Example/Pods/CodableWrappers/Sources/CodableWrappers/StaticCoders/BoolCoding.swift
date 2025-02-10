//
//  BoolCoding.swift
//  
//
//  Created by PJ Fechner on 12/8/19.
//  Copyright © 2019 PJ Fechner. All rights reserved.

import Foundation

public protocol NonConformingBoolValueProvider {
    /// The Type being converted to/from a Bool
    associatedtype EncodedType: Codable, Equatable
    /// Convert the Encoded Type to a Bool. Should return nil for invalid values
    static func value(for typeValue: EncodedType) -> Bool?
    /// Convert a Bool to the EncodedType
    static func value(for boolean: Bool) -> EncodedType
}

/// Int <-> Bool converter available for any Type adhering to FixedWidthInteger & Codable.
/// Uses 0 as false, and > 0 as true.
public struct BoolAsIntegerValueProvider<ValueType>: NonConformingBoolValueProvider where ValueType: FixedWidthInteger & Codable {
    static public func value(for typeValue: ValueType) -> Bool? { typeValue > 0 ? true : false }
    static public func value(for boolean: Bool) -> ValueType { boolean ? 1 : 0}
}

/// String <-> Bool converter.
/// Uses lowercase "true" and "false". Values are `lowerCased()` before comparing.
public struct BoolAsStringValueProvider: NonConformingBoolValueProvider {
    static public func value(for typeValue: String) -> Bool? {
        switch typeValue.lowercased() {
        case "true": return true
        case "false": return false
        default:
            print("Failed to convert \(typeValue) to Boolean return nil")
            return nil
        }
    }
    static public func value(for boolean: Bool) -> String { boolean ? "true" : "false"}
}


/// Uses the passed ValueProvider for (de)serailization of `Bool?`
public struct NonConformingBoolStaticCoder<ValueProvider: NonConformingBoolValueProvider>: StaticCoder {

    public static func decode(from decoder: Decoder) throws -> Bool {
        let encodedTypeValue = try ValueProvider.EncodedType(from: decoder)
        if let convertedValue = ValueProvider.value(for: encodedTypeValue) {
            return convertedValue
        }
        else {
            throw DecodingError.typeMismatch(Bool.self, DecodingError.Context(codingPath: decoder.codingPath,
                                                                              debugDescription: "Failed to convert \(ValueProvider.EncodedType.self) to Bool"))
        }
    }

    public static func encode(value: Bool, to encoder: Encoder) throws {
        try ValueProvider.value(for: value).encode(to: encoder)
    }
}

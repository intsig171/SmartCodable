//
//  FloatingPointCoding.swift
//  
//
//  Created by PJ Fechner on 10/16/19.
//  Copyright © 2019 PJ Fechner. All rights reserved.

import Foundation


/// A provider for the data needed for (de)serializing non conforming floating point values
public protocol NonConformingDecimalValueProvider {
    /// The seralized `String` value to use when a number of `infiniti`
    static var positiveInfinity: String { get }
    /// The seralized `String` value to use when a number of `-infiniti`
    static var negativeInfinity: String { get }
    /// The seralized `String` value to use when a number of `NaN`
    static var nan: String { get }
}

/// Uses the `ValueProvider` for (de)serialization of a non-conforming `Float`
public struct NonConformingFloatStaticCoder<ValueProvider: NonConformingDecimalValueProvider>: StaticCoder {
    private init() { }

    public static func decode(from decoder: Decoder) throws -> Float {
        guard let stringValue = try? String(from: decoder) else {
            return try Float(from: decoder)
        }
        switch stringValue {
        case ValueProvider.positiveInfinity: return Float.infinity
        case ValueProvider.negativeInfinity: return -Float.infinity
        case ValueProvider.nan: return Float.nan
        default:
            guard let value = Float(stringValue) else {
                throw DecodingError.valueNotFound(self,  DecodingError.Context(codingPath: decoder.codingPath,
                debugDescription: "Expected \(Float.self) but could not convert \(stringValue) to Float"))
            }
            return value
        }
    }

    public static func encode(value: Float, to encoder: Encoder) throws {

        //For some reason the switch with nan doesn't work 🤷‍♂️ as of Swift 5.2
        if value.isNaN {
            return try ValueProvider.nan.encode(to: encoder)
        }
        else if value == Float.infinity {
            return try ValueProvider.positiveInfinity.encode(to: encoder)
        }
        else if value == -Float.infinity {
            return try ValueProvider.negativeInfinity.encode(to: encoder)
        }
        else {
            try value.encode(to: encoder)
        }
    }
}



/// Uses the `ValueProvider` for (de)serialization of a non-conforming `Double`
public struct NonConformingDoubleStaticCoder<ValueProvider: NonConformingDecimalValueProvider>: StaticCoder {
    private init() { }

    public static func decode(from decoder: Decoder) throws -> Double {
        guard let stringValue = try? String(from: decoder) else {
            return try Double(from: decoder)
        }
        switch stringValue {
        case ValueProvider.positiveInfinity: return Double.infinity
        case ValueProvider.negativeInfinity: return -Double.infinity
        case ValueProvider.nan: return Double.nan
        default:
            guard let value = Double(stringValue) else {
                throw DecodingError.valueNotFound(self,  DecodingError.Context(codingPath: decoder.codingPath,
                debugDescription: "Expected \(Double.self) but could not convert \(stringValue) to Float"))
            }
            return value
        }
    }

    public static func encode(value: Double, to encoder: Encoder) throws {

        //For some reason the switch with nan doesn't work 🤷‍♂️ as of Swift 5.2
        if value.isNaN {
            return try ValueProvider.nan.encode(to: encoder)
        }
        else if value == Double.infinity {
            return try ValueProvider.positiveInfinity.encode(to: encoder)
        }
        else if value == -Double.infinity {
            return try ValueProvider.negativeInfinity.encode(to: encoder)
        }
        else {
            try value.encode(to: encoder)
        }
    }
}

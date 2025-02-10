//
//  DateCoding.swift
//  
//
//  Created by PJ Fechner on 10/16/19.
//  Copyright © 2019 PJ Fechner. All rights reserved.

import Foundation

/// Uses secondsSince1970 for (de)serailization of `Date`
public struct SecondsSince1970DateStaticCoder: StaticCoder {

    public static func decode(from decoder: Decoder) throws -> Date {

        let value = try TimeInterval(from: decoder)
        let valueDate = Date(timeIntervalSince1970: value)
        return valueDate
    }

    public static func encode(value: Date, to encoder: Encoder) throws {
        try value.timeIntervalSince1970.encode(to: encoder)
    }
}

/// Uses millisecondsSince1970 for (de)serailization of `Date`
public struct MillisecondsSince1970DateStaticCoder: StaticCoder {

    public static func decode(from decoder: Decoder) throws -> Date {

        let value = try TimeInterval(from: decoder)
        let valueDate = Date(timeIntervalSince1970: value / 1000)
        return valueDate
    }

    public static func encode(value: Date, to encoder: Encoder) throws {
        try (value.timeIntervalSince1970 * 1000).encode(to: encoder)
    }
}

//MARK: - Custom DateFormatter

/// A `StaticDecoder` that uses a DateFormatter for decoding
/// - Note: Implement to use a custom `DateFormatter` for deserialization in the `StaticDecoder` Property Wrapper
/// - Example: `@StaticDecoder<YourCustomDateFormatterDecoder>`
public protocol DateFormatterStaticDecoder: StaticDecoder {
    static var dateFormatter: DateFormatter { get }
}
/// A `StaticEncoder` that uses a DateFormatter for decoding
/// - Note: Implement to use a custom `DateFormatter` for serialization in the `StaticEncoder` Property Wrapper
/// - Example: `@StaticEncoder<YourCustomDateFormatterEncoder>`
public protocol DateFormatterStaticEncoder: StaticEncoder {
    static var dateFormatter: DateFormatter { get }
}

/// Combination of `CustomDateFormatterEncoder` & `CustomDateFormatterDecoder`
/// - Note: Implement to use a custom `DateFormatter` for (de)serialization in the `StaticCoder` Property Wrapper
/// - Example: `@StaticCoder<YourCustomDateFormatterCoder>`
public typealias DateFormatterStaticCoder = StaticCoder & DateFormatterStaticEncoder & DateFormatterStaticDecoder

extension DateFormatterStaticDecoder {
    /// Uses `dateFormatter` for decoding
    public static func decode(from decoder: Decoder) throws -> Date {
        let stringValue = try String(from: decoder)

        guard let value = dateFormatter.date(from: stringValue) else {
            throw DecodingError.valueNotFound(self,  DecodingError.Context(codingPath: decoder.codingPath,
                                                                           debugDescription: "Expected \(Data.self) but could not convert \(stringValue) to Data"))
        }
        return value
    }
}

extension DateFormatterStaticEncoder {
/// Uses `dateFormatter` for encoding
    public static func encode(value: Date, to encoder: Encoder) throws {
        try dateFormatter.string(from: value).encode(to: encoder)
    }
}

//MARK: - ISO8601



/// Uses `ISO8601DateFormatter` with `formatOptions` set to `.withInternetDateTime` for (de)serailization of `Date`
/// - Note: Implement a `StaticCoder` to use a custom formatter
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
public struct ISO8601DateStaticCoder: ISO8601DateFormatterStaticCoder {

    public static let iso8601DateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withInternetDateTime
        return formatter
    }()
}

//MARK:  Custom

/// A `StaticDecoder` that uses an ISO8601DateFormatter for decoding
/// - Note: Implement to use a custom `ISO8601DateFormatter` for deserialization in the `StaticDecoder` Property Wrapper
/// - Example: `@StaticDecoder<YourCustomISO8601DateFormatterDecoder>`
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
public protocol ISO8601DateFormatterStaticDecoder: StaticDecoder {
    static var iso8601DateFormatter: ISO8601DateFormatter { get }
}
/// A `StaticEncoder` that uses an ISO8601DateFormatter for decoding
/// - Note: Implement to use a custom `ISO8601DateFormatter` for serialization in the `StaticEncoder` Property Wrapper
/// - Example: `@StaticEncoder<YourCustomISO8601DateFormatterEncoder>`
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
public protocol ISO8601DateFormatterStaticEncoder: StaticEncoder {
    static var iso8601DateFormatter: ISO8601DateFormatter { get }
}

/// Combination of `ISO8601DateFormatterStaticEncoder` & `ISO8601DateFormatterStaticDecoder`
/// - Note: Implement to use a custom `ISO8601DateFormatter` for (de)serialization in the `StaticCoder` Property Wrapper
/// - Example: `@StaticCoder<YourCustomISO8601DateFormatterCoder>`
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
public typealias ISO8601DateFormatterStaticCoder = StaticCoder & ISO8601DateFormatterStaticEncoder & ISO8601DateFormatterStaticDecoder

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
extension ISO8601DateFormatterStaticDecoder {
    /// Uses `ISO8601DateFormatter` for decoding
    public static func decode(from decoder: Decoder) throws -> Date {
        let stringValue = try String(from: decoder)

        guard let value = iso8601DateFormatter.date(from: stringValue) else {
            throw DecodingError.valueNotFound(self,  DecodingError.Context(codingPath: decoder.codingPath,
                                                                           debugDescription: "Expected \(Data.self) but could not convert \(stringValue) to Data"))
        }
        return value
    }
}

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
extension ISO8601DateFormatterStaticEncoder {
/// Uses `dateFormatter` for encoding
    public static func encode(value: Date, to encoder: Encoder) throws {
        try iso8601DateFormatter.string(from: value).encode(to: encoder)
    }
}

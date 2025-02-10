//
//  File.swift
//  
//
//  Created by PJ Fechner on 7/7/20.
//

import Foundation

//MARK: - Mutable Wrappers

/// Customize the encoding of a mutable property using the `CustomEncoder`
@available(*, deprecated, message: "Wrappers are now mutable by default")
@propertyWrapper
public struct EncodingUsesMutable<CustomEncoder: StaticEncoder>: StaticEncoderWrapper {
    public var wrappedValue: CustomEncoder.OriginalType
    public init(wrappedValue: CustomEncoder.OriginalType) {
        self.wrappedValue = wrappedValue
    }
}

/// Customize the decoding of a mutable property using the `CustomDecoder`
@available(*, deprecated, message: "Wrappers are now mutable by default")
@propertyWrapper
public struct DecodingUsesMutable<CustomDecoder: StaticDecoder>: StaticDecoderWrapper {
    public var wrappedValue: CustomDecoder.DecodedType
    public init(wrappedValue: CustomDecoder.DecodedType) {
        self.wrappedValue = wrappedValue
    }
}

/// Customize the encoding and decoding of a mutable property using the `CustomCoder`
@available(*, deprecated, message: "Wrappers are now mutable by default")
@propertyWrapper
public struct CodingUsesMutable<CustomCoder: StaticCoder>: StaticCodingWrapper {
    public typealias CustomEncoder = CustomCoder
    public typealias CustomDecoder = CustomCoder

    public var wrappedValue: CustomCoder.CodingType
    public init(wrappedValue: CustomCoder.CodingType) {
        self.wrappedValue = wrappedValue
    }
}

@available(*, deprecated)
extension EncodingUsesMutable: Decodable where CustomEncoder.OriginalType: Decodable {
    /// Ensures there isn't an extra level added
    public init(from decoder: Decoder) throws {
        self.init(wrappedValue: try CustomEncoder.OriginalType(from: decoder))
    }
}
@available(*, deprecated)
extension DecodingUsesMutable: Encodable where CustomDecoder.DecodedType: Encodable {
    /// Ensures there isn't an extra level added
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

@available(*, deprecated)
extension EncodingUsesMutable: Equatable where CustomEncoder.OriginalType: Equatable {}
@available(*, deprecated)
extension DecodingUsesMutable: Equatable where CustomDecoder.DecodedType: Equatable {}
@available(*, deprecated)
extension CodingUsesMutable: Equatable where CustomCoder.CodingType: Equatable {}

@available(*, deprecated)
extension DecodingUsesMutable: OptionalDecodingWrapper where CustomDecoder.DecodedType: ExpressibleByNilLiteral { }
@available(*, deprecated)
extension EncodingUsesMutable: OptionalEncodingWrapper where CustomEncoder.OriginalType: ExpressibleByNilLiteral { }
@available(*, deprecated)
extension CodingUsesMutable: OptionalCodingWrapper where CustomCoder.CodingType: ExpressibleByNilLiteral { }


// MARK: - Optional Static Coders

/// Used to wrap an existing StaticCoder to allow the wrapped value to be Optional
@available(*, deprecated, message: "Use `@OptionalCoding<YourWrapperType>` instead")
public struct OptionalStaticCoder<SomeStaticCoder: StaticCoder>: StaticCoder  {

    public static func decode(from decoder: Decoder) throws -> SomeStaticCoder.CodingType? {
            try? SomeStaticCoder.decode(from: decoder)
        }

    public static func encode(value: SomeStaticCoder.CodingType?, to encoder: Encoder) throws {
        guard let value = value else {
            return
        }
        try SomeStaticCoder.encode(value: value, to: encoder)
    }
}

/// Uses Base64 for (de)serailization of `Data?`
@available(*, deprecated , message: "Use `@OptionalCoding<Base64DataCoding>` instead")
public typealias OptionalBase64DataStaticCoder = OptionalStaticCoder<Base64DataStaticCoder>

/// Uses the passed ValueProvider for (de)serailization of `Bool?`
@available(*, deprecated , message: "Use `@OptionalCoding<NonConformingBoolCoding<ValueProvider>>` instead")
public typealias OptionalNonConformingBoolStaticCoder<ValueProvider: NonConformingBoolValueProvider> = OptionalStaticCoder<NonConformingBoolStaticCoder<ValueProvider>>

/// Uses secondsSince1970 for (de)serailization of `Date?`
@available(*, deprecated , message: "Use `@OptionalCoding<SecondsSince1970DateCoding>` instead")
public typealias OptionalSecondsSince1970DateStaticCoder = OptionalStaticCoder<SecondsSince1970DateStaticCoder>
/// Uses millisecondsSince1970 for (de)serailization of `Date?`
@available(*, deprecated , message: "Use `@OptionalCoding<MillisecondsSince1970DateCoding>` instead")
public typealias OptionalMillisecondsSince1970DateStaticCoder = OptionalStaticCoder<MillisecondsSince1970DateStaticCoder>

/// Uses `ISO8601DateFormatter` with `formatOptions` set to `.withInternetDateTime` for (de)serailization of `Date?`
/// - Note: Implement a `StaticCoder` to use a custom formatter
@available(*, deprecated , message: "Use `@OptionalCoding<ISO8601DateCoding>` instead")
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
public typealias OptionalISO8601DateStaticCoder = OptionalStaticCoder<ISO8601DateStaticCoder>

/// Uses the `ValueProvider` for (de)serialization of a non-conforming `Double`
@available(*, deprecated , message: "Use `@OptionalCoding<NonConformingDoubleCoding<ValueProvider>>` instead")
public typealias OptionalNonConformingDoubleStaticCoder<ValueProvider: NonConformingDecimalValueProvider> = OptionalStaticCoder<NonConformingDoubleStaticCoder<ValueProvider>>

/// A provider for the data needed for (de)serializing non conforming floating point values
@available(*, deprecated , message: "Use `@OptionalCoding<NonConformingFloatCoding<ValueProvider>>` instead")
public typealias OptionalNonConformingFloatStaticCoder<ValueProvider: NonConformingDecimalValueProvider> = OptionalStaticCoder<NonConformingFloatStaticCoder<ValueProvider>>

//MARK: - Deprecated Convenience Types


@available(*, deprecated, message: "Use `OptionalCoding<NonConformingFloatEncoding>` instead")
public typealias NonConformingFloatOptionalCoding<ValueProvider: NonConformingDecimalValueProvider> = OptionalCoding<NonConformingFloatCoding<ValueProvider>>

/// Use the values in `ValueProvider` when encoding this mutable Property with non-conforming numbers, also known as IEEE 754 exceptional values.
@available(*, deprecated, renamed: "NonConformingFloatEncoding")
public typealias NonConformingFloatEncodingMutable<ValueProvider: NonConformingDecimalValueProvider> = EncodingUses<NonConformingFloatStaticCoder<ValueProvider>>
/// Use the values in `ValueProvider` when decoding this mutable Property with non-conforming numbers, also known as IEEE 754 exceptional values.
@available(*, deprecated, renamed: "NonConformingFloatDecoding")
public typealias NonConformingFloatDecodingMutable<ValueProvider: NonConformingDecimalValueProvider> = DecodingUses<NonConformingFloatStaticCoder<ValueProvider>>
/// Use the values in `ValueProvider` when (en/de)coding this mutable Property with non-conforming numbers, also known as IEEE 754 exceptional values.
@available(*, deprecated, renamed: "NonConformingFloatCoding")
public typealias NonConformingFloatCodingMutable<ValueProvider: NonConformingDecimalValueProvider> = CodingUses<NonConformingFloatStaticCoder<ValueProvider>>
/// Use the values in `ValueProvider` when (en/de)coding this mutable Optional Property with non-conforming numbers, also known as IEEE 754 exceptional values.
@available(*, deprecated, message: "Use `OptionalCoding<NonConformingFloatCoding<ValueProvider>>` instead")
public typealias NonConformingFloatOptionalCodingMutable<ValueProvider: NonConformingDecimalValueProvider> = OptionalCoding<NonConformingFloatCoding<ValueProvider>>

/// Use the values in `ValueProvider` when (en/de)coding this immutable Optional Property with non-conforming numbers, also known as IEEE 754 exceptional values.
@available(*, deprecated, message: "Use `OptionalCoding<NonConformingDoubleCoding<ValueProvider>>` instead")
public typealias NonConformingDoubleOptionalCoding<ValueProvider: NonConformingDecimalValueProvider> = OptionalCoding<NonConformingDoubleCoding<ValueProvider>>

/// Use the values in `ValueProvider` when encoding this mutable Property with non-conforming numbers, also known as IEEE 754 exceptional values.
@available(*, deprecated, renamed: "NonConformingDoubleEncoding")
public typealias NonConformingDoubleEncodingMutable<ValueProvider: NonConformingDecimalValueProvider> = EncodingUses<NonConformingDoubleStaticCoder<ValueProvider>>
/// Use the values in `ValueProvider` when decoding this mutable Property with non-conforming numbers, also known as IEEE 754 exceptional values.
@available(*, deprecated, renamed: "NonConformingDoubleDecoding")
public typealias NonConformingDoubleDecodingMutable<ValueProvider: NonConformingDecimalValueProvider> = DecodingUses<NonConformingDoubleStaticCoder<ValueProvider>>
/// Use the values in `ValueProvider` when (en/de)coding this mutable Property with non-conforming numbers, also known as IEEE 754 exceptional values.
@available(*, deprecated, renamed: "NonConformingDoubleCoding")
public typealias NonConformingDoubleCodingMutable<ValueProvider: NonConformingDecimalValueProvider> = CodingUses<NonConformingDoubleStaticCoder<ValueProvider>>
/// Use the values in `ValueProvider` when (en/de)coding this mutable Optional Property with non-conforming numbers, also known as IEEE 754 exceptional values.
@available(*, deprecated, message: "Use `OptionalCoding<NonConformingDoubleCoding<ValueProvider>>` instead")
public typealias NonConformingDoubleOptionalCodingMutable<ValueProvider: NonConformingDecimalValueProvider> = OptionalCoding<NonConformingDoubleCoding<ValueProvider>>

/// (En/De)code this immutable `Data` Optional Property as a Base64 encoded String
@available(*, deprecated, message: "Use `OptionalCoding<Base64Encoding>` instead")
public typealias Base64OptionalCoding = OptionalCoding<Base64Coding>

/// Encode this immutable `Data` Property as a Base64 encoded String
@available(*, deprecated, renamed: "Base64Encoding")
public typealias Base64EncodingMutable = EncodingUses<Base64DataStaticCoder>
/// Decode this immutable `Data` Property as a Base64 encoded String
@available(*, deprecated, renamed: "Base64Decoding")
public typealias Base64DecodingMutable = DecodingUses<Base64DataStaticCoder>
/// (En/De)code this immutable `Data` Property as a Base64 encoded String
@available(*, deprecated, renamed: "Base64Coding")
public typealias Base64CodingMutable = CodingUses<Base64DataStaticCoder>
/// (En/De)code this immutable `Data` Optional Property as a Base64 encoded String
@available(*, deprecated, message: "Use `OptionalCoding<Base64Encoding>` instead")
public typealias Base64OptionalCodingMutable = OptionalCoding<Base64Coding>

/// (En/De)code this immutable `Date` Optional Property using millisecondsSince1970
@available(*, deprecated, message: "Use `OptionalCoding<MillisecondsSince1970DateCoding>` instead")
public typealias MillisecondsSince1970DateOptionalCoding = OptionalCoding<MillisecondsSince1970DateCoding>


/// Encode this mutable `Date` Property using millisecondsSince1970
@available(*, deprecated, renamed: "MillisecondsSince1970DateEncoding")
public typealias MillisecondsSince1970DateEncodingMutable = EncodingUses<MillisecondsSince1970DateStaticCoder>
/// Decode this mutable `Date` Property using millisecondsSince1970
@available(*, deprecated, renamed: "MillisecondsSince1970DateDecoding")
public typealias MillisecondsSince1970DateDecodingMutable = DecodingUses<MillisecondsSince1970DateStaticCoder>
/// (En/De)code this mutable `Date` Property using millisecondsSince1970
@available(*, deprecated, renamed: "MillisecondsSince1970DateCoding")
public typealias MillisecondsSince1970DateCodingMutable = CodingUses<MillisecondsSince1970DateStaticCoder>
/// (En/De)code this mutable `Date` Optional Property using millisecondsSince1970
@available(*, deprecated, message: "Use `OptionalCoding<MillisecondsSince1970DateCoding>` instead")
public typealias MillisecondsSince1970DateOptionalCodingMutable = OptionalCoding<MillisecondsSince1970DateCoding>

/// (En/De)code this immutable `Date` Optional Property using secondsSince1970
@available(*, deprecated, message: "Use `OptionalCoding<SecondsSince1970DateCoding>` instead")
public typealias SecondsSince1970DateOptionalCoding = OptionalCoding<SecondsSince1970DateCoding>


/// Encode this mutable `Date` Property using secondsSince1970
@available(*, deprecated, renamed: "SecondsSince1970DateEncoding")
public typealias SecondsSince1970DateEncodingMutable = EncodingUses<SecondsSince1970DateStaticCoder>
/// Decode this mutable `Date` Property using secondsSince1970
@available(*, deprecated, renamed: "SecondsSince1970DateDecoding")
public typealias SecondsSince1970DateDecodingMutable = DecodingUses<SecondsSince1970DateStaticCoder>
/// (En/De)code this mutable `Date` Property using secondsSince1970
@available(*, deprecated, renamed: "SecondsSince1970DateCoding")
public typealias SecondsSince1970DateCodingMutable = CodingUses<SecondsSince1970DateStaticCoder>
/// (En/De)code this mutable `Date` Optional Property using secondsSince1970
@available(*, deprecated, message: "Use `OptionalCoding<SecondsSince1970DateCoding>` instead")
public typealias SecondsSince1970DateOptionalCodingMutable = OptionalCoding<SecondsSince1970DateCoding>


/// (En/De) this immutable `Date` Optional Property using a ISO8601DateFormatter with `formatOptions` set to `.withInternetDateTime`
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
@available(*, deprecated, message: "Use `OptionalCoding<ISO8601DateCoding>` instead")
public typealias ISO8601DateOptionalCoding = OptionalCoding<ISO8601DateCoding>

/// Encode this mutable `Date` Property using a ISO8601DateFormatter with `formatOptions` set to `.withInternetDateTime`
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
@available(*, deprecated, renamed: "SecondsSince1970DateCoding")
public typealias ISO8601DateEncodingMutable = EncodingUses<ISO8601DateStaticCoder>
/// Decode this mutable `Date` Property using a ISO8601DateFormatter with `formatOptions` set to `.withInternetDateTime`
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
@available(*, deprecated, renamed: "SecondsSince1970DateCoding")
public typealias ISO8601DateDecodingMutable = DecodingUses<ISO8601DateStaticCoder>
/// (En/De) this mutable `Date` Property using a ISO8601DateFormatter with `formatOptions` set to `.withInternetDateTime`
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
@available(*, deprecated, renamed: "SecondsSince1970DateCoding")
public typealias ISO8601DateCodingMutable = CodingUses<ISO8601DateStaticCoder>
/// (En/De) this mutable `Date` Optional Property using a ISO8601DateFormatter with `formatOptions` set to `.withInternetDateTime`
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
@available(*, deprecated, message: "Use `OptionalCoding<ISO8601DateCoding>` instead")
public typealias ISO8601DateOptionalCodingMutable = OptionalCoding<ISO8601DateCoding>


/// (En/De)code this immutable `Date` Optional Property using the passed formatter
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
@available(*, deprecated, message: "Use `OptionalCoding<ISO8601DateFormatterCoding<CustomCoder>>` instead")
public typealias ISO8601DateFormatterOptionalCoding<CustomCoder: ISO8601DateFormatterStaticCoder> = OptionalCoding<ISO8601DateFormatterCoding<CustomCoder>>

/// Encode this mutable `Date` Property using the passed formatter
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
@available(*, deprecated, renamed: "ISO8601DateFormatterEncoding")
public typealias ISO8601DateFormatterEncodingMutable<CustomEncoder: ISO8601DateFormatterStaticEncoder> = EncodingUses<CustomEncoder>
/// Decode this mutable `Date` Property using the passed formatter
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
@available(*, deprecated, renamed: "ISO8601DateFormatterDecoding")
public typealias ISO8601DateFormatterDecodingMutable<CustomDecoder: ISO8601DateFormatterStaticDecoder> = DecodingUses<CustomDecoder>
/// (En/De)code this mutable `Date` Property using the passed formatter
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
@available(*, deprecated, renamed: "ISO8601DateFormatterCoding")
public typealias ISO8601DateFormatterCodingMutable<CustomCoder: ISO8601DateFormatterStaticCoder> = CodingUses<CustomCoder>
/// (En/De)code this mutable `Date` Optional Property using the passed formatter
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
@available(*, deprecated, message: "Use `OptionalCoding<ISO8601DateFormatterCoding<CustomCoder>>` instead")
public typealias ISO8601DateFormatterOptionalCodingMutable<CustomCoder: ISO8601DateFormatterStaticCoder> = OptionalCoding<ISO8601DateFormatterCoding<CustomCoder>>


/// (En/De)code this immutable `Date` Optional Property using the passed formatter
@available(*, deprecated, message: "Use `OptionalCoding<DateFormatterCoding<CustomCoder>>` instead")
public typealias DateFormatterOptionalCoding<CustomCoder: DateFormatterStaticCoder> = OptionalCoding<DateFormatterCoding<CustomCoder>>

/// Encode this mutable `Date` Property using the passed formatter
@available(*, deprecated, renamed: "DateFormatterEncoding")
public typealias DateFormatterEncodingMutable<CustomEncoder: DateFormatterStaticEncoder> = EncodingUses<CustomEncoder>
/// Decode this mutable `Date` Property using the passed formatter
@available(*, deprecated, renamed: "DateFormatterDecoding")
public typealias DateFormatterDecodingMutable<CustomDecoder: DateFormatterStaticDecoder> = DecodingUses<CustomDecoder>
/// (En/De)code this mutable `Date` Property using the passed formatter
@available(*, deprecated, renamed: "DateFormatterCoding")
public typealias DateFormatterCodingMutable<CustomCoder: DateFormatterStaticCoder> = CodingUses<CustomCoder>
/// (En/De)code this mutable `Date` Optional Property using the passed formatter
@available(*, deprecated, message: "Use `OptionalCoding<DateFormatterCoding<CustomCoder>>` instead")
public typealias DateFormatterOptionalCodingMutable<CustomCoder: DateFormatterStaticCoder> = OptionalCoding<DateFormatterCoding<CustomCoder>>


/// (En/De)code this immutable `Bool` Property using the passed NonConformingBoolValueProvider
@available(*, deprecated, message: "Use `OptionalCoding<NonConformingBoolCoding<ValueProvider>>` instead")
public typealias NonConformingBoolOptionalCoding<ValueProvider: NonConformingBoolValueProvider> = OptionalCoding<NonConformingBoolCoding<ValueProvider>>

/// Encode this mutable `Bool` Property using the passed NonConformingBoolValueProvider
@available(*, deprecated, renamed: "NonConformingBoolEncoding")
public typealias NonConformingBoolEncodingMutable<ValueProvider: NonConformingBoolValueProvider> = EncodingUses<NonConformingBoolStaticCoder<ValueProvider>>
/// Decode this mutable `Bool` Property using the passed NonConformingBoolValueProvider
@available(*, deprecated, renamed: "NonConformingBoolDecoding")
public typealias NonConformingBoolDecodingMutable<ValueProvider: NonConformingBoolValueProvider> = DecodingUses<NonConformingBoolStaticCoder<ValueProvider>>
/// (En/De)code this mutable `Bool` Property using the passed NonConformingBoolValueProvider
@available(*, deprecated, renamed: "NonConformingBoolCoding")
public typealias NonConformingBoolCodingMutable<ValueProvider: NonConformingBoolValueProvider> = CodingUses<NonConformingBoolStaticCoder<ValueProvider>>
/// (En/De)code this mutable `Bool` Property using the passed NonConformingBoolValueProvider
@available(*, deprecated, message: "Use `OptionalCoding<NonConformingBoolCoding<ValueProvider>>` instead")
public typealias NonConformingBoolOptionalCodingMutable<ValueProvider: NonConformingBoolValueProvider> = OptionalCoding<NonConformingBoolCoding<ValueProvider>>


/// (En/De)code this immutable `Bool` Optional Property as passed Integer Type using 1 as true and 0 as false
@available(*, deprecated, message: "Use `OptionalCoding<BoolAsIntegerCoding<ValueType>>` instead")
public typealias BoolAsIntegerOptionalCoding<ValueType: FixedWidthInteger & Codable> = OptionalCoding<BoolAsIntegerCoding<ValueType>>

/// Encode this immutable `Bool` Property as passed Integer Type using 1 as true and 0 as false
@available(*, deprecated, renamed: "BoolAsIntegerEncoding")
public typealias BoolAsIntegerEncodingMutable<ValueType: FixedWidthInteger & Codable> = EncodingUses<BoolAsIntegerStaticCoder<ValueType>>
/// Decode this immutable `Bool` Property as passed Integer Type using 1 as true and 0 as false
@available(*, deprecated, renamed: "BoolFromIntegerDecoding")
public typealias BoolFromIntegerDecodingMutable<ValueType: FixedWidthInteger & Codable> = DecodingUses<BoolAsIntegerStaticCoder<ValueType>>
/// (En/De)code this immutable `Bool` Property as passed Integer Type using 1 as true and 0 as false
@available(*, deprecated, renamed: "BoolAsIntegerCoding")
public typealias BoolAsIntegerCodingMutable<ValueType: FixedWidthInteger & Codable> = CodingUses<BoolAsIntegerStaticCoder<ValueType>>
/// (En/De)code this immutable `Bool` Optional Property as passed Integer Type using 1 as true and 0 as false
@available(*, deprecated, message: "Use `OptionalCoding<BoolAsIntegerCoding<ValueType>>` instead")
public typealias BoolAsIntegerOptionalCodingMutable<ValueType: FixedWidthInteger & Codable> = OptionalCoding<BoolAsIntegerCoding<ValueType>>


/// (En/De)code this immutable `Bool` Optional Property as an Int using 1 as true and 0 as false
@available(*, deprecated, message: "Use `OptionalCoding<BoolAsIntCoding>` instead")
public typealias BoolAsIntOptionalCoding = OptionalCoding<BoolAsIntCoding>

/// Encode this immutable `Bool` Property as an Int using 1 as true and 0 as false
@available(*, deprecated, renamed: "BoolAsIntEncoding")
public typealias BoolAsIntEncodingMutable = BoolAsIntegerEncodingMutable<Int>
/// Decode this immutable `Bool` Property as an Int using 1 as true and 0 as false
@available(*, deprecated, renamed: "BoolFromIntDecoding")
public typealias BoolFromIntDecodingMutable = BoolFromIntegerDecodingMutable<Int>
/// (En/De)code this immutable `Bool` Property as an Int using 1 as true and 0 as false
@available(*, deprecated, renamed: "BoolAsIntCoding")
public typealias BoolAsIntCodingMutable = BoolAsIntegerCodingMutable<Int>
/// (En/De)code this immutable `Bool` Optional Property as an Int using 1 as true and 0 as false
@available(*, deprecated, message: "Use `OptionalCoding<BoolAsIntCoding>` instead")
public typealias BoolAsIntOptionalCodingMutable = OptionalCoding<BoolAsIntCoding>


/// (En/De)code this immutable `Bool` Optional Property a String using "true" for true and "false" for false
@available(*, deprecated, message: "Use `OptionalCoding<BoolAsStringCoding>` instead")
public typealias BoolAsStringOptionalCoding = OptionalCoding<BoolAsStringCoding>

/// Encode this immutable `Bool` Property a String using "true" for true and "false" for false
@available(*, deprecated, renamed: "BoolAsStringEncoding")
public typealias BoolAsStringEncodingMutable = EncodingUses<BoolAsStringStaticCoder>
/// Decode this immutable `Bool` Property a String using "true" for true and "false" for false
@available(*, deprecated, renamed: "BoolFromStringDecoding")
public typealias BoolFromStringDecodingMutable = DecodingUses<BoolAsStringStaticCoder>
/// (En/De)code this immutable `Bool` Property a String using "true" for true and "false" for false
@available(*, deprecated, renamed: "BoolAsStringCoding")
public typealias BoolAsStringCodingMutable = CodingUses<BoolAsStringStaticCoder>
/// (En/De)code this immutable `Bool` Optional Property a String using "true" for true and "false" for false
@available(*, deprecated, message: "Use `OptionalCoding<BoolAsStringCoding>` instead")
public typealias BoolAsStringOptionalCodingMutable = OptionalCoding<BoolAsStringCoding>

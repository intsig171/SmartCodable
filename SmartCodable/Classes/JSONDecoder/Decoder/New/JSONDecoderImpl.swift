//
//  JSONDecoderImpl.swift
//  SmartCodable
//
//  Created by qixin on 2024/5/17.
//

import Foundation

fileprivate protocol _JSONStringDictionaryDecodableMarker {
    static var elementType: Decodable.Type { get }
}

extension Dictionary: _JSONStringDictionaryDecodableMarker where Key == String, Value: Decodable {
    static var elementType: Decodable.Type { return Value.self }
}



struct JSONDecoderImpl {
    let codingPath: [CodingKey]
    let userInfo: [CodingUserInfoKey: Any]

    let json: JSONValue
    let options: SmartJSONDecoder._Options
    
    let cache: InitialModelCache

    init(userInfo: [CodingUserInfoKey: Any], from json: JSONValue, codingPath: [CodingKey], options: SmartJSONDecoder._Options) {
        self.userInfo = userInfo
        self.codingPath = codingPath
        self.json = json
        self.options = options
        self.cache = InitialModelCache()

    }
}
extension JSONDecoderImpl: Decoder {
    func container<Key>(keyedBy _: Key.Type) throws ->
        KeyedDecodingContainer<Key> where Key: CodingKey
    {
        switch self.json {
        case .object(let dictionary):
            let container = KeyedContainer<Key>(
                impl: self,
                codingPath: codingPath,
                dictionary: dictionary
            )
            return KeyedDecodingContainer(container)
        case .null:
            throw DecodingError.valueNotFound([String: JSONValue].self, DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Cannot get keyed decoding container -- found null value instead"
            ))
        default:
            throw DecodingError.typeMismatch([String: JSONValue].self, DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected to decode \([String: JSONValue].self) but found \(self.json.debugDataTypeDescription) instead."
            ))
        }
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        switch self.json {
        case .array(let array):
            return UnkeyedContainer(
                impl: self,
                codingPath: self.codingPath,
                array: array
            )
        case .null:
            throw DecodingError.valueNotFound([String: JSONValue].self, DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Cannot get unkeyed decoding container -- found null value instead"
            ))
        default:
            throw DecodingError.typeMismatch([JSONValue].self, DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected to decode \([JSONValue].self) but found \(self.json.debugDataTypeDescription) instead."
            ))
        }
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        SingleValueContainer(
            impl: self,
            codingPath: self.codingPath,
            json: self.json
        )
    }

    // MARK: Special case handling

    func unwrap<T: Decodable>(as type: T.Type) throws -> T {
        if type == Date.self {
            return try self.unwrapDate() as! T
        }
        if type == Data.self {
            return try self.unwrapData() as! T
        }
        if type == URL.self {
            return try self.unwrapURL() as! T
        }
        if type == Decimal.self {
            return try self.unwrapDecimal() as! T
        }
        if type is _JSONStringDictionaryDecodableMarker.Type {
            return try self.unwrapDictionary(as: type)
        }

        cache.cacheInitialState(for: type)
        let decoded = try type.init(from: self)
        cache.clearLastState(for: type)
        return decoded
    }

    private func unwrapDate() throws -> Date {
        return try Date(from: self)

//        switch self.options.dateDecodingStrategy {
//        case .deferredToDate:
//            return try Date(from: self)
//
//        case .secondsSince1970:
//            let container = SingleValueContainer(impl: self, codingPath: self.codingPath, json: self.json)
//            let double = try container.decode(Double.self)
//            return Date(timeIntervalSince1970: double)
//
//        case .millisecondsSince1970:
//            let container = SingleValueContainer(impl: self, codingPath: self.codingPath, json: self.json)
//            let double = try container.decode(Double.self)
//            return Date(timeIntervalSince1970: double / 1000.0)
//
//        case .iso8601:
//            if #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
//                let container = SingleValueContainer(impl: self, codingPath: self.codingPath, json: self.json)
//                let string = try container.decode(String.self)
//                guard let date = _iso8601Formatter.date(from: string) else {
//                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Expected date string to be ISO8601-formatted."))
//                }
//
//                return date
//            } else {
//                fatalError("ISO8601DateFormatter is unavailable on this platform.")
//            }
//
//        case .formatted(let formatter):
//            let container = SingleValueContainer(impl: self, codingPath: self.codingPath, json: self.json)
//            let string = try container.decode(String.self)
//            guard let date = formatter.date(from: string) else {
//                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Date string does not match format expected by formatter."))
//            }
//            return date
//
//        case .custom(let closure):
//            return try closure(self)
//        }
    }

    private func unwrapData() throws -> Data {
        return try Data(from: self)

//        switch self.options.dataDecodingStrategy {
//        case .deferredToData:
//            return try Data(from: self)
//
//        case .base64:
//            let container = SingleValueContainer(impl: self, codingPath: self.codingPath, json: self.json)
//            let string = try container.decode(String.self)
//
//            guard let data = Data(base64Encoded: string) else {
//                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Encountered Data is not valid Base64."))
//            }
//
//            return data
//
//        case .custom(let closure):
//            return try closure(self)
//        }
    }

    private func unwrapURL() throws -> URL {
        let container = SingleValueContainer(impl: self, codingPath: self.codingPath, json: self.json)
        let string = try container.decode(String.self)

        guard let url = URL(string: string) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath,
                                                                    debugDescription: "Invalid URL string."))
        }
        return url
    }

    private func unwrapDecimal() throws -> Decimal {
        guard case .number(let numberString) = self.json else {
            throw DecodingError.typeMismatch(Decimal.self, DecodingError.Context(codingPath: self.codingPath, debugDescription: ""))
        }

        guard let decimal = Decimal(string: numberString) else {
            throw DecodingError.dataCorrupted(.init(
                codingPath: self.codingPath,
                debugDescription: "Parsed JSON number <\(numberString)> does not fit in \(Decimal.self)."))
        }

        return decimal
    }

    private func unwrapDictionary<T: Decodable>(as: T.Type) throws -> T {
        guard let dictType = T.self as? (_JSONStringDictionaryDecodableMarker & Decodable).Type else {
            preconditionFailure("Must only be called of T implements _JSONStringDictionaryDecodableMarker")
        }

        guard case .object(let object) = self.json else {
            throw DecodingError.typeMismatch([String: JSONValue].self, DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected to decode \([String: JSONValue].self) but found \(self.json.debugDataTypeDescription) instead."
            ))
        }

        var result = [String: Any]()

        for (key, value) in object {
            var newPath = self.codingPath
            newPath.append(_JSONKey(stringValue: key)!)
            let newDecoder = JSONDecoderImpl(userInfo: self.userInfo, from: value, codingPath: newPath, options: self.options)

            result[key] = try dictType.elementType.createByDirectlyUnwrapping(from: newDecoder)
        }

        return result as! T
    }

    func unwrapFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>(
        from value: JSONValue,
        for additionalKey: CodingKey? = nil,
        as type: T.Type) throws -> T
    {
        if case .number(let number) = value {
            guard let floatingPoint = T(number), floatingPoint.isFinite else {
                var path = self.codingPath
                if let additionalKey = additionalKey {
                    path.append(additionalKey)
                }
                throw DecodingError.dataCorrupted(.init(
                    codingPath: path,
                    debugDescription: "Parsed JSON number <\(number)> does not fit in \(T.self)."))
            }

            return floatingPoint
        }

        if case .string(let string) = value,
           case .convertFromString(let posInfString, let negInfString, let nanString) =
            self.options.nonConformingFloatDecodingStrategy
        {
            if string == posInfString {
                return T.infinity
            } else if string == negInfString {
                return -T.infinity
            } else if string == nanString {
                return T.nan
            }
        }

        throw self.createTypeMismatchError(type: T.self, for: additionalKey, value: value)
    }

    func unwrapFixedWidthInteger<T: FixedWidthInteger>(
        from value: JSONValue,
        for additionalKey: CodingKey? = nil,
        as type: T.Type) throws -> T
    {
        guard case .number(let number) = value else {
            throw self.createTypeMismatchError(type: T.self, for: additionalKey, value: value)
        }
        
        // this is the fast pass. Number directly convertible to Integer
        if let integer = T(number) {
            return integer
        }

        // this is the really slow path... If the fast path has failed. For example for "34.0" as
        // an integer, we try to go through NSNumber
        if let nsNumber = NSNumber.fromJSONNumber(number) {
            if type == UInt8.self, NSNumber(value: nsNumber.uint8Value) == nsNumber {
                return nsNumber.uint8Value as! T
            }
            if type == Int8.self, NSNumber(value: nsNumber.int8Value) == nsNumber {
                return nsNumber.int8Value as! T
            }
            if type == UInt16.self, NSNumber(value: nsNumber.uint16Value) == nsNumber {
                return nsNumber.uint16Value as! T
            }
            if type == Int16.self, NSNumber(value: nsNumber.int16Value) == nsNumber {
                return nsNumber.int16Value as! T
            }
            if type == UInt32.self, NSNumber(value: nsNumber.uint32Value) == nsNumber {
                return nsNumber.uint32Value as! T
            }
            if type == Int32.self, NSNumber(value: nsNumber.int32Value) == nsNumber {
                return nsNumber.int32Value as! T
            }
            if type == UInt64.self, NSNumber(value: nsNumber.uint64Value) == nsNumber {
                return nsNumber.uint64Value as! T
            }
            if type == Int64.self, NSNumber(value: nsNumber.int64Value) == nsNumber {
                return nsNumber.int64Value as! T
            }
            if type == UInt.self, NSNumber(value: nsNumber.uintValue) == nsNumber {
                return nsNumber.uintValue as! T
            }
            if type == Int.self, NSNumber(value: nsNumber.intValue) == nsNumber {
                return nsNumber.intValue as! T
            }
        }

        var path = self.codingPath
        if let additionalKey = additionalKey {
            path.append(additionalKey)
        }
        throw DecodingError.dataCorrupted(.init(
            codingPath: path,
            debugDescription: "Parsed JSON number <\(number)> does not fit in \(T.self)."))
    }

    func createTypeMismatchError(type: Any.Type, for additionalKey: CodingKey? = nil, value: JSONValue) -> DecodingError {
        var path = self.codingPath
        if let additionalKey = additionalKey {
            path.append(additionalKey)
        }

        return DecodingError.typeMismatch(type, .init(
            codingPath: path,
            debugDescription: "Expected to decode \(type) but found \(value.debugDataTypeDescription) instead."
        ))
    }
}

extension Decodable {
    fileprivate static func createByDirectlyUnwrapping(from decoder: JSONDecoderImpl) throws -> Self {
        if Self.self == URL.self
            || Self.self == Date.self
            || Self.self == Data.self
            || Self.self == Decimal.self
            || Self.self is _JSONStringDictionaryDecodableMarker.Type
        {
            return try decoder.unwrap(as: Self.self)
        }

        return try Self.init(from: decoder)
    }
}





internal struct _JSONKey: CodingKey {
    public var stringValue: String
    public var intValue: Int?

    public init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }

    public init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }

    public init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }

    internal init(index: Int) {
        self.stringValue = "Index \(index)"
        self.intValue = index
    }

    internal static let `super` = _JSONKey(stringValue: "super")!
}

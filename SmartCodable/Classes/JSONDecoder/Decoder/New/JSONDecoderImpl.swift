//
//  JSONDecoderImpl.swift
//  SmartCodable
//
//  Created by qixin on 2024/5/17.
//

import Foundation





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
            let container = KeyedContainer<Key>(
                impl: self,
                codingPath: codingPath,
                dictionary: [:]
            )
            return KeyedDecodingContainer(container)
//            throw DecodingError.valueNotFound([String: JSONValue].self, DecodingError.Context(
//                codingPath: self.codingPath,
//                debugDescription: "Cannot get keyed decoding container -- found null value instead"
//            ))
        default:
            let container = KeyedContainer<Key>(
                impl: self,
                codingPath: codingPath,
                dictionary: [:]
            )
            return KeyedDecodingContainer(container)
//            throw DecodingError.typeMismatch([String: JSONValue].self, DecodingError.Context(
//                codingPath: self.codingPath,
//                debugDescription: "Expected to decode \([String: JSONValue].self) but found \(self.json.debugDataTypeDescription) instead."
//            ))
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
            return UnkeyedContainer(
                impl: self,
                codingPath: self.codingPath,
                array: []
            )
//            throw DecodingError.valueNotFound([String: JSONValue].self, DecodingError.Context(
//                codingPath: self.codingPath,
//                debugDescription: "Cannot get unkeyed decoding container -- found null value instead"
//            ))
        default:
            return UnkeyedContainer(
                impl: self,
                codingPath: self.codingPath,
                array: []
            )
//            throw DecodingError.typeMismatch([JSONValue].self, DecodingError.Context(
//                codingPath: self.codingPath,
//                debugDescription: "Expected to decode \([JSONValue].self) but found \(self.json.debugDataTypeDescription) instead."
//            ))
        }
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        SingleValueContainer(
            impl: self,
            codingPath: self.codingPath,
            json: self.json
        )
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



extension JSONDecoderImpl {
    
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



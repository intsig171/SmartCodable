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
    
    
    /// 记录当前keyed容器的各个属性的初始化值， 不支持Unkey容器的记录。
    var cache: InitialModelCache

    init(userInfo: [CodingUserInfoKey: Any], from json: JSONValue, codingPath: [CodingKey], options: SmartJSONDecoder._Options) {
        self.userInfo = userInfo
        self.codingPath = codingPath
        self.json = json
        self.options = options
        self.cache = InitialModelCache()
    }
}


// 关于容器的生成，不用进行兼容，类型错误的时候，抛出异常，进行异常处理时，可以获取初始化值。
extension JSONDecoderImpl: Decoder {
    func container<Key>(keyedBy key: Key.Type) throws ->
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
            
        case .string(let string): // json字符串的模型化兼容
            if let dict = string.toJSONObject() as? [String: Any],
               let dictionary = JSONValue.make(dict)?.object {
                let container = KeyedContainer<Key>(
                    impl: self,
                    codingPath: codingPath,
                    dictionary: dictionary
                )
                return KeyedDecodingContainer(container)
            }
            
        case .null:
            throw DecodingError.valueNotFound([String: JSONValue].self, DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Cannot get keyed decoding container -- found null value instead"
            ))
        default:
            break
        }
        throw DecodingError.typeMismatch([String: JSONValue].self, DecodingError.Context(
            codingPath: self.codingPath,
            debugDescription: "Expected to decode \([String: JSONValue].self) but found \(self.json.debugDataTypeDescription) instead."
        ))
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



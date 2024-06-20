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
    
    
    /// Records the initialization values of the properties in the keyed container.
    var cache: DecodingCache

    init(userInfo: [CodingUserInfoKey: Any], from json: JSONValue, codingPath: [CodingKey], options: SmartJSONDecoder._Options) {
        self.userInfo = userInfo
        self.codingPath = codingPath
        self.json = json
        self.options = options
        self.cache = DecodingCache()
    }
}


// Regarding the generation of containers, there is no need for compatibility,
// when the type is wrong, an exception is thrown,
// and when the exception is handled, the initial value can be obtained.
extension JSONDecoderImpl: Decoder {
    func container<Key>(keyedBy key: Key.Type) throws ->
        KeyedDecodingContainer<Key> where Key: CodingKey {
        var newDictionary: [String: JSONValue] = [:]
        switch self.json {
        case .object(let dictionary):
            newDictionary = dictionary
        case .string(let string): // json string modeling compatibility
            if let dict = string.toJSONObject() as? [String: Any],
               let dictionary = JSONValue.make(dict)?.object {
                newDictionary = dictionary
            }
        default:
            break
        }
        let container = KeyedContainer<Key>(
            impl: self,
            codingPath: codingPath,
            dictionary: newDictionary
        )
        return KeyedDecodingContainer(container)
    }
    

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        var newArray: [JSONValue] = []
        switch self.json {
        case .array(let array):
            newArray = array
        case .string(let string): // json字符串的模型化兼容
            if let arr = string.toJSONObject() as? [Any],
               let array = JSONValue.make(arr)?.array {
               newArray = array
            }
        default:
            break
        }
        return UnkeyedContainer(
            impl: self,
            codingPath: self.codingPath,
            array: newArray
        )
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



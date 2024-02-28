//
//  CleanJSONKeyedDecodingContainer.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/10/10
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

struct CleanJSONKeyedDecodingContainer<K : CodingKey>: KeyedDecodingContainerProtocol {
    
    typealias Key = K
    
    // MARK: Properties
    
    /// A reference to the decoder we're reading from.
    let decoder: _CleanJSONDecoder
    
    /// A reference to the container we're reading from.
    let container: [String : Any]
    
    /// The path of coding keys taken to get to this point in decoding.
    internal(set) public var codingPath: [CodingKey]
    
    // MARK: - Initialization
    
    /// Initializes `self` by referencing the given decoder and container.
    init(referencing decoder: _CleanJSONDecoder, wrapping container: [String : Any]) {
        self.decoder = decoder
        self.codingPath = decoder.codingPath

        // 先对json数据格式化
        switch decoder.options.keyDecodingStrategy {
        case .useDefaultKeys:
            self.container = container
        case .convertFromSnakeCase:
            // Convert the snake case keys in the container to camel case.
            // If we hit a duplicate key after conversion, then we'll use the first one we saw. Effectively an undefined behavior with JSON dictionaries.
            self.container = Dictionary(container.map {
                dict in (SmartJSONDecoder.KeyDecodingStrategy._convertFromSnakeCase(dict.key), dict.value)
            }, uniquingKeysWith: { (first, _) in first })
        case .custom(let converter):
            self.container = Dictionary(container.map {
                key, value in (converter(decoder.codingPath + [CleanJSONKey(stringValue: key, intValue: nil)]).stringValue, value)
            }, uniquingKeysWith: { (first, _) in first })
        @unknown default:
            self.container = container
        }
    }
    
    // MARK: - KeyedDecodingContainerProtocol Methods
    
    public var allKeys: [Key] {
        return self.container.keys.compactMap { Key(stringValue: $0) }
    }
    
    public func contains(_ key: Key) -> Bool {
        return self.container[key.stringValue] != nil
    }
    
    
}



extension CleanJSONKeyedDecodingContainer {
    public func decodeNil(forKey key: Key) throws -> Bool {
        
        guard let entry = self.container[key.stringValue] else {

            // ⚠️： 输出日志信息
//            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
            return true
        }
        return entry is NSNull
    }
    
   
    @inline(__always)
    public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        /// ⚠️： 如果不存在key时，创建一个空的字典容器返回，即提供一个空字典作为默认值。是否合理？
        guard let value = self.container[key.stringValue] else {
            
            /// ⚠️日志信息： 抛出这样的日志，方便排查问题。
//            throw DecodingError.keyNotFound(key,
//                                            DecodingError.Context(codingPath: self.codingPath,
//                                                                  debugDescription: "Cannot get \(KeyedDecodingContainer<NestedKey>.self) -- no value found for key \"\(key.stringValue)\""))
            
            return nestedContainer(wrapping: [:])
        }
        
        /// ⚠️： 如果value不是字典类型，创建一个空的字典容器返回。
        guard let dictionary = value as? [String : Any] else {
            /// ⚠️日志信息： 抛出这样的日志，方便排查问题。
//            throw DecodingError._typeMismatch(at: self.codingPath, expectation: [String : Any].self, reality: value)

            return nestedContainer(wrapping: [:])
        }
        
        return nestedContainer(wrapping: dictionary)
    }
    
    @inline(__always)
    private func nestedContainer<NestedKey>(wrapping dictionary: [String: Any]) -> KeyedDecodingContainer<NestedKey> {
        let container = CleanJSONKeyedDecodingContainer<NestedKey>(referencing: decoder, wrapping: dictionary)
        return KeyedDecodingContainer(container)
    }
    
    @inline(__always)
    public func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = self.container[key.stringValue] else {
            /// ⚠️日志信息： 抛出这样的日志，方便排查问题。
//            throw DecodingError.keyNotFound(key,
//                                            DecodingError.Context(codingPath: self.codingPath, debugDescription: "Cannot get UnkeyedDecodingContainer -- no value found for key \"\(key.stringValue)\""))
  
            return CleanJSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: [])
        }
        
        guard let array = value as? [Any] else {
            /// ⚠️日志信息： 抛出这样的日志，方便排查问题。
//            throw DecodingError._typeMismatch(at: self.codingPath, expectation: [Any].self, reality: value)

            return CleanJSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: [])
        }
        
        return CleanJSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: array)
    }
    
    
    
    @inline(__always)
    public func superDecoder() throws -> Decoder {
        return try _superDecoder(forKey: CleanJSONKey.super)
    }
    
    @inline(__always)
    public func superDecoder(forKey key: Key) throws -> Decoder {
        return try _superDecoder(forKey: key)
    }
    
    @inline(__always)
    private func _superDecoder(forKey key: CodingKey) throws -> Decoder {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        let value: Any = self.container[key.stringValue] ?? NSNull()
        return _CleanJSONDecoder(referencing: value, at: self.decoder.codingPath, options: self.decoder.options)
    }
}

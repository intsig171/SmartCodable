// 
//  CleanJSONUnkeyedDecodingContainer.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/10/11
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

struct CleanJSONUnkeyedDecodingContainer : UnkeyedDecodingContainer {
    // MARK: Properties
    
    /// A reference to the decoder we're reading from.
    let decoder: _CleanJSONDecoder
    
    /// A reference to the container we're reading from.
    let container: [Any]
    
    /// The path of coding keys taken to get to this point in decoding.
    internal(set) public var codingPath: [CodingKey]
    
    /// The index of the element we're about to decode.
    internal(set) public var currentIndex: Int
    
    // MARK: - Initialization
    
    /// Initializes `self` by referencing the given decoder and container.
    init(referencing decoder: _CleanJSONDecoder, wrapping container: [Any]) {
        self.decoder = decoder
        self.container = container
        self.codingPath = decoder.codingPath
        self.currentIndex = 0
    }
    
    // MARK: - UnkeyedDecodingContainer Methods
    
    public var count: Int? {
        return self.container.count
    }
    
    public var isAtEnd: Bool {
        return self.currentIndex >= self.count!
    }
    
    public mutating func decodeNil() throws -> Bool {
        guard !self.isAtEnd else {
            throw DecodingError.valueNotFound(
                Any?.self,
                DecodingError.Context(
                    codingPath: self.decoder.codingPath + [SmartCodingKey(index: self.currentIndex)],
                    debugDescription: "Unkeyed container is at end."
                )
            )
        }
        
        
        /** 为什么是null的时候 需要currentIndex加一？
         如果使用func decode(_ type: Bool.Type)前，都进行decodeNil的判断。 self.container[self.currentIndex]的值如果是null，就不需要decode了。 如果强行decode，就会抛出异常throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Expected \(type) but found null instead."))。
         
         所以在null的时候，应该加一。 维护了currentIndex的准确性。
         */
        if self.container[self.currentIndex] is NSNull {
            self.currentIndex += 1
            return true
        } else {
            return false
        }
    }
    
   
    
    public mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> {
        self.decoder.codingPath.append(SmartCodingKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard !self.isAtEnd else {
            throw DecodingError.valueNotFound(KeyedDecodingContainer<NestedKey>.self, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Cannot get nested keyed container -- unkeyed container is at end.")
            )
        }
        
        let value = self.container[self.currentIndex]
        guard !(value is NSNull) else {
            throw DecodingError.valueNotFound(KeyedDecodingContainer<NestedKey>.self,
                                              DecodingError.Context(codingPath: self.codingPath,
                                                                    debugDescription: "Cannot get keyed decoding container -- found null value instead."))
        }
        
        guard let dictionary = value as? [String : Any] else {
            throw DecodingError._typeMismatch(at: self.codingPath, expectation: [String : Any].self, reality: value)
        }
        
        self.currentIndex += 1
        return nestedContainer(wrapping: dictionary)
    }
    
    private func nestedContainer<NestedKey>(wrapping dictionary: [String: Any] = [:]) -> KeyedDecodingContainer<NestedKey> {
        let container = CleanJSONKeyedDecodingContainer<NestedKey>(referencing: self.decoder, wrapping: dictionary)
        return KeyedDecodingContainer(container)
    }
    
    public mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        self.decoder.codingPath.append(SmartCodingKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard !self.isAtEnd else {
            throw DecodingError.valueNotFound(
                UnkeyedDecodingContainer.self,
                DecodingError.Context(codingPath: self.codingPath,
                                      debugDescription: "Cannot get nested keyed container -- unkeyed container is at end."))
        }
        
        let value = self.container[self.currentIndex]
        guard !(value is NSNull) else {
            /// ⚠️日志信息： 抛出这样的日志，方便排查问题。
//            throw DecodingError.valueNotFound(UnkeyedDecodingContainer.self,
//                                              DecodingError.Context(codingPath: self.codingPath,
//                                                                    debugDescription: "Cannot get keyed decoding container -- found null value instead."))
            self.currentIndex += 1
            return CleanJSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: [])
        }
        
        guard let array = value as? [Any] else {
            /// ⚠️日志信息： 抛出这样的日志，方便排查问题。
//            throw DecodingError._typeMismatch(at: self.codingPath, expectation: [Any].self, reality: value)

            self.currentIndex += 1
            return CleanJSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: [])
        }
        
        self.currentIndex += 1
        return CleanJSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: array)
    }
    
    public mutating func superDecoder() throws -> Decoder {
        self.decoder.codingPath.append(SmartCodingKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard !self.isAtEnd else {
            throw DecodingError.valueNotFound(Decoder.self,
                                              DecodingError.Context(codingPath: self.codingPath,
                                                                    debugDescription: "Cannot get superDecoder() -- unkeyed container is at end."))
        }
        
        let value = self.container[self.currentIndex]
        self.currentIndex += 1
        return _CleanJSONDecoder(referencing: value, at: self.decoder.codingPath, options: self.decoder.options)
    }
}

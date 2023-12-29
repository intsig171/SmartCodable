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
    private let decoder: _CleanJSONDecoder
    
    /// A reference to the container we're reading from.
    private let container: [Any]
    
    /// The path of coding keys taken to get to this point in decoding.
    private(set) public var codingPath: [CodingKey]
    
    /// The index of the element we're about to decode.
    private(set) public var currentIndex: Int
    
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
                    codingPath: self.decoder.codingPath + [CleanJSONKey(index: self.currentIndex)],
                    debugDescription: "Unkeyed container is at end."
                )
            )
        }
        
        if self.container[self.currentIndex] is NSNull {
            self.currentIndex += 1
            return true
        } else {
            return false
        }
    }
    
    public mutating func decode(_ type: Bool.Type) throws -> Bool {
        guard !self.isAtEnd else {
            return try decode(isAtEnd: true)
        }
        
        self.decoder.codingPath.append(CleanJSONKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Bool.self) else {
            return try decode()
        }
        
        self.currentIndex += 1
        return decoded
    }
    
    private mutating func decode(isAtEnd: Bool = false) throws -> Bool {
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Unkeyed.valueNotFound(
                Bool.self,
                codingPath: decoder.codingPath,
                currentIndex: currentIndex,
                isAtEnd: isAtEnd
            )
        case .useDefaultValue:
            self.currentIndex += 1
            return Bool.defaultValue
        case .custom(let adapter):
            self.currentIndex += 1
            return try adapter.adapt(decoder)
        }
    }
    
    public mutating func decode(_ type: Int.Type) throws -> Int {
        guard !self.isAtEnd else {
            return try decode(isAtEnd: true)
        }
        
        self.decoder.codingPath.append(CleanJSONKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Int.self) else {
            return try decode()
        }
        
        self.currentIndex += 1
        return decoded
    }
    
    private mutating func decode(isAtEnd: Bool = false) throws -> Int {
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Unkeyed.valueNotFound(
                Int.self,
                codingPath: decoder.codingPath,
                currentIndex: currentIndex,
                isAtEnd: isAtEnd
            )
        case .useDefaultValue:
            self.currentIndex += 1
            return Int.defaultValue
        case .custom(let adapter):
            self.currentIndex += 1
            return try adapter.adapt(decoder)
        }
    }
    
    public mutating func decode(_ type: Int8.Type) throws -> Int8 {
        guard !self.isAtEnd else {
            return Int8.defaultValue
        }
        
        self.decoder.codingPath.append(CleanJSONKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Int8.self) else {
            return Int8.defaultValue
        }
        
        self.currentIndex += 1
        return decoded
    }
    
    public mutating func decode(_ type: Int16.Type) throws -> Int16 {
        guard !self.isAtEnd else {
            return Int16.defaultValue
        }
        
        self.decoder.codingPath.append(CleanJSONKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Int16.self) else {
            return Int16.defaultValue
        }
        
        self.currentIndex += 1
        return decoded
    }
    
    public mutating func decode(_ type: Int32.Type) throws -> Int32 {
        guard !self.isAtEnd else {
            return Int32.defaultValue
        }
        
        self.decoder.codingPath.append(CleanJSONKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Int32.self) else {
            return Int32.defaultValue
        }
        
        self.currentIndex += 1
        return decoded
    }
    
    public mutating func decode(_ type: Int64.Type) throws -> Int64 {
        guard !self.isAtEnd else {
            return Int64.defaultValue
        }
        
        self.decoder.codingPath.append(CleanJSONKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Int64.self) else {
            return Int64.defaultValue
        }
        
        self.currentIndex += 1
        return decoded
    }
    
    public mutating func decode(_ type: UInt.Type) throws -> UInt {
        guard !self.isAtEnd else {
            return try decode(isAtEnd: true)
        }
        
        self.decoder.codingPath.append(CleanJSONKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: UInt.self) else {
            return try decode()
        }
        
        self.currentIndex += 1
        return decoded
    }
    
    private mutating func decode(isAtEnd: Bool = false) throws -> UInt {
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Unkeyed.valueNotFound(
                UInt.self,
                codingPath: decoder.codingPath,
                currentIndex: currentIndex,
                isAtEnd: isAtEnd
            )
        case .useDefaultValue:
            self.currentIndex += 1
            return UInt.defaultValue
        case .custom(let adapter):
            self.currentIndex += 1
            return try adapter.adapt(decoder)
        }
    }
    
    public mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        guard !self.isAtEnd else {
            return UInt8.defaultValue
        }
        
        self.decoder.codingPath.append(CleanJSONKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: UInt8.self) else {
            return UInt8.defaultValue
        }
        
        self.currentIndex += 1
        return decoded
    }
    
    public mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        guard !self.isAtEnd else {
            return UInt16.defaultValue
        }
        
        self.decoder.codingPath.append(CleanJSONKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: UInt16.self) else {
            return UInt16.defaultValue
        }
        
        self.currentIndex += 1
        return decoded
    }
    
    public mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        guard !self.isAtEnd else {
            return UInt32.defaultValue
        }
        
        self.decoder.codingPath.append(CleanJSONKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: UInt32.self) else {
            return UInt32.defaultValue
        }
        
        self.currentIndex += 1
        return decoded
    }
    
    public mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        guard !self.isAtEnd else {
            return UInt64.defaultValue
        }
        
        self.decoder.codingPath.append(CleanJSONKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: UInt64.self) else {
            return UInt64.defaultValue
        }
        
        self.currentIndex += 1
        return decoded
    }
    
    public mutating func decode(_ type: Float.Type) throws -> Float {
        guard !self.isAtEnd else {
            return try decode(isAtEnd: true)
        }
        
        self.decoder.codingPath.append(CleanJSONKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Float.self) else {
            return try decode()
        }
        
        self.currentIndex += 1
        return decoded
    }
    
    private mutating func decode(isAtEnd: Bool = false) throws -> Float {
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Unkeyed.valueNotFound(
                Float.self,
                codingPath: decoder.codingPath,
                currentIndex: currentIndex,
                isAtEnd: isAtEnd
            )
        case .useDefaultValue:
            self.currentIndex += 1
            return Float.defaultValue
        case .custom(let adapter):
            self.currentIndex += 1
            return try adapter.adapt(decoder)
        }
    }
    
    public mutating func decode(_ type: Double.Type) throws -> Double {
        guard !self.isAtEnd else {
            return try decode(isAtEnd: true)
        }
        
        self.decoder.codingPath.append(CleanJSONKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Double.self) else {
            return try decode()
        }
        
        self.currentIndex += 1
        return decoded
    }
    
    private mutating func decode(isAtEnd: Bool = false) throws -> Double {
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Unkeyed.valueNotFound(
                Double.self,
                codingPath: decoder.codingPath,
                currentIndex: currentIndex,
                isAtEnd: isAtEnd
            )
        case .useDefaultValue:
            self.currentIndex += 1
            return Double.defaultValue
        case .custom(let adapter):
            self.currentIndex += 1
            return try adapter.adapt(decoder)
        }
    }
    
    public mutating func decode(_ type: String.Type) throws -> String {
        guard !self.isAtEnd else {
            return try decode(isAtEnd: true)
        }
        
        self.decoder.codingPath.append(CleanJSONKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: String.self) else {
            return try decode()
        }
        
        self.currentIndex += 1
        return decoded
    }
    
    private mutating func decode(isAtEnd: Bool = false) throws -> String {
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Unkeyed.valueNotFound(
                String.self,
                codingPath: decoder.codingPath,
                currentIndex: currentIndex,
                isAtEnd: isAtEnd
            )
        case .useDefaultValue:
            self.currentIndex += 1
            return String.defaultValue
        case .custom(let adapter):
            self.currentIndex += 1
            return try adapter.adapt(decoder)
        }
    }
    
    public mutating func decode<T : Decodable>(_ type: T.Type) throws -> T {
        guard !self.isAtEnd else {
            throw DecodingError.valueNotFound(
                type,
                DecodingError.Context(
                    codingPath: self.decoder.codingPath + [CleanJSONKey(index: self.currentIndex)],
                    debugDescription: "Unkeyed container is at end."
                )
            )
        }
        
        self.decoder.codingPath.append(CleanJSONKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: type) else {
            throw DecodingError.valueNotFound(
                type,
                DecodingError.Context(
                    codingPath: self.decoder.codingPath + [CleanJSONKey(index: self.currentIndex)],
                    debugDescription: "Expected \(type) but found null instead."
                )
            )
        }
        
        self.currentIndex += 1
        return decoded
    }
    
    public mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> {
        self.decoder.codingPath.append(CleanJSONKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard !self.isAtEnd else {
            throw DecodingError.valueNotFound(
                KeyedDecodingContainer<NestedKey>.self,
                DecodingError.Context(
                    codingPath: self.codingPath,
                    debugDescription: "Cannot get nested keyed container -- unkeyed container is at end."
                )
            )
        }
        
        let value = self.container[self.currentIndex]
        guard !(value is NSNull) else {
            switch decoder.options.nestedContainerDecodingStrategy.valueNotFound {
            case .throw:
                throw DecodingError.Nested.valueNotFound(
                    KeyedDecodingContainer<NestedKey>.self,
                    codingPath: codingPath,
                    debugDescription: "Cannot get keyed decoding container -- found null value instead."
                )
            case .useEmptyContainer:
                self.currentIndex += 1
                return nestedContainer()
            }
        }
        
        guard let dictionary = value as? [String : Any] else {
            switch decoder.options.nestedContainerDecodingStrategy.typeMismatch {
            case .throw:
                throw DecodingError._typeMismatch(
                    at: self.codingPath,
                    expectation: [String : Any].self,
                    reality: value
                )
            case .useEmptyContainer:
                self.currentIndex += 1
                return nestedContainer()
            }
        }
        
        self.currentIndex += 1
        return nestedContainer(wrapping: dictionary)
    }
    
    private func nestedContainer<NestedKey>(wrapping dictionary: [String: Any] = [:]) -> KeyedDecodingContainer<NestedKey> {
        let container = CleanJSONKeyedDecodingContainer<NestedKey>(
            referencing: self.decoder,
            wrapping: dictionary
        )
        return KeyedDecodingContainer(container)
    }
    
    public mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        self.decoder.codingPath.append(CleanJSONKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard !self.isAtEnd else {
            throw DecodingError.valueNotFound(
                UnkeyedDecodingContainer.self,
                DecodingError.Context(
                    codingPath: self.codingPath,
                    debugDescription: "Cannot get nested keyed container -- unkeyed container is at end."
                )
            )
        }
        
        let value = self.container[self.currentIndex]
        guard !(value is NSNull) else {
            switch decoder.options.nestedContainerDecodingStrategy.valueNotFound {
            case .throw:
                throw DecodingError.Nested.valueNotFound(
                    UnkeyedDecodingContainer.self,
                    codingPath: codingPath,
                    debugDescription: "Cannot get keyed decoding container -- found null value instead."
                )
            case .useEmptyContainer:
                self.currentIndex += 1
                return CleanJSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: [])
            }
        }
        
        guard let array = value as? [Any] else {
            switch decoder.options.nestedContainerDecodingStrategy.typeMismatch {
            case .throw:
                throw DecodingError._typeMismatch(
                    at: self.codingPath,
                    expectation: [Any].self, reality: value
                )
            case .useEmptyContainer:
                self.currentIndex += 1
                return CleanJSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: [])
            }
        }
        
        self.currentIndex += 1
        return CleanJSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: array)
    }
    
    public mutating func superDecoder() throws -> Decoder {
        self.decoder.codingPath.append(CleanJSONKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard !self.isAtEnd else {
            throw DecodingError.valueNotFound(
                Decoder.self,
                DecodingError.Context(
                    codingPath: self.codingPath,
                    debugDescription: "Cannot get superDecoder() -- unkeyed container is at end."
                )
            )
        }
        
        let value = self.container[self.currentIndex]
        self.currentIndex += 1
        return _CleanJSONDecoder(
            referencing: value,
            at: self.decoder.codingPath,
            options: self.decoder.options
        )
    }
}

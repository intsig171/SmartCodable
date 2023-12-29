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
    private let decoder: _CleanJSONDecoder
    
    /// A reference to the container we're reading from.
    private let container: [String : Any]
    
    /// The path of coding keys taken to get to this point in decoding.
    private(set) public var codingPath: [CodingKey]
    
    // MARK: - Initialization
    
    /// Initializes `self` by referencing the given decoder and container.
    init(referencing decoder: _CleanJSONDecoder, wrapping container: [String : Any]) {
        self.decoder = decoder
        switch decoder.options.keyDecodingStrategy {
        case .useDefaultKeys:
            self.container = container
        case .convertFromSnakeCase:
            // Convert the snake case keys in the container to camel case.
            // If we hit a duplicate key after conversion, then we'll use the first one we saw. Effectively an undefined behavior with JSON dictionaries.
            self.container = Dictionary(container.map {
                dict in (CleanJSONDecoder.KeyDecodingStrategy._convertFromSnakeCase(dict.key), dict.value)
            }, uniquingKeysWith: { (first, _) in first })
        case .custom(let converter):
            self.container = Dictionary(container.map {
                key, value in (converter(decoder.codingPath + [CleanJSONKey(stringValue: key, intValue: nil)]).stringValue, value)
            }, uniquingKeysWith: { (first, _) in first })
        @unknown default:
            self.container = container
        }
        self.codingPath = decoder.codingPath
    }
    
    // MARK: - KeyedDecodingContainerProtocol Methods
    
    public var allKeys: [Key] {
        return self.container.keys.compactMap { Key(stringValue: $0) }
    }
    
    public func contains(_ key: Key) -> Bool {
        return self.container[key.stringValue] != nil
    }
    
    public func decodeNil(forKey key: Key) throws -> Bool {
        guard let entry = self.container[key.stringValue] else {
            throw DecodingError.Keyed.keyNotFound(key, codingPath: decoder.codingPath)
        }
        
        return entry is NSNull
    }
    
    @inline(__always)
    public func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Bool.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Bool.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    @inline(__always)
    public func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Int.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    @inline(__always)
    public func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int8.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Int8.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    @inline(__always)
    public func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int16.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Int16.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    @inline(__always)
    public func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int32.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Int32.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    @inline(__always)
    public func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int64.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Int64.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    @inline(__always)
    public func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return UInt.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    @inline(__always)
    public func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt8.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return UInt8.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    @inline(__always)
    public func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt16.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return UInt16.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    @inline(__always)
    public func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt32.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return UInt32.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    @inline(__always)
    public func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt64.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return UInt64.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    @inline(__always)
    public func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Float.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Float.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    @inline(__always)
    public func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Double.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Double.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    @inline(__always)
    public func decode(_ type: String.Type, forKey key: Key) throws -> String {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: String.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return String.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    @inline(__always)
    public func decode<T : Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        guard let entry = container[key.stringValue] else {
            switch decoder.options.keyNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.keyNotFound(key, codingPath: decoder.codingPath)
            case .useDefaultValue:
                decoder.codingPath.append(key)
                defer { decoder.codingPath.removeLast() }
                return try decoder.decodeAsDefaultValue()
            }
        }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        func decodeObject(from decoder: _CleanJSONDecoder) throws -> T {
            if let value = try decoder.unbox(entry, as: type) { return value }
            
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return try decoder.decodeAsDefaultValue()
            case .custom:
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try decoder.decode(type)
            }
        }
        
        /// 若期望解析的类型是字符串类型，则正常解析
        if let _ = String.defaultValue as? T { return try decodeObject(from: decoder) }
        
        /// 若原始值不是有效的 JSON 字符串则正常解析
        guard let string = try decoder.unbox(entry, as: String.self),
              let jsonObject = string.toJSONObject()
        else {
            return try decodeObject(from: decoder)
        }
        
        switch decoder.options.jsonStringDecodingStrategy {
        case .containsKeys(let keys) where keys.contains(where: { $0.stringValue == key.stringValue }):
            decoder.storage.push(container: jsonObject)
            defer { decoder.storage.popContainer() }
            return try decoder.decode(type)
        case .all:
            decoder.storage.push(container: jsonObject)
            defer { decoder.storage.popContainer() }
            return try decoder.decode(type)
        default:
            return try decodeObject(from: decoder)
        }
    }
    
    @inline(__always)
    public func nestedContainer<NestedKey>(
        keyedBy type: NestedKey.Type,
        forKey key: Key
    ) throws -> KeyedDecodingContainer<NestedKey> {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = self.container[key.stringValue] else {
            switch decoder.options.nestedContainerDecodingStrategy.keyNotFound {
            case .throw:
                throw DecodingError.Nested.keyNotFound(key, codingPath: codingPath)
            case .useEmptyContainer:
                return nestedContainer()
            }
        }
        
        guard let dictionary = value as? [String : Any] else {
            switch decoder.options.nestedContainerDecodingStrategy.typeMismatch {
            case .throw:
                throw DecodingError._typeMismatch(
                    at: self.codingPath,
                    expectation: [String : Any].self,
                    reality: value)
            case .useEmptyContainer:
                return nestedContainer()
            }
        }
        
        return nestedContainer(wrapping: dictionary)
    }
    
    @inline(__always)
    private func nestedContainer<NestedKey>(
        wrapping dictionary: [String: Any] = [:]
    ) -> KeyedDecodingContainer<NestedKey> {
        let container = CleanJSONKeyedDecodingContainer<NestedKey>(
            referencing: decoder,
            wrapping: dictionary
        )
        return KeyedDecodingContainer(container)
    }
    
    @inline(__always)
    public func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = self.container[key.stringValue] else {
            switch decoder.options.nestedContainerDecodingStrategy.keyNotFound {
            case .throw:
                throw DecodingError.Nested.keyNotFound(key, codingPath: codingPath, isUnkeyed: true)
            case .useEmptyContainer:
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
                return CleanJSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: [])
            }
        }
        
        return CleanJSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: array)
    }
    
    @inline(__always)
    private func _superDecoder(forKey key: CodingKey) throws -> Decoder {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        let value: Any = self.container[key.stringValue] ?? NSNull()
        return _CleanJSONDecoder(
            referencing: value,
            at: self.decoder.codingPath,
            options: self.decoder.options
        )
    }
    
    @inline(__always)
    public func superDecoder() throws -> Decoder {
        return try _superDecoder(forKey: CleanJSONKey.super)
    }
    
    @inline(__always)
    public func superDecoder(forKey key: Key) throws -> Decoder {
        return try _superDecoder(forKey: key)
    }
}

extension CleanJSONKeyedDecodingContainer {
    
    @inline(__always)
    func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try decoder.unbox(entry, as: type) { return value }
        
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
        case .useDefaultValue:
            return nil
        case .custom(let adapter):
            decoder.storage.push(container: entry)
            defer { decoder.storage.popContainer() }
            return try adapter.adaptIfPresent(decoder)
        }
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try decoder.unbox(entry, as: type) { return value }
        
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
        case .useDefaultValue:
            return nil
        case .custom(let adapter):
            decoder.storage.push(container: entry)
            defer { decoder.storage.popContainer() }
            return try adapter.adaptIfPresent(decoder)
        }
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: Int8.Type, forKey key: K) throws -> Int8? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try decoder.unbox(entry, as: type) { return value }
        
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
        case .useDefaultValue:
            return nil
        case .custom(let adapter):
            decoder.storage.push(container: entry)
            defer { decoder.storage.popContainer() }
            return try adapter.adaptIfPresent(decoder)
        }
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: Int16.Type, forKey key: K) throws -> Int16? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try decoder.unbox(entry, as: type) { return value }
        
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
        case .useDefaultValue:
            return nil
        case .custom(let adapter):
            decoder.storage.push(container: entry)
            defer { decoder.storage.popContainer() }
            return try adapter.adaptIfPresent(decoder)
        }
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: Int32.Type, forKey key: K) throws -> Int32? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try decoder.unbox(entry, as: type) { return value }
        
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
        case .useDefaultValue:
            return nil
        case .custom(let adapter):
            decoder.storage.push(container: entry)
            defer { decoder.storage.popContainer() }
            return try adapter.adaptIfPresent(decoder)
        }
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: Int64.Type, forKey key: K) throws -> Int64? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try decoder.unbox(entry, as: type) { return value }
        
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
        case .useDefaultValue:
            return nil
        case .custom(let adapter):
            decoder.storage.push(container: entry)
            defer { decoder.storage.popContainer() }
            return try adapter.adaptIfPresent(decoder)
        }
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: UInt.Type, forKey key: K) throws -> UInt? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try decoder.unbox(entry, as: type) { return value }
        
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
        case .useDefaultValue:
            return nil
        case .custom(let adapter):
            decoder.storage.push(container: entry)
            defer { decoder.storage.popContainer() }
            return try adapter.adaptIfPresent(decoder)
        }
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: UInt8.Type, forKey key: K) throws -> UInt8? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try decoder.unbox(entry, as: type) { return value }
        
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
        case .useDefaultValue:
            return nil
        case .custom(let adapter):
            decoder.storage.push(container: entry)
            defer { decoder.storage.popContainer() }
            return try adapter.adaptIfPresent(decoder)
        }
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: UInt16.Type, forKey key: K) throws -> UInt16? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try decoder.unbox(entry, as: type) { return value }
        
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
        case .useDefaultValue:
            return nil
        case .custom(let adapter):
            decoder.storage.push(container: entry)
            defer { decoder.storage.popContainer() }
            return try adapter.adaptIfPresent(decoder)
        }
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: UInt32.Type, forKey key: K) throws -> UInt32? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try decoder.unbox(entry, as: type) { return value }
        
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
        case .useDefaultValue:
            return nil
        case .custom(let adapter):
            decoder.storage.push(container: entry)
            defer { decoder.storage.popContainer() }
            return try adapter.adaptIfPresent(decoder)
        }
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: UInt64.Type, forKey key: K) throws -> UInt64? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try decoder.unbox(entry, as: type) { return value }
        
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
        case .useDefaultValue:
            return nil
        case .custom(let adapter):
            decoder.storage.push(container: entry)
            defer { decoder.storage.popContainer() }
            return try adapter.adaptIfPresent(decoder)
        }
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: Float.Type, forKey key: K) throws -> Float? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try decoder.unbox(entry, as: type) { return value }
        
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
        case .useDefaultValue:
            return nil
        case .custom(let adapter):
            decoder.storage.push(container: entry)
            defer { decoder.storage.popContainer() }
            return try adapter.adaptIfPresent(decoder)
        }
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try decoder.unbox(entry, as: type) { return value }
        
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
        case .useDefaultValue:
            return nil
        case .custom(let adapter):
            decoder.storage.push(container: entry)
            defer { decoder.storage.popContainer() }
            return try adapter.adaptIfPresent(decoder)
        }
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try decoder.unbox(entry, as: type) { return value }
        
        switch decoder.options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
        case .useDefaultValue:
            return nil
        case .custom(let adapter):
            decoder.storage.push(container: entry)
            defer { decoder.storage.popContainer() }
            return try adapter.adaptIfPresent(decoder)
        }
    }
    
    @inline(__always)
    func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if type == Date.self || type == NSDate.self {
            return try decoder.decodeIfPresent(entry, as: Date.self, forKey: key) as? T
        } else if type == Data.self || type == NSData.self {
            return try decoder.decodeIfPresent(entry, as: Data.self, forKey: key) as? T
        } else if type == URL.self || type == NSURL.self {
            return try decoder.decodeIfPresent(entry, as: URL.self, forKey: key) as? T
        } else if type == Decimal.self || type == NSDecimalNumber.self {
            return try decoder.decodeIfPresent(entry, as: Decimal.self, forKey: key) as? T
        }
        
        if try decodeNil(forKey: key) { return nil }
        
        func decodeObject(from decoder: _CleanJSONDecoder) throws -> T? {
            if let value = try decoder.unbox(entry, as: type) { return value }
            
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return nil
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adaptIfPresent(decoder)
            }
        }
        
        /// 若期望解析的类型是字符串类型，则正常解析
        if let _ = String.defaultValue as? T { return try decodeObject(from: decoder) }
        
        /// 若原始值不是有效的 JSON 字符串则正常解析
        guard let string = try decoder.unbox(entry, as: String.self),
              let jsonObject = string.toJSONObject()
        else {
            return try decodeObject(from: decoder)
        }
        
        switch decoder.options.jsonStringDecodingStrategy {
        case .containsKeys(let keys) where keys.contains(where: { $0.stringValue == key.stringValue }):
            return try decoder.unbox(jsonObject, as: type)
        case .all:
            return try decoder.unbox(jsonObject, as: type)
        default:
            return try decodeObject(from: decoder)
        }
    }
}

private extension CleanJSONDecoder.KeyDecodingStrategy {
    
    static func _convertFromSnakeCase(_ stringKey: String) -> String {
        guard !stringKey.isEmpty else { return stringKey }
        
        // Find the first non-underscore character
        guard let firstNonUnderscore = stringKey.firstIndex(where: { $0 != "_" }) else {
            // Reached the end without finding an _
            return stringKey
        }
        
        // Find the last non-underscore character
        var lastNonUnderscore = stringKey.index(before: stringKey.endIndex)
        while lastNonUnderscore > firstNonUnderscore && stringKey[lastNonUnderscore] == "_" {
            stringKey.formIndex(before: &lastNonUnderscore)
        }
        
        let keyRange = firstNonUnderscore...lastNonUnderscore
        let leadingUnderscoreRange = stringKey.startIndex..<firstNonUnderscore
        let trailingUnderscoreRange = stringKey.index(after: lastNonUnderscore)..<stringKey.endIndex
        
        let components = stringKey[keyRange].split(separator: "_")
        let joinedString : String
        if components.count == 1 {
            // No underscores in key, leave the word as is - maybe already camel cased
            joinedString = String(stringKey[keyRange])
        } else {
            joinedString = ([components[0].lowercased()] + components[1...].map { $0.capitalized }).joined()
        }
        
        // Do a cheap isEmpty check before creating and appending potentially empty strings
        let result : String
        if (leadingUnderscoreRange.isEmpty && trailingUnderscoreRange.isEmpty) {
            result = joinedString
        } else if (!leadingUnderscoreRange.isEmpty && !trailingUnderscoreRange.isEmpty) {
            // Both leading and trailing underscores
            result = String(stringKey[leadingUnderscoreRange]) + joinedString + String(stringKey[trailingUnderscoreRange])
        } else if (!leadingUnderscoreRange.isEmpty) {
            // Just leading
            result = String(stringKey[leadingUnderscoreRange]) + joinedString
        } else {
            // Just trailing
            result = joinedString + String(stringKey[trailingUnderscoreRange])
        }
        return result
    }
}

private extension CleanJSONKeyedDecodingContainer {
    
    func decodeIfKeyNotFound<T>(_ key: Key) throws -> T where T: Decodable, T: Defaultable {
        switch decoder.options.keyNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.keyNotFound(key, codingPath: decoder.codingPath)
        case .useDefaultValue:
            return T.defaultValue
        }
    }
}

private extension String {
    
    func toJSONObject() -> Any? {
        // 过滤掉非 JSON 格式字符串
        guard hasPrefix("{") || hasPrefix("[") else { return nil }
        
        guard let data = data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: data) else {
            return nil
        }
        
        return jsonObject
    }
}

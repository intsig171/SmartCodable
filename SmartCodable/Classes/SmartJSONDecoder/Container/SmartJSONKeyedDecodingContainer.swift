//
//  SmartJSONKeyedDecodingContainer.swift
//  SmartCodable
//
//  Created by Mccc on 2024/3/4.
//

import Foundation

struct SmartJSONKeyedDecodingContainer<K : CodingKey>: KeyedDecodingContainerProtocol {
    
    typealias Key = K
    
    // MARK: Properties
    
    /// A reference to the decoder we're reading from.
    let decoder: _SmartJSONDecoder
    
    /// A reference to the container we're reading from.
    let container: [String : Any]
    
    /// The path of coding keys taken to get to this point in decoding.
    internal(set) public var codingPath: [CodingKey]
    
    // MARK: - Initialization
    
    /// Initializes `self` by referencing the given decoder and container.
    init(referencing decoder: _SmartJSONDecoder, wrapping container: [String : Any]) {
        self.decoder = decoder
        self.codingPath = decoder.codingPath
        
        switch decoder.options.keyDecodingStrategy {
        case .useDefaultKeys:
            self.container = container
        case .fromSnakeCase:
            // Convert the snake case keys in the container to camel case.
            // If we hit a duplicate key after conversion, then we'll use the first one we saw. Effectively an undefined behavior with JSON dictionaries.
            self.container = Dictionary(container.map {
                dict in (JSONDecoder.SmartKeyDecodingStrategy._convertFromSnakeCase(dict.key), dict.value)
            }, uniquingKeysWith: { (first, _) in first })
        case .firstLetterLower:
            self.container = Dictionary(container.map {
                dict in (JSONDecoder.SmartKeyDecodingStrategy._convertFirstLetterToLowercase(dict.key), dict.value)
            }, uniquingKeysWith: { (first, _) in first })
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


extension SmartJSONKeyedDecodingContainer {
    
    public func decodeNil(forKey key: Key) throws -> Bool {
        guard let entry = self.container[key.stringValue] else {
            return true
        }
        return entry is NSNull
    }
    
    public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = self.container[key.stringValue] else {
            return nestedContainer(wrapping: [:])
        }
        
        guard let dictionary = value as? [String : Any] else {
            return nestedContainer(wrapping: [:])
        }
        return nestedContainer(wrapping: dictionary)
    }
    
    private func nestedContainer<NestedKey>(wrapping dictionary: [String: Any]) -> KeyedDecodingContainer<NestedKey> {
        let container = SmartJSONKeyedDecodingContainer<NestedKey>(referencing: decoder, wrapping: dictionary)
        return KeyedDecodingContainer(container)
    }
    
    public func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = self.container[key.stringValue] else {
            return SmartSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: [])
        }
        
        guard let array = value as? [Any] else {
            return SmartSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: [])
        }
        
        return SmartSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: array)
    }
    
    public func superDecoder() throws -> Decoder {
        return try _superDecoder(forKey: SmartCodingKey.super)
    }
    
    public func superDecoder(forKey key: Key) throws -> Decoder {
        return try _superDecoder(forKey: key)
    }
    
    private func _superDecoder(forKey key: CodingKey) throws -> Decoder {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        let value: Any = self.container[key.stringValue] ?? NSNull()
        return _SmartJSONDecoder(referencing: value, at: self.decoder.codingPath, options: self.decoder.options)
    }
}


extension SmartJSONKeyedDecodingContainer {
    func didFinishMapping<T: Decodable>(_ decodeValue: T) -> T {
        return DecodingProcessCoordinator.didFinishMapping(decodeValue)
    }
}

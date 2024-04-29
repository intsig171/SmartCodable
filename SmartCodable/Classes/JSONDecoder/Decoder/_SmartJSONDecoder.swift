// 
//  _SmartJSONDecoder.swift
//  SmartCodable
//
//  Created by Mccc on 2024/3/4.
//

import Foundation

final class _SmartJSONDecoder: Decoder {
    
    /// The decoder's storage.
    var storage: SmartJSONDecodingStorage
    
    var cache: InitialModelCache
        
    /// Options set on the top-level decoder.
    let options: SmartJSONDecoder.Options
    
    /// The path to the current point in encoding.
    public var codingPath: [CodingKey]
    
    /// Contextual user-provided information for use during encoding.
    public var userInfo: [CodingUserInfoKey : Any] {
        return self.options.userInfo
    }
    
    // MARK: - Initialization
    
    /// Initializes `self` with the given top-level container and options.
    init(referencing container: Any, at codingPath: [CodingKey] = [], options: SmartJSONDecoder.Options) {
        self.storage = SmartJSONDecodingStorage()
        self.storage.push(container: container)
        self.codingPath = codingPath
        self.options = options
        self.cache = InitialModelCache()
    }
    
    // MARK: - Decoder Methods
    
    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        
        guard !(self.storage.topContainer is NSNull) else {
            let container = SmartJSONKeyedDecodingContainer<Key>(referencing: self, wrapping: [:])
            return KeyedDecodingContainer(container)
        }
        
        guard let topContainer = self.storage.topContainer as? [String : Any] else {
            let container = SmartJSONKeyedDecodingContainer<Key>(referencing: self, wrapping: [:])
            return KeyedDecodingContainer(container)
        }
        
        let container = SmartJSONKeyedDecodingContainer<Key>(referencing: self, wrapping: topContainer)
        return KeyedDecodingContainer(container)
    }
    
    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        
        guard !(self.storage.topContainer is NSNull) else {
            return SmartSONUnkeyedDecodingContainer(referencing: self, wrapping: [])
        }
        
        guard let topContainer = self.storage.topContainer as? [Any] else {
            return SmartSONUnkeyedDecodingContainer(referencing: self, wrapping: [])
        }
        
        return SmartSONUnkeyedDecodingContainer(referencing: self, wrapping: topContainer)
    }
    
    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        return self
    }
}

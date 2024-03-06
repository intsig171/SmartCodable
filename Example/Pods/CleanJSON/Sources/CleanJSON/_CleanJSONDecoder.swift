// 
//  _CleanJSONDecoder.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/10/10
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

final class _CleanJSONDecoder: CleanDecoder {
    
    /// The decoder's storage.
    var storage: CleanJSONDecodingStorage
    
    /// Options set on the top-level decoder.
    let options: CleanJSONDecoder.Options
    
    /// The path to the current point in encoding.
    public var codingPath: [CodingKey]
    
    /// Contextual user-provided information for use during encoding.
    public var userInfo: [CodingUserInfoKey : Any] {
        return self.options.userInfo
    }
    
    // MARK: - Initialization
    
    /// Initializes `self` with the given top-level container and options.
    init(referencing container: Any, at codingPath: [CodingKey] = [], options: CleanJSONDecoder.Options) {
        self.storage = CleanJSONDecodingStorage()
        self.storage.push(container: container)
        self.codingPath = codingPath
        self.options = options
    }
    
    // MARK: - Decoder Methods
    
    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        guard !(self.storage.topContainer is NSNull) else {
            switch options.nestedContainerDecodingStrategy.valueNotFound {
            case .throw:
                throw DecodingError.Nested.valueNotFound(
                    KeyedDecodingContainer<Key>.self,
                    codingPath: codingPath,
                    debugDescription: "Cannot get keyed decoding container -- found null value instead."
                )
            case .useEmptyContainer:
                let container = CleanJSONKeyedDecodingContainer<Key>(
                    referencing: self,
                    wrapping: [:]
                )
                return KeyedDecodingContainer(container)
            }
        }
        
        guard let topContainer = self.storage.topContainer as? [String : Any] else {
            switch options.nestedContainerDecodingStrategy.typeMismatch {
            case .throw:
                throw DecodingError._typeMismatch(
                    at: codingPath,
                    expectation: [String : Any].self,
                    reality: storage.topContainer
                )
            case .useEmptyContainer:
                let container = CleanJSONKeyedDecodingContainer<Key>(
                    referencing: self,
                    wrapping: [:]
                )
                return KeyedDecodingContainer(container)
            }
        }
        
        let container = CleanJSONKeyedDecodingContainer<Key>(
            referencing: self,
            wrapping: topContainer
        )
        return KeyedDecodingContainer(container)
    }
    
    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard !(self.storage.topContainer is NSNull) else {
            switch options.nestedContainerDecodingStrategy.valueNotFound {
            case .throw:
                throw DecodingError.Nested.valueNotFound(
                    UnkeyedDecodingContainer.self,
                    codingPath: codingPath,
                    debugDescription: "Cannot get unkeyed decoding container -- found null value instead."
                )
            case .useEmptyContainer:
                return CleanJSONUnkeyedDecodingContainer(referencing: self, wrapping: [])
            }
        }
        
        guard let topContainer = self.storage.topContainer as? [Any] else {
            switch options.nestedContainerDecodingStrategy.typeMismatch {
            case .throw:
                throw DecodingError._typeMismatch(
                    at: codingPath,
                    expectation: [Any].self,
                    reality: storage.topContainer
                )
            case .useEmptyContainer:
                return CleanJSONUnkeyedDecodingContainer(referencing: self, wrapping: [])
            }
        }
        
        return CleanJSONUnkeyedDecodingContainer(referencing: self, wrapping: topContainer)
    }
    
    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        return self
    }
}

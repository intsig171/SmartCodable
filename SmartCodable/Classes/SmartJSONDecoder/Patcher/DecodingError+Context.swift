// 
//  DecodingError+CleanJSON.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/10/11
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation
























extension DecodingError {
    
    struct Unkeyed {
        
        static func valueNotFound(
            _ type: Any.Type,
            codingPath: [CodingKey],
            currentIndex: Int,
            isAtEnd: Bool = false
        ) -> DecodingError {
            let debugDescription = isAtEnd
                ? "Unkeyed container is at end."
                : "Expected \(type) but found null instead."
            return DecodingError.valueNotFound(
                type,
                DecodingError.Context(
                    codingPath: codingPath + [CleanJSONKey(index: currentIndex)],
                    debugDescription: debugDescription
                )
            )
        }
    }
}

extension DecodingError {
    
    struct Nested {
        
        static func keyNotFound<Key: CodingKey>(_ key: Key, codingPath: [CodingKey], isUnkeyed: Bool = false) -> DecodingError {
            let debugDescription = isUnkeyed
                ? "Cannot get UnkeyedDecodingContainer -- no value found for key \("\(key) (\"\(key.stringValue)\")")"
                : "Cannot get \(KeyedDecodingContainer<Key>.self) -- no value found for key \("\(key) (\"\(key.stringValue)\")")"
            return DecodingError.keyNotFound(
                key,
                DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: debugDescription
                )
            )
        }
        
        static func valueNotFound(
            _ type: Any.Type,
            codingPath: [CodingKey],
            debugDescription: String
        ) -> DecodingError {
            return DecodingError.valueNotFound(
                type,
                DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: debugDescription
                )
            )
        }
    }
}

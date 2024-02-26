// 
//  DecodingError+CleanJSON.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/10/11
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

extension DecodingError {
    /// Returns a `.typeMismatch` error describing the expected type.
    ///
    /// - parameter path: The path of `CodingKey`s taken to decode a value of this type.
    /// - parameter expectation: The type expected to be encountered.
    /// - parameter reality: The value that was encountered instead of the expected type.
    /// - returns: A `DecodingError` with the appropriate path and debug description.
    static func _typeMismatch(at path: [CodingKey], expectation: Any.Type, reality: Any) -> DecodingError {
        let description = "Expected to decode \(expectation) but found \(_typeDescription(of: reality)) instead."
        return .typeMismatch(expectation, Context(codingPath: path, debugDescription: description))
    }
    
    /// Returns a description of the type of `value` appropriate for an error message.
    ///
    /// - parameter value: The value whose type to describe.
    /// - returns: A string describing `value`.
    /// - precondition: `value` is one of the types below.
    private static func _typeDescription(of value: Any) -> String {
        if value is NSNull {
            return "a null value"
        } else if value is NSNumber /* FIXME: If swift-corelibs-foundation isn't updated to use NSNumber, this check will be necessary: || value is Int || value is Double */ {
            return "a number"
        } else if value is String {
            return "a string/data"
        } else if value is [Any] {
            return "an array"
        } else if value is [String : Any] {
            return "a dictionary"
        } else {
            return "\(type(of: value))"
        }
    }
}

extension DecodingError {
    
    struct Keyed {
        
        static func keyNotFound<Key: CodingKey>(_ key: Key, codingPath: [CodingKey]) -> DecodingError {
            return .keyNotFound(
                key,
                DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "No value associated with key \("\(key) (\"\(key.stringValue)\")")."
                )
            )
        }
        
        static func valueNotFound(_ type: Any.Type, codingPath: [CodingKey]) -> DecodingError {
            return DecodingError.valueNotFound(
                type,
                DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Expected \(type) value but found null instead."
                )
            )
        }
    }
}

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

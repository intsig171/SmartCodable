// 
//  _CleanJSONDecoder+SingleValueDecodingContainer.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/10/11
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

extension _CleanJSONDecoder : SingleValueDecodingContainer {
    // MARK: SingleValueDecodingContainer Methods
    
    public func decodeNil() -> Bool {
        return storage.topContainer is NSNull
    }
    
    public func decode(_ type: Bool.Type) throws -> Bool {
        if let value = try unbox(storage.topContainer, as: Bool.self) { return value }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
        case .useDefaultValue:
            return Bool.defaultValue
        case .custom(let adapter):
            return try adapter.adapt(self)
        }
    }
    
    public func decode(_ type: Int.Type) throws -> Int {
        if let value = try unbox(storage.topContainer, as: Int.self) { return value }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
        case .useDefaultValue:
            return Int.defaultValue
        case .custom(let adapter):
            return try adapter.adapt(self)
        }
    }
    
    public func decode(_ type: Int8.Type) throws -> Int8 {
        if let value = try unbox(storage.topContainer, as: Int8.self) { return value }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
        case .useDefaultValue:
            return Int8.defaultValue
        case .custom(let adapter):
            return try adapter.adapt(self)
        }
    }
    
    public func decode(_ type: Int16.Type) throws -> Int16 {
        if let value = try unbox(storage.topContainer, as: Int16.self) { return value }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
        case .useDefaultValue:
            return Int16.defaultValue
        case .custom(let adapter):
            return try adapter.adapt(self)
        }
    }
    
    public func decode(_ type: Int32.Type) throws -> Int32 {
        if let value = try unbox(storage.topContainer, as: Int32.self) { return value }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
        case .useDefaultValue:
            return Int32.defaultValue
        case .custom(let adapter):
            return try adapter.adapt(self)
        }
    }
    
    public func decode(_ type: Int64.Type) throws -> Int64 {
        if let value = try unbox(storage.topContainer, as: Int64.self) { return value }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
        case .useDefaultValue:
            return Int64.defaultValue
        case .custom(let adapter):
            return try adapter.adapt(self)
        }
    }
    
    public func decode(_ type: UInt.Type) throws -> UInt {
        if let value = try unbox(storage.topContainer, as: UInt.self) { return value }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
        case .useDefaultValue:
            return UInt.defaultValue
        case .custom(let adapter):
            return try adapter.adapt(self)
        }
    }
    
    public func decode(_ type: UInt8.Type) throws -> UInt8 {
        if let value = try unbox(storage.topContainer, as: UInt8.self) { return value }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
        case .useDefaultValue:
            return UInt8.defaultValue
        case .custom(let adapter):
            return try adapter.adapt(self)
        }
    }
    
    public func decode(_ type: UInt16.Type) throws -> UInt16 {
        if let value = try unbox(storage.topContainer, as: UInt16.self) { return value }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
        case .useDefaultValue:
            return UInt16.defaultValue
        case .custom(let adapter):
            return try adapter.adapt(self)
        }
    }
    
    public func decode(_ type: UInt32.Type) throws -> UInt32 {
        if let value = try unbox(storage.topContainer, as: UInt32.self) { return value }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
        case .useDefaultValue:
            return UInt32.defaultValue
        case .custom(let adapter):
            return try adapter.adapt(self)
        }
    }
    
    public func decode(_ type: UInt64.Type) throws -> UInt64 {
        if let value = try unbox(storage.topContainer, as: UInt64.self) { return value }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
        case .useDefaultValue:
            return UInt64.defaultValue
        case .custom(let adapter):
            return try adapter.adapt(self)
        }
    }
    
    public func decode(_ type: Float.Type) throws -> Float {
        if let value = try unbox(storage.topContainer, as: Float.self) { return value }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
        case .useDefaultValue:
            return Float.defaultValue
        case .custom(let adapter):
            return try adapter.adapt(self)
        }
    }
    
    public func decode(_ type: Double.Type) throws -> Double {
        if let value = try unbox(storage.topContainer, as: Double.self) { return value }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
        case .useDefaultValue:
            return Double.defaultValue
        case .custom(let adapter):
            return try adapter.adapt(self)
        }
    }
    
    public func decode(_ type: String.Type) throws -> String {
        if let value = try unbox(storage.topContainer, as: String.self) { return value }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
        case .useDefaultValue:
            return String.defaultValue
        case .custom(let adapter):
            return try adapter.adapt(self)
        }
    }
    
    public func decode<T : Decodable>(_ type: T.Type) throws -> T {
        if type == Date.self || type == NSDate.self {
            return try decode(as: Date.self) as! T
        } else if type == Data.self || type == NSData.self {
            return try decode(as: Data.self) as! T
        } else if type == Decimal.self || type == NSDecimalNumber.self {
            return try decode(as: Decimal.self) as! T
        }
        
        if let value = try unbox(storage.topContainer, as: type) { return value }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
        case .useDefaultValue, .custom:
            return try decodeAsDefaultValue()
        }
    }
}

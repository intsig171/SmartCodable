// 
//  _CleanJSONDecoder+Decode.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/5/27
//  Copyright © 2019 Pircate. All rights reserved.
//

import Foundation

extension _CleanJSONDecoder {
    
    func decodeAsDefaultValue<T: Decodable>() throws -> T {
        if let array = [] as? T {
            return array
        } else if let string = String.defaultValue as? T {
            return string
        } else if let bool = Bool.defaultValue as? T {
            return bool
        } else if let int = Int.defaultValue as? T {
            return int
        }else if let double = Double.defaultValue as? T {
            return double
        } else if let date = Date.defaultValue(for: options.dateDecodingStrategy) as? T {
            return date
        } else if let data = Data.defaultValue as? T {
            return data
        } else if let decimal = Decimal.defaultValue as? T {
            return decimal
        } else if let object = try? unbox([:], as: T.self) {
            return object
        }
        
        let context = DecodingError.Context(
            codingPath: codingPath,
            debugDescription: "Key: <\(codingPath)> cannot be decoded as default value."
        )
        throw DecodingError.dataCorrupted(context)
    }
}

extension _CleanJSONDecoder {
    
    func decode(as type: Date.Type) throws -> Date {
        if let date = try unbox(storage.topContainer, as: type) { return date }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
        case .useDefaultValue:
            return Date.defaultValue(for: options.dateDecodingStrategy)
        case .custom(let adapter):
            return try adapter.adapt(self)
        }
    }
    
    func decode(as type: Data.Type) throws -> Data {
        if let data = try unbox(storage.topContainer, as: type) { return data }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
        case .useDefaultValue:
            return Data.defaultValue
        case .custom(let adapter):
            return try adapter.adapt(self)
        }
    }
    
    func decode(as type: Decimal.Type) throws -> Decimal {
        if let decimal = try unbox(storage.topContainer, as: type) { return decimal }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
        case .useDefaultValue:
            return Decimal.defaultValue
        case .custom(let adapter):
            return try adapter.adapt(self)
        }
    }
}

extension _CleanJSONDecoder {
    
    func decodeIfPresent<K: CodingKey>(
        _ value: Any,
        as type: Date.Type,
        forKey key: K
    ) throws -> Date? {
        if let date = try unbox(value, as: type) { return date }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.keyNotFound(key, codingPath: codingPath)
        case .useDefaultValue:
            return nil
        case .custom(let adapter):
            storage.push(container: value)
            defer { storage.popContainer() }
            return try adapter.adaptIfPresent(self)
        }
    }
    
    func decodeIfPresent<K: CodingKey>(
        _ value: Any,
        as type: Data.Type,
        forKey key: K
    ) throws -> Data? {
        if let data = try unbox(value, as: type) { return data }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.keyNotFound(key, codingPath: codingPath)
        case .useDefaultValue:
            return nil
        case .custom(let adapter):
            storage.push(container: value)
            defer { storage.popContainer() }
            return try adapter.adaptIfPresent(self)
        }
    }
    
    func decodeIfPresent<K: CodingKey>(
        _ value: Any,
        as type: URL.Type,
        forKey key: K
    ) throws -> URL? {
        if let url = try unbox(value, as: type) { return url }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.keyNotFound(key, codingPath: codingPath)
        case .useDefaultValue:
            return nil
        case .custom(let adapter):
            storage.push(container: value)
            defer { storage.popContainer() }
            return try adapter.adaptIfPresent(self)
        }
    }
    
    func decodeIfPresent<K: CodingKey>(
        _ value: Any,
        as type: Decimal.Type,
        forKey key: K
    ) throws -> Decimal? {
        if let decimal = try unbox(value, as: type) { return decimal }
        
        switch options.valueNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.keyNotFound(key, codingPath: codingPath)
        case .useDefaultValue:
            return nil
        case .custom(let adapter):
            storage.push(container: value)
            defer { storage.popContainer() }
            return try adapter.adaptIfPresent(self)
        }
    }
}

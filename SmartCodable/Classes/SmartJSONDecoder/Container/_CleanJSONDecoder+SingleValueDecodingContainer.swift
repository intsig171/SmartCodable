// 
//  CleanJSONSingleValueDecodingContainer.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/10/11
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation



extension _CleanJSONDecoder {
    fileprivate func smartDecode<T: Decodable>(_ type: T.Type) throws -> T {
        let entry = storage.topContainer
        if let value = Patcher<T>.patchWithConvertOrDefault(value: entry) { return value }
        throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Expected \(type) but found null value instead."))
    }
}

/// 让解析器实现SingleValueDecodingContainer协议
extension _CleanJSONDecoder : SingleValueDecodingContainer {
    
    // MARK: SingleValueDecodingContainer Methods

    public func decodeNil() -> Bool {
        return storage.topContainer is NSNull
    }
    
    public func decode(_ type: Bool.Type) throws -> Bool {
        guard let decoded = try? unbox(storage.topContainer, as: Bool.self) else {
            return try smartDecode(type)
        }
        return decoded
    }
    
    public func decode(_ type: Int.Type) throws -> Int {
        guard let decoded = try? unbox(storage.topContainer, as: Int.self) else {
            return try smartDecode(type)
        }
        return decoded
    }
    
    public func decode(_ type: Int8.Type) throws -> Int8 {
        guard let decoded = try? unbox(storage.topContainer, as: Int8.self) else {
            return try smartDecode(type)
        }
        return decoded
    }
    
    public func decode(_ type: Int16.Type) throws -> Int16 {
        guard let decoded = try? unbox(storage.topContainer, as: Int16.self) else {
            return try smartDecode(type)
        }
        return decoded
    }
    
    public func decode(_ type: Int32.Type) throws -> Int32 {
        guard let decoded = try? unbox(storage.topContainer, as: Int32.self) else {
            return try smartDecode(type)
        }
        return decoded
    }
    
    public func decode(_ type: Int64.Type) throws -> Int64 {
        guard let decoded = try? unbox(storage.topContainer, as: Int64.self) else {
            return try smartDecode(type)
        }
        return decoded
    }
    
    public func decode(_ type: UInt.Type) throws -> UInt {
        guard let decoded = try? unbox(storage.topContainer, as: UInt.self) else {
            return try smartDecode(type)
        }
        return decoded
    }
    
    public func decode(_ type: UInt8.Type) throws -> UInt8 {
        guard let decoded = try? unbox(storage.topContainer, as: UInt8.self) else {
            return try smartDecode(type)
        }
        return decoded
    }
    
    public func decode(_ type: UInt16.Type) throws -> UInt16 {
        guard let decoded = try? unbox(storage.topContainer, as: UInt16.self) else {
            return try smartDecode(type)
        }
        return decoded
    }
    
    public func decode(_ type: UInt32.Type) throws -> UInt32 {
        guard let decoded = try? unbox(storage.topContainer, as: UInt32.self) else {
            return try smartDecode(type)
        }
        return decoded
    }
    
    public func decode(_ type: UInt64.Type) throws -> UInt64 {
        guard let decoded = try? unbox(storage.topContainer, as: UInt64.self) else {
            return try smartDecode(type)
        }
        return decoded
    }
    
    public func decode(_ type: Float.Type) throws -> Float {
        guard let decoded = try? unbox(storage.topContainer, as: Float.self) else {
            return try smartDecode(type)
        }
        return decoded
    }
    
    public func decode(_ type: Double.Type) throws -> Double {
        guard let decoded = try? unbox(storage.topContainer, as: Double.self) else {
            return try smartDecode(type)
        }
        return decoded
    }
    
    public func decode(_ type: String.Type) throws -> String {
        guard let decoded = try? unbox(storage.topContainer, as: String.self) else {
            return try smartDecode(type)
        }
        return decoded
    }
    
    public func decode<T : Decodable>(_ type: T.Type) throws -> T {
        guard let decoded = try? unbox(storage.topContainer, as: type) else {
            return try smartDecode(type)
        }
        return decoded
    }
}


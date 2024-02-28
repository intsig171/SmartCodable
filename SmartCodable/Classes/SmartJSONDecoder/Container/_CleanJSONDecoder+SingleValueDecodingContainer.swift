// 
//  CleanJSONSingleValueDecodingContainer.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/10/11
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation



extension _CleanJSONDecoder {
    fileprivate func explicitDecode<T: Decodable>(_ type: T.Type) throws -> T {
        let entry = storage.topContainer
        
        if let value = try unbox(entry, as: type) { return value }
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
        return try explicitDecode(type)
    }
    
    public func decode(_ type: Int.Type) throws -> Int {
        return try explicitDecode(type)
    }
    
    public func decode(_ type: Int8.Type) throws -> Int8 {
        return try explicitDecode(type)
    }
    
    public func decode(_ type: Int16.Type) throws -> Int16 {
        return try explicitDecode(type)
    }
    
    public func decode(_ type: Int32.Type) throws -> Int32 {
        return try explicitDecode(type)
    }
    
    public func decode(_ type: Int64.Type) throws -> Int64 {
        return try explicitDecode(type)
    }
    
    public func decode(_ type: UInt.Type) throws -> UInt {
        return try explicitDecode(type)
    }
    
    public func decode(_ type: UInt8.Type) throws -> UInt8 {
        return try explicitDecode(type)
    }
    
    public func decode(_ type: UInt16.Type) throws -> UInt16 {
        return try explicitDecode(type)
    }
    
    public func decode(_ type: UInt32.Type) throws -> UInt32 {
        return try explicitDecode(type)
    }
    
    public func decode(_ type: UInt64.Type) throws -> UInt64 {
        return try explicitDecode(type)
    }
    
    public func decode(_ type: Float.Type) throws -> Float {
        return try explicitDecode(type)
    }
    
    public func decode(_ type: Double.Type) throws -> Double {
        return try explicitDecode(type)
    }
    
    public func decode(_ type: String.Type) throws -> String {
        return try explicitDecode(type)
    }
    
    public func decode<T : Decodable>(_ type: T.Type) throws -> T {
        return try explicitDecode(type)
    }
}

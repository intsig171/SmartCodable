// 
//  _SmartJSONDecoder+SingleValueDecodingContainer.swift
//  SmartCodable
//
//  Created by Mccc on 2024/3/4.
//

import Foundation

extension _SmartJSONDecoder : SingleValueDecodingContainer {
    
    public func decodeNil() -> Bool {
        return self.storage.topContainer is NSNull
    }
    
    public func decode(_ type: Bool.Type) throws -> Bool {
        if let value = try? self.unbox(storage.topContainer, as: Bool.self) {
            return value
        } else {
            return try smartDecode(type: type)
        }
    }
    
    public func decode(_ type: Int.Type) throws -> Int {
        if let value = try? self.unbox(storage.topContainer, as: Int.self) {
            return value
        } else {
            return try smartDecode(type: type)
        }
    }
    
    public func decode(_ type: Int8.Type) throws -> Int8 {
        if let value = try? self.unbox(storage.topContainer, as: Int8.self) {
            return value
        } else {
            return try smartDecode(type: type)
        }
    }
    
    public func decode(_ type: Int16.Type) throws -> Int16 {
        if let value = try? self.unbox(storage.topContainer, as: Int16.self) {
            return value
        } else {
            return try smartDecode(type: type)
        }
    }
    
    public func decode(_ type: Int32.Type) throws -> Int32 {
        if let value = try? self.unbox(storage.topContainer, as: Int32.self) {
            return value
        } else {
            return try smartDecode(type: type)
        }
    }
    
    public func decode(_ type: Int64.Type) throws -> Int64 {
        if let value = try? self.unbox(storage.topContainer, as: Int64.self) {
            return value
        } else {
            return try smartDecode(type: type)
        }
    }
    
    public func decode(_ type: UInt.Type) throws -> UInt {
        if let value = try? self.unbox(storage.topContainer, as: UInt.self) {
            return value
        } else {
            return try smartDecode(type: type)
        }
    }
    
    public func decode(_ type: UInt8.Type) throws -> UInt8 {
        if let value = try? self.unbox(storage.topContainer, as: UInt8.self) {
            return value
        } else {
            return try smartDecode(type: type)
        }
    }
    
    public func decode(_ type: UInt16.Type) throws -> UInt16 {
        if let value = try? self.unbox(storage.topContainer, as: UInt16.self) {
            return value
        } else {
            return try smartDecode(type: type)
        }
    }
    
    public func decode(_ type: UInt32.Type) throws -> UInt32 {
        if let value = try? self.unbox(storage.topContainer, as: UInt32.self) {
            return value
        } else {
            return try smartDecode(type: type)
        }
    }
    
    public func decode(_ type: UInt64.Type) throws -> UInt64 {
        if let value = try? self.unbox(storage.topContainer, as: UInt64.self) {
            return value
        } else {
            return try smartDecode(type: type)
        }
    }
    
    public func decode(_ type: Float.Type) throws -> Float {
        if let value = try? self.unbox(storage.topContainer, as: Float.self) {
            return value
        } else {
            return try smartDecode(type: type)
        }
    }
    
    public func decode(_ type: Double.Type) throws -> Double {
        if let value = try? self.unbox(storage.topContainer, as: Double.self) {
            return value
        } else {
            return try smartDecode(type: type)
        }
    }
    
    public func decode(_ type: String.Type) throws -> String {
        if let value = try? self.unbox(storage.topContainer, as: String.self) {
            return value
        } else {
            return try smartDecode(type: type)
        }
    }
    
    public func decode<T : Decodable>(_ type: T.Type) throws -> T {
        if let value = try? self.unbox(storage.topContainer, as: T.self) {
            return value
        } else {
            return try smartDecode(type: type)
        }
    }
}



extension _SmartJSONDecoder {
    fileprivate func smartDecode<T: Decodable>(type: T.Type) throws -> T {

        if let key = codingPath.last, let value: T = cache.getValue(forKey: key) {
            return value
        } else {
            return try Patcher<T>.defaultForType()
        }
    }
}

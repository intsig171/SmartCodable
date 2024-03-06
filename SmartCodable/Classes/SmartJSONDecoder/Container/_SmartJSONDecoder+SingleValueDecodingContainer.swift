// 
//  _SmartJSONDecoder+SingleValueDecodingContainer.swift
//  SmartCodable
//
//  Created by Mccc on 2024/3/4.
//

import Foundation



extension _SmartJSONDecoder {
    fileprivate func smartDecode<T: Decodable>(_ type: T.Type) throws -> T {
        let entry = storage.topContainer
        return try Patcher<T>.patchWithConvertOrDefault(value: entry)
    }
}

/// 让解析器实现SingleValueDecodingContainer协议
extension _SmartJSONDecoder : SingleValueDecodingContainer {
    // MARK: SingleValueDecodingContainer Methods
    
    // 此时是重写的SingleValueDecodingContainer的协议方法， 代表着此时是单容器就只有一个值。
    
    // 期望是非空值。
    private func expectNonNull<T>(_ type: T.Type) throws {
        guard !self.decodeNil() else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Expected \(type) but found null value instead."))
        }
    }
    
    public func decodeNil() -> Bool {
        return self.storage.topContainer is NSNull
    }
    
    public func decode(_ type: Bool.Type) throws -> Bool {
        // 判断是否为null， 如果是null抛出异常。
        try expectNonNull(Bool.self)
        if let value = try self.unbox(storage.topContainer, as: Bool.self) {
            return value
        } else {
            return try Patcher<Bool>.defaultForType()
        }
    }
    
    public func decode(_ type: Int.Type) throws -> Int {
        try expectNonNull(Int.self)
        if let value = try self.unbox(storage.topContainer, as: Int.self) {
            return value
        } else {
            return try Patcher<Int>.defaultForType()
        }
    }
    
    public func decode(_ type: Int8.Type) throws -> Int8 {
        try expectNonNull(Int8.self)
        if let value = try self.unbox(storage.topContainer, as: Int8.self) {
            return value
        } else {
            return try Patcher<Int8>.defaultForType()
        }
    }
    
    public func decode(_ type: Int16.Type) throws -> Int16 {
        try expectNonNull(Int16.self)
        if let value = try self.unbox(storage.topContainer, as: Int16.self) {
            return value
        } else {
            return try Patcher<Int16>.defaultForType()
        }
    }
    
    public func decode(_ type: Int32.Type) throws -> Int32 {
        try expectNonNull(Int32.self)
        if let value = try self.unbox(storage.topContainer, as: Int32.self) {
            return value
        } else {
            return try Patcher<Int32>.defaultForType()
        }
    }
    
    public func decode(_ type: Int64.Type) throws -> Int64 {
        try expectNonNull(Int64.self)
        if let value = try self.unbox(storage.topContainer, as: Int64.self) {
            return value
        } else {
            return try Patcher<Int64>.defaultForType()
        }
    }
    
    public func decode(_ type: UInt.Type) throws -> UInt {
        try expectNonNull(UInt.self)
        if let value = try self.unbox(storage.topContainer, as: UInt.self) {
            return value
        } else {
            return try Patcher<UInt>.defaultForType()
        }
    }
    
    public func decode(_ type: UInt8.Type) throws -> UInt8 {
        try expectNonNull(UInt8.self)
        if let value = try self.unbox(storage.topContainer, as: UInt8.self) {
            return value
        } else {
            return try Patcher<UInt8>.defaultForType()
        }
    }
    
    public func decode(_ type: UInt16.Type) throws -> UInt16 {
        try expectNonNull(UInt16.self)
        if let value = try self.unbox(storage.topContainer, as: UInt16.self) {
            return value
        } else {
            return try Patcher<UInt16>.defaultForType()
        }
    }
    
    public func decode(_ type: UInt32.Type) throws -> UInt32 {
        try expectNonNull(UInt32.self)
        if let value = try self.unbox(storage.topContainer, as: UInt32.self) {
            return value
        } else {
            return try Patcher<UInt32>.defaultForType()
        }
    }
    
    public func decode(_ type: UInt64.Type) throws -> UInt64 {
        try expectNonNull(UInt64.self)
        if let value = try self.unbox(storage.topContainer, as: UInt64.self) {
            return value
        } else {
            return try Patcher<UInt64>.defaultForType()
        }
    }
    
    public func decode(_ type: Float.Type) throws -> Float {
        try expectNonNull(Float.self)
        if let value = try self.unbox(storage.topContainer, as: Float.self) {
            return value
        } else {
            return try Patcher<Float>.defaultForType()
        }
    }
    
    public func decode(_ type: Double.Type) throws -> Double {
        try expectNonNull(Double.self)
        if let value = try self.unbox(storage.topContainer, as: Double.self) {
            return value
        } else {
            return try Patcher<Double>.defaultForType()
        }
    }
    
    public func decode(_ type: String.Type) throws -> String {
        try expectNonNull(String.self)
        if let value = try self.unbox(storage.topContainer, as: String.self) {
            return value
        } else {
            return try Patcher<String>.defaultForType()
        }
    }
    
    public func decode<T : Decodable>(_ type: T.Type) throws -> T {
        try expectNonNull(T.self)
        if let value = try self.unbox(storage.topContainer, as: T.self) {
            return value
        } else {
            return try Patcher<T>.defaultForType()
        }
    }
}

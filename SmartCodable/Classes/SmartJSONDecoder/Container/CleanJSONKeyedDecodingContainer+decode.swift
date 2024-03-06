//
//  CleanJSONKeyedDecodingContainer+decode.swift
//  SmartCodable
//
//  Created by qixin on 2024/2/28.
//

import Foundation


extension CleanJSONKeyedDecodingContainer {
    
    
    fileprivate func explicitDecode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        
        func defaultValue() throws -> T {
            if let v: T = self.decoder.defalutsStorage.getValue(forKey: key, atPath: codingPath) {
                return v
            } else {
                let v = try Patcher<T>.defaultForType()
                return v
            }
        }
        
        // keyless
        guard let entry = self.container[key.stringValue] else {
            return didFinishMapping(try defaultValue())
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        

        var decoded: T
        if let value = try? self.decoder.unbox(entry, as: type) { // 正常解析
            decoded = value
        } else if let value = Patcher<T>.convertToType(from: entry) { // 类型转换
            decoded = value
        } else { // 使用默认值
            decoded = try defaultValue()
        }
        return didFinishMapping(decoded)
    }
}


extension CleanJSONKeyedDecodingContainer {
    @inline(__always)
    public func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        return try explicitDecode(Bool.self, forKey: key)
    }
    
    @inline(__always)
    public func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        return try explicitDecode(Int.self, forKey: key)
    }
    
    @inline(__always)
    public func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        return try explicitDecode(Int8.self, forKey: key)
    }
    
    @inline(__always)
    public func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        return try explicitDecode(Int16.self, forKey: key)
    }
    
    @inline(__always)
    public func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        return try explicitDecode(Int32.self, forKey: key)
    }
    
    @inline(__always)
    public func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        return try explicitDecode(Int64.self, forKey: key)
    }
    
    @inline(__always)
    public func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        return try explicitDecode(UInt.self, forKey: key)
    }
    
    @inline(__always)
    public func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        return try explicitDecode(UInt8.self, forKey: key)
    }
    
    @inline(__always)
    public func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        return try explicitDecode(UInt16.self, forKey: key)
    }
    
    @inline(__always)
    public func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        return try explicitDecode(UInt32.self, forKey: key)
    }
    
    @inline(__always)
    public func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        return try explicitDecode(UInt64.self, forKey: key)
    }
    
    @inline(__always)
    public func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        return try explicitDecode(Float.self, forKey: key)
    }
    
    @inline(__always)
    public func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        return try explicitDecode(Double.self, forKey: key)
    }
    
    @inline(__always)
    public func decode(_ type: String.Type, forKey key: Key) throws -> String {
        return try explicitDecode(String.self, forKey: key)
    }
    
    @inline(__always)
    public func decode<T : Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        return try explicitDecode(type, forKey: key)
    }
    
}

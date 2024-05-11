//
//  SmartJSONKeyedDecodingContainer.swift
//  SmartCodable
//
//  Created by Mccc on 2024/3/4.
//

import Foundation


// ⚠️ Be aware of the impact of type erasure

extension SmartJSONKeyedDecodingContainer {
    @inlinable
    public func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let entry = getJsonValue(forKey: key) else {
            return try smartDecode(forKey: key)
        }
        
        guard let value = try? self.decoder.unbox(entry, as: Bool.self) else {
            return try smartDecode(forKey: key, entry: entry)
        }
        return value
    }
    @inlinable
    public func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let entry = getJsonValue(forKey: key) else {
            return try smartDecode(forKey: key)
        }
            
        guard let value = try? self.decoder.unbox(entry, as: Int.self) else {
            return try smartDecode(forKey: key, entry: entry)
        }
        return value
    }
    @inlinable
    public func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let entry = getJsonValue(forKey: key) else {
            return try smartDecode(forKey: key)
        }
        
        guard let value = try? self.decoder.unbox(entry, as: Int8.self) else {
            return try smartDecode(forKey: key, entry: entry)
        }
        return value
    }
    @inlinable
    public func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let entry = getJsonValue(forKey: key) else {
            return try smartDecode(forKey: key)
        }
        
        guard let value = try? self.decoder.unbox(entry, as: Int16.self) else {
            return try smartDecode(forKey: key, entry: entry)
        }
        return value
    }
    @inlinable
    public func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let entry = getJsonValue(forKey: key) else {
            return try smartDecode(forKey: key)
        }
        
        guard let value = try? self.decoder.unbox(entry, as: Int32.self) else {
            return try smartDecode(forKey: key, entry: entry)
        }
        return value
    }
    @inlinable
    public func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let entry = getJsonValue(forKey: key) else {
            return try smartDecode(forKey: key)
        }
        
        guard let value = try? self.decoder.unbox(entry, as: Int64.self) else {
            return try smartDecode(forKey: key, entry: entry)
        }
        return value
    }
    @inlinable
    public func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let entry = getJsonValue(forKey: key) else {
            return try smartDecode(forKey: key)
        }
        
        guard let value = try? self.decoder.unbox(entry, as: UInt.self) else {
            return try smartDecode(forKey: key, entry: entry)
        }
        return value
    }
    @inlinable
    public func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let entry = getJsonValue(forKey: key) else {
            return try smartDecode(forKey: key)
        }
        
        guard let value = try? self.decoder.unbox(entry, as: UInt8.self) else {
            return try smartDecode(forKey: key, entry: entry)
        }
        return value
    }
    @inlinable
    public func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let entry = getJsonValue(forKey: key) else {
            return try smartDecode(forKey: key)
        }
        
        guard let value = try? self.decoder.unbox(entry, as: UInt16.self) else {
            return try smartDecode(forKey: key, entry: entry)
        }
        return value
    }
    @inlinable
    public func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let entry = getJsonValue(forKey: key) else {
            return try smartDecode(forKey: key)
        }
        
        guard let value = try? self.decoder.unbox(entry, as: UInt32.self) else {
            return try smartDecode(forKey: key, entry: entry)
        }
        return value
    }
    @inlinable
    public func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let entry = getJsonValue(forKey: key) else {
            return try smartDecode(forKey: key)
        }
        
        guard let value = try? self.decoder.unbox(entry, as: UInt64.self) else {
            return try smartDecode(forKey: key, entry: entry)
        }
        return value
    }
    @inlinable
    public func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let entry = getJsonValue(forKey: key) else {
            return try smartDecode(forKey: key)
        }
        
        guard let value = try? self.decoder.unbox(entry, as: Float.self) else {
            return try smartDecode(forKey: key, entry: entry)
        }
        return value
    }
    @inlinable
    public func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let entry = getJsonValue(forKey: key) else {
            return try smartDecode(forKey: key)
        }
        
        guard let value = try? self.decoder.unbox(entry, as: Double.self) else {
            return try smartDecode(forKey: key, entry: entry)
        }
        return value
    }
    @inlinable
    public func decode(_ type: String.Type, forKey key: Key) throws -> String {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let entry = getJsonValue(forKey: key) else {
            return try smartDecode(forKey: key)
        }
        
        guard let value = try? self.decoder.unbox(entry, as: String.self) else {
            return try smartDecode(forKey: key, entry: entry)
        }
        return value
    }
    @inlinable
    public func decode<T : Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let entry = getJsonValue(forKey: key) else {
            return try smartDecode(forKey: key)
        }
        
        guard let value = try? self.decoder.unbox(entry, as: type) else {
            return try smartDecode(forKey: key, entry: entry)
        }
        return didFinishMapping(value)
    }
}


extension SmartJSONKeyedDecodingContainer {
    
    fileprivate func getJsonValue(forKey key: CodingKey) -> Any? {
        if let entry = self.container[key.stringValue] {
            return entry
        }
        return nil
    }
    
    fileprivate func smartDecode<T: Decodable>(forKey key: Key, entry: Any? = nil) throws -> T {
        
        func logInfo() {
            let className = decoder.cache.topSnapshot?.typeName ?? ""
            let path = decoder.codingPath
            if let entry = entry {
                if entry is NSNull { // 值为null
                    let error = DecodingError.Keyed._valueNotFound(key: key, expectation: T.self, codingPath: path)
                    SmartLog.logDebug(error, className: className)
                } else { // value类型不匹配
                    let error = DecodingError._typeMismatch(at: path, expectation: T.self, reality: entry)
                    SmartLog.logWarning(error: error, className: className)
                }
            } else { // key不存在或value为nil
                let error = DecodingError.Keyed._keyNotFound(key: key, codingPath: path)
                SmartLog.logDebug(error, className: className)
            }
        }
                
        // 如果被忽略了，就不要输出log了。
        let typeString = String(describing: T.self)
        if !typeString.starts(with: "IgnoredKey<") {
            logInfo()
        }
        
        
        var decoded: T
        if let value = Patcher<T>.convertToType(from: entry) { // 类型转换
            decoded = value
        } else if let value: T = decoder.cache.getValue(forKey: key) {
            decoded = value
        } else {
            decoded = try Patcher<T>.defaultForType()
        }
        return didFinishMapping(decoded)
    }
}

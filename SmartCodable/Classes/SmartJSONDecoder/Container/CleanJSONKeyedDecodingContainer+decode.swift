//
//  CleanJSONKeyedDecodingContainer+decode.swift
//  SmartCodable
//
//  Created by qixin on 2024/2/28.
//

import Foundation


extension CleanJSONKeyedDecodingContainer {
    
    /// 当完成decode的时候，接纳didFinishMapping方法内的改变。
    fileprivate func didFinishMapping<T: Decodable>(_ decodeValue: T) -> T {
        if var value = decodeValue as? SmartDecodable {
            value.didFinishMapping()
            if let temp = value as? T {
                return temp
            }
        }

        // 如果使用了SmartOptional修饰，获取被修饰的属性。
//        if var v = PropertyWrapperValue.getSmartObject(decodeValue: decodeValue) {
//            v.didFinishMapping()
//        }

        return decodeValue
    }
    
    
    fileprivate func explicitDecode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        
        
        print(self.container)
        print(key)
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        

        
        if let _ = T.self as? SmartDecodable.Type, let string = entry as? String {
            if let jsonObject = string.toJSONObject() {
                decoder.storage.push(container: jsonObject)
                defer { decoder.storage.popContainer() }
                if let value = try? self.decoder.unbox(jsonObject, as: type) {
                   return value
                }
            }
        } else if let value = try? self.decoder.unbox(entry, as: type) {
            return value
        } else if let value = Patcher<T>.patchWithConvertOrDefault(value: entry) {
            return value
        }
        /// ⚠️： 抛出的异常信息内容是否正确？ Expected \(type) value but found null instead.
        throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Expected \(type) value but found null instead."))
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

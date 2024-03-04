//
//  CleanJSONKeyedDecodingContainer+decodeIfPresent.swift
//  SmartCodable
//
//  Created by qixin on 2024/2/29.
//

import Foundation




/** 说明： 为什么不能用optionalDecode方法实现？
 * 因为：decoder.unbox(entry, as: Bool.self)必须明确制定类型，如果Bool.self, Int.self.
 * 原因：被optionalDecode包裹之后，type类型就回变成decodable（类型擦除）。被擦出之后，调用的都是func unbox<T : Decodable>(_ value: Any, as type: T.Type) 方法，而不是对应的方法。
 */


extension CleanJSONKeyedDecodingContainer {
    
    /// 可选解析不能使用统一方法，如果decoder.unbox不明确指定类型，全都走到func unbox<T : Decodable>(_ value: Any, as type: T.Type) throws -> T? 中， 会走到decoded = try T(from: self)方法，进而初始化一个默认值。
    fileprivate func optionalDecode<T: Decodable>(_ type: T.Type, entry: Any) -> T? {
        if let value = Patcher<T>.convertToType(from: entry) {
            return didFinishMapping(value)
        }
        return nil
    }

    
    @inline(__always)
    func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try? decoder.unbox(entry, as: Bool.self) { return didFinishMapping(value) }
        
        return optionalDecode(type, entry: entry)
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try? decoder.unbox(entry, as: Int.self) { return didFinishMapping(value) }
        
        return optionalDecode(type, entry: entry)
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: Int8.Type, forKey key: K) throws -> Int8? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try? decoder.unbox(entry, as: Int8.self) { return didFinishMapping(value) }
        
        return optionalDecode(type, entry: entry)
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: Int16.Type, forKey key: K) throws -> Int16? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try? decoder.unbox(entry, as: Int16.self) { return didFinishMapping(value) }
        
        return optionalDecode(type, entry: entry)
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: Int32.Type, forKey key: K) throws -> Int32? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try? decoder.unbox(entry, as: Int32.self) { return didFinishMapping(value) }
        
        return optionalDecode(type, entry: entry)
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: Int64.Type, forKey key: K) throws -> Int64? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try? decoder.unbox(entry, as: Int64.self) { return didFinishMapping(value) }
        
        return optionalDecode(type, entry: entry)
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: UInt.Type, forKey key: K) throws -> UInt? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try? decoder.unbox(entry, as: UInt.self) { return didFinishMapping(value) }
        
        return optionalDecode(type, entry: entry)
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: UInt8.Type, forKey key: K) throws -> UInt8? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try? decoder.unbox(entry, as: UInt8.self) { return didFinishMapping(value) }
        
        return optionalDecode(type, entry: entry)
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: UInt16.Type, forKey key: K) throws -> UInt16? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try? decoder.unbox(entry, as: UInt16.self) { return didFinishMapping(value) }
        
        return optionalDecode(type, entry: entry)
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: UInt32.Type, forKey key: K) throws -> UInt32? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try? decoder.unbox(entry, as: UInt32.self) { return didFinishMapping(value) }
        
        return optionalDecode(type, entry: entry)
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: UInt64.Type, forKey key: K) throws -> UInt64? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try? decoder.unbox(entry, as: UInt64.self) { return didFinishMapping(value) }
        
        return optionalDecode(type, entry: entry)
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: Float.Type, forKey key: K) throws -> Float? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try? decoder.unbox(entry, as: Float.self) { return didFinishMapping(value) }
        
        return optionalDecode(type, entry: entry)
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try? decoder.unbox(entry, as: Double.self) { return didFinishMapping(value) }
        
        return optionalDecode(type, entry: entry)
    }
    
    @inline(__always)
    func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try? decoder.unbox(entry, as: String.self) { return didFinishMapping(value) }
        
        return optionalDecode(type, entry: entry)
    }
    
    @inline(__always)
    func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T: Decodable {
        
        guard contains(key), let entry = container[key.stringValue] else { return nil }
        
        /// 如果值为null，直接返回nil
        if try decodeNil(forKey: key) { return nil }
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        if let value = try? decoder.unbox(entry, as: type) {
            return didFinishMapping(value)
        }
        
        return optionalDecode(type, entry: entry)
    }
}

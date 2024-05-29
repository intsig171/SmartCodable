//
//  JSONDecoderImpl+KeyedContainer.swift
//  SmartCodable
//
//  Created by qixin on 2024/5/17.
//

import Foundation
extension JSONDecoderImpl {
    struct KeyedContainer<K: CodingKey>: KeyedDecodingContainerProtocol {
        typealias Key = K
        
        let impl: JSONDecoderImpl
        let codingPath: [CodingKey]
        let dictionary: [String: JSONValue]
        
        init(impl: JSONDecoderImpl, codingPath: [CodingKey], dictionary: [String: JSONValue]) {
            
            self.codingPath = codingPath
            
            self.dictionary = _convertDictionary(dictionary, impl: impl)
            // dictionary的转换，并没有影响结构，只是在当前容器对应的数据新增了字段。并不需要改动impl
            self.impl = impl
        }
        
        var allKeys: [K] {
            self.dictionary.keys.compactMap { K(stringValue: $0) }
        }
        
        func contains(_ key: K) -> Bool {
            if let _ = dictionary[key.stringValue] {
                return true
            }
            return false
        }
        
        func decodeNil(forKey key: K) throws -> Bool {
            let value = try getValue(forKey: key)
            return value == .null
        }
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws
        -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey
        {
            try decoderForKey(key).container(keyedBy: type)
        }
        
        func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
            try decoderForKey(key).unkeyedContainer()
        }
        
        func superDecoder() throws -> Decoder {
            return decoderForKeyNoThrow(_JSONKey.super)
        }
        
        func superDecoder(forKey key: K) throws -> Decoder {
            return decoderForKeyNoThrow(key)
        }
        
        private func decoderForKey<LocalKey: CodingKey>(_ key: LocalKey) throws -> JSONDecoderImpl {
            let value = try getValue(forKey: key)
            var newPath = self.codingPath
            newPath.append(key)
            
            return JSONDecoderImpl(
                userInfo: self.impl.userInfo,
                from: value,
                codingPath: newPath,
                options: self.impl.options
            )
        }
        
        
        private func decoderForKeyCompatibleForJson<LocalKey: CodingKey, T>(_ key: LocalKey, type: T.Type) throws -> JSONDecoderImpl {
            let value = try getValue(forKey: key)
            var newPath = self.codingPath
            newPath.append(key)
            
            var newImpl = JSONDecoderImpl(
                userInfo: self.impl.userInfo,
                from: value,
                codingPath: newPath,
                options: self.impl.options
            )
            
            // 如果新的解析器不是解析Model，就继承上一个的cache。
            if !(type is SmartDecodable.Type) {
                newImpl.cache = impl.cache
            }
            
            return newImpl
        }
        
        
        private func decoderForKeyNoThrow<LocalKey: CodingKey>(_ key: LocalKey) -> JSONDecoderImpl {
            let value: JSONValue
            do {
                value = try getValue(forKey: key)
            } catch {
                // if there no value for this key then return a null value
                value = .null
            }
            var newPath = self.codingPath
            newPath.append(key)
            
            return JSONDecoderImpl(
                userInfo: self.impl.userInfo,
                from: value,
                codingPath: newPath,
                options: self.impl.options
            )
        }
        
        @inline(__always) private func getValue<LocalKey: CodingKey>(forKey key: LocalKey) throws -> JSONValue {
            guard let value = dictionary[key.stringValue] else {
                throw DecodingError.keyNotFound(key, .init(
                    codingPath: self.codingPath,
                    debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."
                ))
            }
            
            return value
        }
        
        @inline(__always) private func createTypeMismatchError(type: Any.Type, forKey key: K, value: JSONValue) -> DecodingError {
            let codingPath = self.codingPath + [key]
            return DecodingError.typeMismatch(type, .init(
                codingPath: codingPath, debugDescription: "Expected to decode \(type) but found \(value.debugDataTypeDescription) instead."
            ))
        }
        
        @inline(__always) private func decodeFixedWidthInteger<T: FixedWidthInteger>(key: Self.Key) -> T? {
            
            guard let value = try? getValue(forKey: key) else { return nil }
            
            if let decoded = impl.cache.tranform(value: value, for: key) as? T {
                return decoded
            }
            
            guard let decoded = try? self.impl.unwrapFixedWidthInteger(from: value, for: key, as: T.self) else {
                return nil
            }
            return decoded
        }
        
        @inline(__always) private func decodeFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>(key: K) -> T? {
            
            guard let value = try? getValue(forKey: key) else { return nil }
            
            if let decoded = impl.cache.tranform(value: value, for: key) as? T {
                return decoded
            }
            guard let decoded = try? self.impl.unwrapFloatingPoint(from: value, for: key, as: T.self) else {
                return nil
            }
            return decoded
        }
    }
}


extension JSONDecoderImpl.KeyedContainer {
    func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
        guard let value = try? getValue(forKey: key) else {
            return try forceDecode(forKey: key)
        }
        
        if let decoded = impl.cache.tranform(value: value, for: key) as? Bool {
            return decoded
        }
        
        guard case .bool(let bool) = value else {
            return try forceDecode(forKey: key)
        }
        return bool
    }
    
    func decode(_ type: String.Type, forKey key: K) throws -> String {
        guard let value = try? getValue(forKey: key) else {
            return try forceDecode(forKey: key)
        }
            
        if let decoded = impl.cache.tranform(value: value, for: key) as? String {
            return decoded
        }
        
        guard case .string(let string) = value else {
            return try forceDecode(forKey: key)
        }
        return string
    }
    
    func decode(_: Double.Type, forKey key: K) throws -> Double {
        if let decoded: Double = decodeFloatingPoint(key: key) {
            return decoded
        }
        return try forceDecode(forKey: key)
    }
    
    func decode(_: CGFloat.Type, forKey key: K) throws -> CGFloat {
        let value = try decode(Double.self, forKey: key)
        return CGFloat(value)
    }
    
    func decode(_: Float.Type, forKey key: K) throws -> Float {
        if let decoded: Float = decodeFloatingPoint(key: key) {
            return decoded
        }
        return try forceDecode(forKey: key)
    }
    
    func decode(_: Int.Type, forKey key: K) throws -> Int {
        if let decoded: Int = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try forceDecode(forKey: key)
    }
    
    func decode(_: Int8.Type, forKey key: K) throws -> Int8 {
        if let decoded: Int8 = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try forceDecode(forKey: key)
    }
    
    func decode(_: Int16.Type, forKey key: K) throws -> Int16 {
        if let decoded: Int16 = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try forceDecode(forKey: key)
    }
    
    func decode(_: Int32.Type, forKey key: K) throws -> Int32 {
        if let decoded: Int32 = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try forceDecode(forKey: key)
    }
    
    func decode(_: Int64.Type, forKey key: K) throws -> Int64 {
        if let decoded: Int64 = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try forceDecode(forKey: key)
    }
    
    func decode(_: UInt.Type, forKey key: K) throws -> UInt {
        if let decoded: UInt = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try forceDecode(forKey: key)
    }
    
    func decode(_: UInt8.Type, forKey key: K) throws -> UInt8 {
        if let decoded: UInt8 = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try forceDecode(forKey: key)
    }
    
    func decode(_: UInt16.Type, forKey key: K) throws -> UInt16 {
        if let decoded: UInt16 = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try forceDecode(forKey: key)
    }
    
    func decode(_: UInt32.Type, forKey key: K) throws -> UInt32 {
        if let decoded: UInt32 = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try forceDecode(forKey: key)
    }
    
    func decode(_: UInt64.Type, forKey key: K) throws -> UInt64 {
        if let decoded: UInt64 = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try forceDecode(forKey: key)
    }
    
    func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T: Decodable {
        
        if type == CGFloat.self {
            return try decode(CGFloat.self, forKey: key) as! T
        }
        
        if let value = try? getValue(forKey: key) {
            if let decoded = impl.cache.tranform(value: value, for: key) as? T {
                return decoded
            }
        }
        
        do {
            let newDecoder = try decoderForKeyCompatibleForJson(key, type: type)
            let decoded = try newDecoder.unwrap(as: type)
            return didFinishMapping(decoded)
        } catch {
            //todo log日志： 异常记录。比如SmartColor类型。
            let decoded: T = try forceDecode(forKey: key)
            return didFinishMapping(decoded)
        }
    }
}


extension JSONDecoderImpl.KeyedContainer {
    
    func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        guard let value = try? getValue(forKey: key) else { return nil }
        
        if let decoded = impl.cache.tranform(value: value, for: key) as? Bool {
            return decoded
        }
        
        guard case .bool(let bool) = value else {
            return optionalDecode(forKey: key)
        }
        return bool
    }
    
    func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        guard let value = try? getValue(forKey: key) else { return nil }
        
        if let decoded = impl.cache.tranform(value: value, for: key) as? String {
            return decoded
        }
        
        guard case .string(let bool) = value else {
            return optionalDecode(forKey: key)
        }
        return bool
    }
    
    func decodeIfPresent(_ type: Float.Type, forKey key: K) throws -> Float? {
        guard let decoded: Float = decodeFloatingPoint(key: key) else {
            return optionalDecode(forKey: key)
        }
        return decoded
    }
    
    func decodeIfPresent(_ type: CGFloat.Type, forKey key: K) throws -> CGFloat? {
        
        guard let decoded: Double = decodeFloatingPoint(key: key) else {
            return optionalDecode(forKey: key)
        }
        return CGFloat(decoded)
    }
    
    func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? {
        guard let decoded: Double = decodeFloatingPoint(key: key) else {
            return optionalDecode(forKey: key)
        }
        return decoded
    }
    
    
    func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        guard let decoded: Int = decodeFixedWidthInteger(key: key) else {
            return optionalDecode(forKey: key)
        }
        return decoded
        
    }
    
    func decodeIfPresent(_ type: Int8.Type, forKey key: K) throws -> Int8? {
        guard let decoded: Int8 = decodeFixedWidthInteger(key: key) else {
            return optionalDecode(forKey: key)
        }
        return decoded
    }
    
    func decodeIfPresent(_ type: Int16.Type, forKey key: K) throws -> Int16? {
        guard let decoded: Int16 = decodeFixedWidthInteger(key: key) else {
            return optionalDecode(forKey: key)
        }
        return decoded
    }
    
    func decodeIfPresent(_ type: Int32.Type, forKey key: K) throws -> Int32? {
        guard let decoded: Int32 = decodeFixedWidthInteger(key: key) else {
            return optionalDecode(forKey: key)
        }
        return decoded
    }
    
    func decodeIfPresent(_ type: Int64.Type, forKey key: K) throws -> Int64? {
        guard let decoded: Int64 = decodeFixedWidthInteger(key: key) else {
            return optionalDecode(forKey: key)
        }
        return decoded
    }
    
    func decodeIfPresent(_ type: UInt.Type, forKey key: K) throws -> UInt? {
        guard let decoded: UInt = decodeFixedWidthInteger(key: key) else {
            return optionalDecode(forKey: key)
        }
        return decoded
    }
    
    func decodeIfPresent(_ type: UInt8.Type, forKey key: K) throws -> UInt8? {
        guard let decoded: UInt8 = decodeFixedWidthInteger(key: key) else {
            return optionalDecode(forKey: key)
        }
        return decoded
    }
    
    func decodeIfPresent(_ type: UInt16.Type, forKey key: K) throws -> UInt16? {
        guard let decoded: UInt16 = decodeFixedWidthInteger(key: key) else {
            return optionalDecode(forKey: key)
        }
        return decoded
    }
    
    func decodeIfPresent(_ type: UInt32.Type, forKey key: K) throws -> UInt32? {
        guard let decoded: UInt32 = decodeFixedWidthInteger(key: key) else {
            return optionalDecode(forKey: key)
        }
        return decoded
    }
    
    func decodeIfPresent(_ type: UInt64.Type, forKey key: K) throws -> UInt64? {
        guard let decoded: UInt64 = decodeFixedWidthInteger(key: key) else {
            return optionalDecode(forKey: key)
        }
        return decoded
    }
    
    func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T: Decodable {
        
        if type == CGFloat.self {
            return try decodeIfPresent(CGFloat.self, forKey: key) as? T
        }
        
        if let value = try? getValue(forKey: key) {
            if let decoded = impl.cache.tranform(value: value, for: key) as? T {
                return decoded
            }
        }
        
        guard let newDecoder = try? decoderForKeyCompatibleForJson(key, type: type) else {
            return nil
        }
        
        if let decoded = try? newDecoder.unwrap(as: type) {
            return didFinishMapping(decoded)
        }

        if let decoded: T = optionalDecode(forKey: key) {
            return didFinishMapping(decoded)
        } else {
            return nil
        }
    }
}


extension JSONDecoderImpl.KeyedContainer {
    
    fileprivate func optionalDecode<T>(forKey key: Key) -> T? {
        
        guard let value = try? getValue(forKey: key) else {
            return nil
        }
        SmartLog.createLog(impl: impl, forKey: key, entry: value.peel, type: T.self)
        guard let decoded = Patcher<T>.convertToType(from: value.peel) else {
            return nil
        }
        return decoded
    }
    
    
    
    fileprivate func forceDecode<T>(forKey key: Key) throws -> T {
        
        func fillDefault() throws -> T {
            if let value: T = impl.cache.getValue(forKey: key) {
                return value
            } else {
                return try Patcher<T>.defaultForType()
            }
        }
        
        guard let value = try? getValue(forKey: key) else {
            SmartLog.createLog(impl: impl, forKey: key, entry: nil, type: T.self)
            return try fillDefault()
        }
        
        SmartLog.createLog(impl: impl, forKey: key, entry: value.peel, type: T.self)
        if let decoded = Patcher<T>.convertToType(from: value.peel) {
            return decoded
        } else {
            return try fillDefault()
        }
    }
    
//    fileprivate func logInfo<T>(
//        isOptionalLog: Bool = false,
//        forKey key: Key, entry: Any?, type: T.Type) {
//        
//        // 如果被忽略了，就不要输出log了。
//        let typeString = String(describing: T.self)
//        guard !typeString.starts(with: "IgnoredKey<") else { return }
//        
//        let className = impl.cache.topSnapshot?.typeName ?? ""
//        var path = impl.codingPath
//        path.append(key)
//        
//        
//        
//        if let entry = entry {
//            if entry is NSNull { // 值为null
//                if isOptionalLog { return }
//                let error = DecodingError.Keyed._valueNotFound(key: key, expectation: T.self, codingPath: path)
//                SmartLog.logDebug(error, className: className)
//            } else { // value类型不匹配
//                let error = DecodingError._typeMismatch(at: path, expectation: T.self, reality: entry)
//                SmartLog.logWarning(error: error, className: className)
//            }
//        } else { // key不存在或value为nil
//            if isOptionalLog { return }
//            let error = DecodingError.Keyed._keyNotFound(key: key, codingPath: path)
//            SmartLog.logDebug(error, className: className)
//        }
//    }
//    
    
    
    fileprivate func didFinishMapping<T>(_ decodeValue: T) -> T {
        if var value = decodeValue as? SmartDecodable {
            value.didFinishMapping()
            if let temp = value as? T { return temp }
        }
        return decodeValue
    }
}
fileprivate func _toData(_ value: Any) -> Data? {
    guard JSONSerialization.isValidJSONObject(value) else { return nil }
    return try? JSONSerialization.data(withJSONObject: value)
}



/// 处理需要解析的字段名的对应关系。
fileprivate func _convertDictionary(_ dictionary: [String: JSONValue], impl: JSONDecoderImpl) -> [String: JSONValue] {
    
    var dictionary = dictionary
    
    // 全局的改动，是否重复了？ 应该只需要在最外层改动一次就够了吧？
    switch impl.options.keyDecodingStrategy {
    case .useDefaultKeys:
        break
    case .fromSnakeCase:
        // Convert the snake case keys in the container to camel case.
        // If we hit a duplicate key after conversion, then we'll use the first one we saw. Effectively an undefined behavior with JSON dictionaries.
        dictionary = Dictionary(dictionary.map {
            dict in (JSONDecoder.SmartKeyDecodingStrategy._convertFromSnakeCase(dict.key), dict.value)
        }, uniquingKeysWith: { (first, _) in first })
    case .firstLetterLower:
        dictionary = Dictionary(dictionary.map {
            dict in (JSONDecoder.SmartKeyDecodingStrategy._convertFirstLetterToLowercase(dict.key), dict.value)
        }, uniquingKeysWith: { (first, _) in first })
    case .firstLetterUpper:
        dictionary = Dictionary(dictionary.map {
            dict in (JSONDecoder.SmartKeyDecodingStrategy._convertFirstLetterToUppercase(dict.key), dict.value)
        }, uniquingKeysWith: { (first, _) in first })
    }
    
    
    guard let type = impl.cache.decodedType else { return dictionary }
    
    
    if let tempValue = KeysMapper.convertFrom(JSONValue.object(dictionary), type: type), let dict = tempValue.object {
        return dict
    }
    return dictionary
}

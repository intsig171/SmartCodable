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
            self.impl = impl
            self.codingPath = codingPath
            
            switch impl.options.keyDecodingStrategy {
            case .useDefaultKeys:
                self.dictionary = dictionary
            case .fromSnakeCase:
                // Convert the snake case keys in the container to camel case.
                // If we hit a duplicate key after conversion, then we'll use the first one we saw. Effectively an undefined behavior with JSON dictionaries.
                self.dictionary = Dictionary(dictionary.map {
                    dict in (JSONDecoder.SmartKeyDecodingStrategy._convertFromSnakeCase(dict.key), dict.value)
                }, uniquingKeysWith: { (first, _) in first })
            case .firstLetterLower:
                self.dictionary = Dictionary(dictionary.map {
                    dict in (JSONDecoder.SmartKeyDecodingStrategy._convertFirstLetterToLowercase(dict.key), dict.value)
                }, uniquingKeysWith: { (first, _) in first })
            }
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

        @inline(__always) private func decodeFixedWidthInteger<T: FixedWidthInteger>(key: Self.Key, value: JSONValue) throws -> T {
            return try self.impl.unwrapFixedWidthInteger(from: value, for: key, as: T.self)
        }

        @inline(__always) private func decodeFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>(key: K, value: JSONValue) throws -> T {
            return try self.impl.unwrapFloatingPoint(from: value, for: key, as: T.self)
        }
    }
}


extension JSONDecoderImpl.KeyedContainer {
    func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
        guard let value = try? getValue(forKey: key) else {
            return try forceDecode(forKey: key)
        }
        guard case .bool(let bool) = value else {
            return try forceDecode(forKey: key, entry: value.peel)
        }
        return bool
    }

    func decode(_ type: String.Type, forKey key: K) throws -> String {
        guard let value = try? getValue(forKey: key) else {
            return try forceDecode(forKey: key)
        }
        guard case .string(let string) = value else {
            return try forceDecode(forKey: key, entry: value.peel)
        }
        return string
    }

    func decode(_: Double.Type, forKey key: K) throws -> Double {
        
        guard let value = try? getValue(forKey: key) else {
            return try forceDecode(forKey: key)
        }
        guard let decoded: Double = try? decodeFloatingPoint(key: key, value: value) else {
            return try forceDecode(forKey: key, entry: value.peel)
        }
        return decoded
    }

    func decode(_: Float.Type, forKey key: K) throws -> Float {
        guard let value = try? getValue(forKey: key) else {
            return try forceDecode(forKey: key)
        }
        guard let decoded: Float = try? decodeFloatingPoint(key: key, value: value) else {
            return try forceDecode(forKey: key, entry: value.peel)
        }
        return decoded
    }

    func decode(_: Int.Type, forKey key: K) throws -> Int {
        
        guard let value = try? getValue(forKey: key) else {
            return try forceDecode(forKey: key)
        }
        guard let decoded: Int = try? decodeFixedWidthInteger(key: key, value: value) else {
            return try forceDecode(forKey: key, entry: value.peel)
        }
        return decoded
    }

    func decode(_: Int8.Type, forKey key: K) throws -> Int8 {
        guard let value = try? getValue(forKey: key) else {
            return try forceDecode(forKey: key)
        }
        guard let decoded: Int8 = try? decodeFixedWidthInteger(key: key, value: value) else {
            return try forceDecode(forKey: key, entry: value.peel)
        }
        return decoded
    }

    func decode(_: Int16.Type, forKey key: K) throws -> Int16 {
        guard let value = try? getValue(forKey: key) else {
            return try forceDecode(forKey: key)
        }
        guard let decoded: Int16 = try? decodeFixedWidthInteger(key: key, value: value) else {
            return try forceDecode(forKey: key, entry: value.peel)
        }
        return decoded
    }

    func decode(_: Int32.Type, forKey key: K) throws -> Int32 {
        guard let value = try? getValue(forKey: key) else {
            return try forceDecode(forKey: key)
        }
        guard let decoded: Int32 = try? decodeFixedWidthInteger(key: key, value: value) else {
            return try forceDecode(forKey: key, entry: value.peel)
        }
        return decoded
    }

    func decode(_: Int64.Type, forKey key: K) throws -> Int64 {
        guard let value = try? getValue(forKey: key) else {
            return try forceDecode(forKey: key)
        }
        guard let decoded: Int64 = try? decodeFixedWidthInteger(key: key, value: value) else {
            return try forceDecode(forKey: key, entry: value.peel)
        }
        return decoded
    }

    func decode(_: UInt.Type, forKey key: K) throws -> UInt {
        guard let value = try? getValue(forKey: key) else {
            return try forceDecode(forKey: key)
        }
        guard let decoded: UInt = try? decodeFixedWidthInteger(key: key, value: value) else {
            return try forceDecode(forKey: key, entry: value.peel)
        }
        return decoded
    }

    func decode(_: UInt8.Type, forKey key: K) throws -> UInt8 {
        guard let value = try? getValue(forKey: key) else {
            return try forceDecode(forKey: key)
        }
        guard let decoded: UInt8 = try? decodeFixedWidthInteger(key: key, value: value) else {
            return try forceDecode(forKey: key, entry: value.peel)
        }
        return decoded
    }

    func decode(_: UInt16.Type, forKey key: K) throws -> UInt16 {
        guard let value = try? getValue(forKey: key) else {
            return try forceDecode(forKey: key)
        }
        guard let decoded: UInt16 = try? decodeFixedWidthInteger(key: key, value: value) else {
            return try forceDecode(forKey: key, entry: value.peel)
        }
        return decoded
    }

    func decode(_: UInt32.Type, forKey key: K) throws -> UInt32 {
        guard let value = try? getValue(forKey: key) else {
            return try forceDecode(forKey: key)
        }
        guard let decoded: UInt32 = try? decodeFixedWidthInteger(key: key, value: value) else {
            return try forceDecode(forKey: key, entry: value.peel)
        }
        return decoded
    }

    func decode(_: UInt64.Type, forKey key: K) throws -> UInt64 {
        guard let value = try? getValue(forKey: key) else {
            return try forceDecode(forKey: key)
        }
        guard let decoded: UInt64 = try? decodeFixedWidthInteger(key: key, value: value) else {
            return try forceDecode(forKey: key, entry: value.peel)
        }
        return decoded
    }

    func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T: Decodable {
        
        guard let value = try? getValue(forKey: key) else {
            return try forceDecode(forKey: key)
        }
        
        do {
            let newDecoder = try decoderForKey(key)
            return try newDecoder.unwrap(as: type)
        } catch {
            return try forceDecode(forKey: key, entry: value.peel)
        }
    }
}


extension JSONDecoderImpl.KeyedContainer {

    func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        guard let value = try? getValue(forKey: key) else { return nil }
        guard case .bool(let bool) = value else {
            return optionalDecode(Bool.self, entry: value.peel)
        }
        return bool
    }
    
    func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        guard let value = try? getValue(forKey: key) else { return nil }
        guard case .string(let bool) = value else {
            return optionalDecode(String.self, entry: value.peel)
        }
        return bool
    }
    
    func decodeIfPresent(_ type: Float.Type, forKey key: K) throws -> Float? {
        guard let value = try? getValue(forKey: key) else { return nil }
        guard let decoded: Float = try? decodeFloatingPoint(key: key, value: value) else {
            return optionalDecode(Float.self, entry: value.peel)
        }
        return decoded
    }
    
    func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? {
        guard let value = try? getValue(forKey: key) else { return nil }
        guard let decoded: Double = try? decodeFloatingPoint(key: key, value: value) else {
            return optionalDecode(Double.self, entry: value.peel)
        }
        return decoded
    }

    
    func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        guard let value = try? getValue(forKey: key) else { return nil }
        guard let decoded: Int = try? decodeFixedWidthInteger(key: key, value: value) else {
            return optionalDecode(Int.self, entry: value.peel)
        }
        return decoded
    }
    
    func decodeIfPresent(_ type: Int8.Type, forKey key: K) throws -> Int8? {
        guard let value = try? getValue(forKey: key) else { return nil }
        guard let decoded: Int8 = try? decodeFixedWidthInteger(key: key, value: value) else {
            return optionalDecode(Int8.self, entry: value.peel)
        }
        return decoded
    }
    
    func decodeIfPresent(_ type: Int16.Type, forKey key: K) throws -> Int16? {
        guard let value = try? getValue(forKey: key) else { return nil }
        guard let decoded: Int16 = try? decodeFixedWidthInteger(key: key, value: value) else {
            return optionalDecode(Int16.self, entry: value.peel)
        }
        return decoded
    }
    
    func decodeIfPresent(_ type: Int32.Type, forKey key: K) throws -> Int32? {
        guard let value = try? getValue(forKey: key) else { return nil }
        guard let decoded: Int32 = try? decodeFixedWidthInteger(key: key, value: value) else {
            return optionalDecode(Int32.self, entry: value.peel)
        }
        return decoded
    }
    
    func decodeIfPresent(_ type: Int64.Type, forKey key: K) throws -> Int64? {
        guard let value = try? getValue(forKey: key) else { return nil }
        guard let decoded: Int64 = try? decodeFixedWidthInteger(key: key, value: value) else {
            return optionalDecode(Int64.self, entry: value.peel)
        }
        return decoded
    }
    
    func decodeIfPresent(_ type: UInt.Type, forKey key: K) throws -> UInt? {
        guard let value = try? getValue(forKey: key) else { return nil }
        guard let decoded: UInt = try? decodeFixedWidthInteger(key: key, value: value) else {
            return optionalDecode(UInt.self, entry: value.peel)
        }
        return decoded
    }
    
    func decodeIfPresent(_ type: UInt8.Type, forKey key: K) throws -> UInt8? {
        guard let value = try? getValue(forKey: key) else { return nil }
        guard let decoded: UInt8 = try? decodeFixedWidthInteger(key: key, value: value) else {
            return optionalDecode(UInt8.self, entry: value.peel)
        }
        return decoded
    }
    
    func decodeIfPresent(_ type: UInt16.Type, forKey key: K) throws -> UInt16? {
        guard let value = try? getValue(forKey: key) else { return nil }
        guard let decoded: UInt16 = try? decodeFixedWidthInteger(key: key, value: value) else {
            return optionalDecode(UInt16.self, entry: value.peel)
        }
        return decoded
    }
    
    func decodeIfPresent(_ type: UInt32.Type, forKey key: K) throws -> UInt32? {
        guard let value = try? getValue(forKey: key) else { return nil }
        guard let decoded: UInt32 = try? decodeFixedWidthInteger(key: key, value: value) else {
            return optionalDecode(UInt32.self, entry: value.peel)
        }
        return decoded
    }
    
    func decodeIfPresent(_ type: UInt64.Type, forKey key: K) throws -> UInt64? {
        guard let value = try? getValue(forKey: key) else { return nil }
        guard let decoded: UInt64 = try? decodeFixedWidthInteger(key: key, value: value) else {
            return optionalDecode(UInt64.self, entry: value.peel)
        }
        return decoded
    }
    
    func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T: Decodable {
        guard let value = try? getValue(forKey: key) else { return nil }
        do {
            let newDecoder = try decoderForKey(key)
            return try newDecoder.unwrap(as: type)
        } catch {
            return optionalDecode(type, entry: value.peel)
        }
    }
}
extension JSONDecoderImpl.KeyedContainer {
    /// 可选解析不能使用统一方法，如果decoder.unbox不明确指定类型，全都走到func unbox<T : Decodable>(_ value: Any, as type: T.Type) throws -> T? 中， 会走到decoded = try T(from: self)方法，进而初始化一个默认值。
    fileprivate func optionalDecode<T: Decodable>(_ type: T.Type, entry: Any?) -> T? {
        if let value = Patcher<T>.convertToType(from: entry) {
            return value
        }
        return nil
    }
    
    fileprivate func forceDecode<T: Decodable>(forKey key: Key, entry: Any? = nil) throws -> T {
        
//        func logInfo() {
//            let className = decoder.cache.topSnapshot?.typeName ?? ""
//            let path = decoder.codingPath
//            if let entry = entry {
//                if entry is NSNull { // 值为null
//                    let error = DecodingError.Keyed._valueNotFound(key: key, expectation: T.self, codingPath: path)
//                    SmartLog.logDebug(error, className: className)
//                } else { // value类型不匹配
//                    let error = DecodingError._typeMismatch(at: path, expectation: T.self, reality: entry)
//                    SmartLog.logWarning(error: error, className: className)
//                }
//            } else { // key不存在或value为nil
//                let error = DecodingError.Keyed._keyNotFound(key: key, codingPath: path)
//                SmartLog.logDebug(error, className: className)
//            }
//        }
                
        // 如果被忽略了，就不要输出log了。
        let typeString = String(describing: T.self)
        if !typeString.starts(with: "IgnoredKey<") {
//            logInfo()
        }
        
        
        var decoded: T
        if let value = Patcher<T>.convertToType(from: entry) { // 类型转换
            decoded = value
        } else if let value: T = impl.cache.getValue(forKey: key) {
            decoded = value
        } else {
            decoded = try Patcher<T>.defaultForType()
        }
        return didFinishMapping(decoded)
    }
    
    fileprivate func didFinishMapping<T: Decodable>(_ decodeValue: T) -> T {
        return DecodingProcessCoordinator.didFinishMapping(decodeValue)
    }
}

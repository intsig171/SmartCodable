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
            case .firstLetterUpper:
                self.dictionary = Dictionary(dictionary.map {
                    dict in (JSONDecoder.SmartKeyDecodingStrategy._convertFirstLetterToUppercase(dict.key), dict.value)
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

        @inline(__always) private func decodeFixedWidthInteger<T: FixedWidthInteger>(key: Self.Key) -> T? {
            
            guard let value = try? getValue(forKey: key) else {
                return optionalDecode(entry: nil)
            }
            
            guard let decoded = try? self.impl.unwrapFixedWidthInteger(from: value, for: key, as: T.self) else {
                return optionalDecode(entry: value.peel)
            }
            return decoded
        }

        @inline(__always) private func decodeFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>(key: K) -> T? {
            
            guard let value = try? getValue(forKey: key) else {
                return optionalDecode(entry: nil)
            }
            
            guard let decoded = try? self.impl.unwrapFloatingPoint(from: value, for: key, as: T.self) else {
                return optionalDecode(entry: value.peel)
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
        if let decoded: Double = decodeFloatingPoint(key: key) {
            return decoded
        }
        return try fillDefault(forKey: key)
    }

    func decode(_: Float.Type, forKey key: K) throws -> Float {
        if let decoded: Float = decodeFloatingPoint(key: key) {
            return decoded
        }
        return try fillDefault(forKey: key)
    }

    func decode(_: Int.Type, forKey key: K) throws -> Int {
        if let decoded: Int = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try fillDefault(forKey: key)
    }

    func decode(_: Int8.Type, forKey key: K) throws -> Int8 {
        if let decoded: Int8 = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try fillDefault(forKey: key)
    }

    func decode(_: Int16.Type, forKey key: K) throws -> Int16 {
        if let decoded: Int16 = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try fillDefault(forKey: key)
    }

    func decode(_: Int32.Type, forKey key: K) throws -> Int32 {
        if let decoded: Int32 = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try fillDefault(forKey: key)
    }

    func decode(_: Int64.Type, forKey key: K) throws -> Int64 {
        if let decoded: Int64 = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try fillDefault(forKey: key)
    }

    func decode(_: UInt.Type, forKey key: K) throws -> UInt {
        if let decoded: UInt = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try fillDefault(forKey: key)
    }

    func decode(_: UInt8.Type, forKey key: K) throws -> UInt8 {
        if let decoded: UInt8 = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try fillDefault(forKey: key)
    }

    func decode(_: UInt16.Type, forKey key: K) throws -> UInt16 {
        if let decoded: UInt16 = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try fillDefault(forKey: key)
    }

    func decode(_: UInt32.Type, forKey key: K) throws -> UInt32 {
        if let decoded: UInt32 = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try fillDefault(forKey: key)
    }

    func decode(_: UInt64.Type, forKey key: K) throws -> UInt64 {
        if let decoded: UInt64 = decodeFixedWidthInteger(key: key) {
            return decoded
        }
        return try fillDefault(forKey: key)
    }

    func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T: Decodable {
        guard let value = try? getValue(forKey: key) else {
            let decoded: T = try forceDecode(forKey: key)
            return didFinishMapping(decoded)
        }
        do {
            let newDecoder = try decoderForKey(key)
            let decoded = try newDecoder.unwrap(as: type)
            return decoded
        } catch {
            let decoded: T = try forceDecode(forKey: key, entry: value.peel)
            return decoded
        }
    }
}


extension JSONDecoderImpl.KeyedContainer {

    func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        guard let value = try? getValue(forKey: key) else { return nil }
        guard case .bool(let bool) = value else {
            return optionalDecode(entry: value.peel)
        }
        return bool
    }
    
    func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        guard let value = try? getValue(forKey: key) else { return nil }
        guard case .string(let bool) = value else {
            return optionalDecode(entry: value.peel)
        }
        return bool
    }
    
    func decodeIfPresent(_ type: Float.Type, forKey key: K) throws -> Float? {
        return decodeFloatingPoint(key: key)
    }
    
    func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? {
        return decodeFloatingPoint(key: key)
    }

    
    func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        return decodeFixedWidthInteger(key: key)
    }
    
    func decodeIfPresent(_ type: Int8.Type, forKey key: K) throws -> Int8? {
        return decodeFixedWidthInteger(key: key)
    }
    
    func decodeIfPresent(_ type: Int16.Type, forKey key: K) throws -> Int16? {
        return decodeFixedWidthInteger(key: key)
    }
    
    func decodeIfPresent(_ type: Int32.Type, forKey key: K) throws -> Int32? {
        return decodeFixedWidthInteger(key: key)
    }
    
    func decodeIfPresent(_ type: Int64.Type, forKey key: K) throws -> Int64? {
        return decodeFixedWidthInteger(key: key)
    }
    
    func decodeIfPresent(_ type: UInt.Type, forKey key: K) throws -> UInt? {
        return decodeFixedWidthInteger(key: key)
    }
    
    func decodeIfPresent(_ type: UInt8.Type, forKey key: K) throws -> UInt8? {
        return decodeFixedWidthInteger(key: key)
    }
    
    func decodeIfPresent(_ type: UInt16.Type, forKey key: K) throws -> UInt16? {
        return decodeFixedWidthInteger(key: key)
    }
    
    func decodeIfPresent(_ type: UInt32.Type, forKey key: K) throws -> UInt32? {
        return decodeFixedWidthInteger(key: key)
    }
    
    func decodeIfPresent(_ type: UInt64.Type, forKey key: K) throws -> UInt64? {
        return decodeFixedWidthInteger(key: key)
    }
    
    func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T: Decodable {
        guard let value = try? getValue(forKey: key) else { return nil }
        do {
            let newDecoder = try decoderForKey(key)
            let decoded = try newDecoder.unwrap(as: type)
            return didFinishMapping(decoded)
        } catch {
            if let decoded: T = optionalDecode(entry: value.peel) {
                return didFinishMapping(decoded)
            }
            return nil
        }
    }
}
extension JSONDecoderImpl.KeyedContainer {
    /// 可选解析不能使用统一方法，如果decoder.unbox不明确指定类型，全都走到func unbox<T : Decodable>(_ value: Any, as type: T.Type) throws -> T? 中， 会走到decoded = try T(from: self)方法，进而初始化一个默认值。
    fileprivate func optionalDecode<T>(entry: Any?) -> T? {
        guard let decoded = Patcher<T>.convertToType(from: entry) else {
            return nil
        }
        
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
        
        return decoded
    }
    
    fileprivate func fillDefault<T>(forKey key: Key) throws -> T {
    
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
        
        if let value: T = impl.cache.getValue(forKey: key) {
            return value
        } else {
            return try Patcher<T>.defaultForType()
        }
    }
    
    fileprivate func forceDecode<T>(forKey key: Key, entry: Any? = nil) throws -> T {

        if let decoded: T = optionalDecode(entry: entry) {
            return decoded
        } else {
            return try fillDefault(forKey: key)
        }
    }
    
    fileprivate func didFinishMapping<T>(_ decodeValue: T) -> T {
        return DecodingProcessCoordinator.didFinishMapping(decodeValue)
    }
}

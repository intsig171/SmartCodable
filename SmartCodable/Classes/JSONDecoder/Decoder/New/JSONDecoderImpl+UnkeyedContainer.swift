//
//  JSONDecoderImpl+UnkeyedContainer.swift
//  SmartCodable
//
//  Created by qixin on 2024/5/17.
//

import Foundation
extension JSONDecoderImpl {
    struct UnkeyedContainer: UnkeyedDecodingContainer {
        let impl: JSONDecoderImpl
        let codingPath: [CodingKey]
        let array: [JSONValue]

        var count: Int? { self.array.count }
        var isAtEnd: Bool { self.currentIndex >= (self.count ?? 0) }
        var currentIndex = 0

        init(impl: JSONDecoderImpl, codingPath: [CodingKey], array: [JSONValue]) {
            self.impl = impl
            self.codingPath = codingPath
            self.array = array
        }

        mutating func decodeNil() throws -> Bool {
            if try self.getNextValue(ofType: Never.self) == .null {
                self.currentIndex += 1
                return true
            }

            // The protocol states:
            //   If the value is not null, does not increment currentIndex.
            return false
        }

        

        mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws
            -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey
        {
            let decoder = decoderForNextElement(ofType: KeyedDecodingContainer<NestedKey>.self)
            let container = try decoder.container(keyedBy: type)

            self.currentIndex += 1
            return container
        }

        mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            let decoder = decoderForNextElement(ofType: UnkeyedDecodingContainer.self)
            let container = try decoder.unkeyedContainer()

            self.currentIndex += 1
            return container
        }

        mutating func superDecoder() throws -> Decoder {
            let decoder = decoderForNextElement(ofType: Decoder.self)
            self.currentIndex += 1
            return decoder
        }

        private mutating func decoderForNextElement<T>(ofType: T.Type) -> JSONDecoderImpl {
            
            var value = JSONValue.array([])
            
            
            do {
                value = try getNextValue(ofType: T.self)
            } catch {
                // 获取不到值
                print(error)
            }
            
            let newPath = self.codingPath + [_JSONKey(index: self.currentIndex)]
            
            return JSONDecoderImpl(
                userInfo: self.impl.userInfo,
                from: value,
                codingPath: newPath,
                options: self.impl.options
            )
        }

        

        
    }
}



extension JSONDecoderImpl.UnkeyedContainer {
    mutating func decode(_ type: Bool.Type) throws -> Bool {
        self.currentIndex += 1
        guard let value = try? self.getNextValue(ofType: Bool.self) else {
            return try fillDefault()
        }
        guard case .bool(let bool) = value else {
            return try forceDecode()
        }
        return bool
    }

    mutating func decode(_ type: String.Type) throws -> String {
        
        self.currentIndex += 1
        guard let value = try? self.getNextValue(ofType: String.self) else {
            return try fillDefault()
        }
        guard case .string(let string) = value else {
            return try forceDecode()
        }
        return string
        
//        throw impl.createTypeMismatchError(type: type, for: _JSONKey(index: currentIndex), value: value)

    }

    mutating func decode(_: Double.Type) throws -> Double {
        if let decoded: Double = decodeFloatingPoint() {
            return decoded
        }
        return try fillDefault()
    }

    mutating func decode(_: Float.Type) throws -> Float {
        if let decoded: Float = decodeFloatingPoint() {
            return decoded
        }
        return try fillDefault()
    }

    mutating func decode(_: Int.Type) throws -> Int {
        if let decoded: Int = decodeFixedWidthInteger() {
            return decoded
        }
        return try fillDefault()
    }

    mutating func decode(_: Int8.Type) throws -> Int8 {
        if let decoded: Int8 = decodeFixedWidthInteger() {
            return decoded
        }
        return try fillDefault()
    }

    mutating func decode(_: Int16.Type) throws -> Int16 {
        if let decoded: Int16 = decodeFixedWidthInteger() {
            return decoded
        }
        return try fillDefault()
    }

    mutating func decode(_: Int32.Type) throws -> Int32 {
        if let decoded: Int32 = decodeFixedWidthInteger() {
            return decoded
        }
        return try fillDefault()
    }

    mutating func decode(_: Int64.Type) throws -> Int64 {
        if let decoded: Int64 = decodeFixedWidthInteger() {
            return decoded
        }
        return try fillDefault()
    }

    mutating func decode(_: UInt.Type) throws -> UInt {
        if let decoded: UInt = decodeFixedWidthInteger() {
            return decoded
        }
        return try fillDefault()
    }

    mutating func decode(_: UInt8.Type) throws -> UInt8 {
        if let decoded: UInt8 = decodeFixedWidthInteger() {
            return decoded
        }
        return try fillDefault()
    }

    mutating func decode(_: UInt16.Type) throws -> UInt16 {
        if let decoded: UInt16 = decodeFixedWidthInteger() {
            return decoded
        }
        return try fillDefault()
    }

    mutating func decode(_: UInt32.Type) throws -> UInt32 {
        if let decoded: UInt32 = decodeFixedWidthInteger() {
            return decoded
        }
        return try fillDefault()
    }

    mutating func decode(_: UInt64.Type) throws -> UInt64 {
        if let decoded: UInt64 = decodeFixedWidthInteger() {
            return decoded
        }
        return try fillDefault()
    }

    mutating func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        let newDecoder = decoderForNextElement(ofType: type)

        // Because of the requirement that the index not be incremented unless
        // decoding the desired result type succeeds, it can not be a tail call.
        // Hopefully the compiler still optimizes well enough that the result
        // doesn't get copied around.
        self.currentIndex += 1
        
        guard let result = try? newDecoder.unwrap(as: type) else {
            let decoded: T = try forceDecode()
            return didFinishMapping(decoded)
        }

        return didFinishMapping(result)
    }
}

extension JSONDecoderImpl.UnkeyedContainer {

    mutating func decodeIfPresent(_ type: Bool.Type) throws -> Bool? {
        self.currentIndex += 1
        guard let value = try? self.getNextValue(ofType: Bool.self) else {
            return nil
        }
        guard case .bool(let bool) = value else {
            return optionalDecode()
        }
        return bool
    }

    
    mutating func decodeIfPresent(_ type: String.Type) throws -> String? {
        self.currentIndex += 1
        guard let value = try? self.getNextValue(ofType: String.self) else {
            return nil
        }
        guard case .string(let string) = value else {
            return optionalDecode()
        }
        return string
    }


    
    mutating func decodeIfPresent(_ type: Double.Type) throws -> Double? {
        return decodeFloatingPoint()
    }


    
    mutating func decodeIfPresent(_ type: Float.Type) throws -> Float? {
        return decodeFloatingPoint()
    }


    
    mutating func decodeIfPresent(_ type: Int.Type) throws -> Int? {
        return decodeFixedWidthInteger()
    }


    
    mutating func decodeIfPresent(_ type: Int8.Type) throws -> Int8? {
        return decodeFixedWidthInteger()
    }


    
    mutating func decodeIfPresent(_ type: Int16.Type) throws -> Int16? {
        return decodeFixedWidthInteger()
    }


    
    mutating func decodeIfPresent(_ type: Int32.Type) throws -> Int32? {
        return decodeFixedWidthInteger()
    }


    
    mutating func decodeIfPresent(_ type: Int64.Type) throws -> Int64? {
        return decodeFixedWidthInteger()
    }


    
    mutating func decodeIfPresent(_ type: UInt.Type) throws -> UInt? {
        return decodeFixedWidthInteger()
    }


    
    mutating func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8? {
        return decodeFixedWidthInteger()
    }


    
    mutating func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16? {
        return decodeFixedWidthInteger()
    }


    
    mutating func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32? {
        return decodeFixedWidthInteger()
    }


    
    mutating func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64? {
        return decodeFixedWidthInteger()
    }


    ///   is not convertible to the requested type.
    mutating func decodeIfPresent<T>(_ type: T.Type) throws -> T? where T : Decodable {
        let newDecoder = decoderForNextElement(ofType: type)

        // Because of the requirement that the index not be incremented unless
        // decoding the desired result type succeeds, it can not be a tail call.
        // Hopefully the compiler still optimizes well enough that the result
        // doesn't get copied around.
        self.currentIndex += 1
        
        guard let result = try? newDecoder.unwrap(as: type) else {
            if let decoded: T = optionalDecode() {
                return didFinishMapping(decoded)
            }
            return nil
        }
        return didFinishMapping(result)
    }


}


extension JSONDecoderImpl.UnkeyedContainer {
    fileprivate func optionalDecode<T>() -> T? {
        let entry = array[currentIndex]
        guard let decoded = Patcher<T>.convertToType(from: entry.peel) else {
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
        
        return didFinishMapping(decoded)
    }
    
    fileprivate func fillDefault<T>() throws -> T {
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
        
        
        
        return try Patcher<T>.defaultForType()
    }
    
    fileprivate func forceDecode<T>() throws -> T {
        if let decoded: T = optionalDecode() {
            return decoded
        } else {
            return try fillDefault()
        }
    }
    
    fileprivate func didFinishMapping<T>(_ decodeValue: T) -> T {
        return DecodingProcessCoordinator.didFinishMapping(decodeValue)
    }
}


extension JSONDecoderImpl.UnkeyedContainer {
    @inline(__always)
    private func getNextValue<T>(ofType: T.Type) throws -> JSONValue {
        guard !self.isAtEnd else {
            var message = "Unkeyed container is at end."
            
            if T.self == JSONDecoderImpl.UnkeyedContainer.self {
                message = "Cannot get nested unkeyed container -- unkeyed container is at end."
            }
            if T.self == Decoder.self {
                message = "Cannot get superDecoder() -- unkeyed container is at end."
            }

            var path = self.codingPath
            path.append(_JSONKey(index: self.currentIndex))

            throw DecodingError.valueNotFound(
                T.self,
                .init(codingPath: path,
                      debugDescription: message,
                      underlyingError: nil))
        }
        return self.array[self.currentIndex]
    }
    
    @inline(__always) private mutating func decodeFixedWidthInteger<T: FixedWidthInteger>() -> T? {
        self.currentIndex += 1
        guard let value = try? self.getNextValue(ofType: T.self) else {
            return optionalDecode()
        }
        let key = _JSONKey(index: self.currentIndex)
        guard let result = try? self.impl.unwrapFixedWidthInteger(from: value, for: key, as: T.self) else {
            return optionalDecode()
        }
        return result
    }

    @inline(__always) private mutating func decodeFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>() -> T? {
        self.currentIndex += 1
        guard let value = try? self.getNextValue(ofType: T.self) else {
            return optionalDecode()
        }
        let key = _JSONKey(index: self.currentIndex)
        guard let result = try? self.impl.unwrapFloatingPoint(from: value, for: key, as: T.self) else {
            return optionalDecode()
        }
        return result
    }
}

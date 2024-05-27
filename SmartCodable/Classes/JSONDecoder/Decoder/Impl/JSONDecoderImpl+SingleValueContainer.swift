//
//  JSONDecoderImpl+SingleValueContainer.swift
//  SmartCodable
//
//  Created by qixin on 2024/5/17.
//

import Foundation

/** 进入Single的场景
 * 1. SmartAny
 * 2.
 */

/** 单容器的解析
 struct Model: SmartCodable {
     var models: [String] = ["one"]
 }
 */


extension JSONDecoderImpl {
    struct SingleValueContainer: SingleValueDecodingContainer {
        let impl: JSONDecoderImpl
        let value: JSONValue
        let codingPath: [CodingKey]

        init(impl: JSONDecoderImpl, codingPath: [CodingKey], json: JSONValue) {
            self.impl = impl
            self.codingPath = codingPath
            self.value = json
        }

        func decodeNil() -> Bool {
            self.value == .null
        }
    }
}

extension JSONDecoderImpl.SingleValueContainer {
    func decode(_: Bool.Type) throws -> Bool {
        guard case .bool(let bool) = self.value else {
            return try smartDecode(type: Bool.self)
        }

        return bool
    }

    func decode(_: String.Type) throws -> String {
        guard case .string(let string) = self.value else {
            return try smartDecode(type: String.self)
        }
        return string
    }

    func decode(_: Double.Type) throws -> Double {
        try decodeFloatingPoint()
    }

    func decode(_: Float.Type) throws -> Float {
        try decodeFloatingPoint()
    }

    func decode(_: Int.Type) throws -> Int {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int8.Type) throws -> Int8 {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int16.Type) throws -> Int16 {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int32.Type) throws -> Int32 {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int64.Type) throws -> Int64 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt.Type) throws -> UInt {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt8.Type) throws -> UInt8 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt16.Type) throws -> UInt16 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt32.Type) throws -> UInt32 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt64.Type) throws -> UInt64 {
        try decodeFixedWidthInteger()
    }

    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        if let decoded: T = try? self.impl.unwrap(as: type) {
            return decoded
        } else {
            return try smartDecode(type: type)
        }
    }
    
    @inline(__always) private func decodeFixedWidthInteger<T: FixedWidthInteger>() throws -> T {
        guard let decoded = try? self.impl.unwrapFixedWidthInteger(from: self.value, as: T.self) else {
            return try smartDecode(type: T.self)
        }
        return decoded
    }

    @inline(__always) private func decodeFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>() throws -> T {
        
        guard let decoded = try? self.impl.unwrapFloatingPoint(from: self.value, as: T.self) else {
            return try smartDecode(type: T.self)
        }
        return decoded
    }
    
    fileprivate func smartDecode<T>(type: T.Type) throws -> T {
        
        // 当容器的值，不适合取初始化值。涉及到[Int]这样的解析。 不好确定key。
        let entry = value.peel
        if let value = Patcher<T>.convertToType(from: entry) { // 类型转换
            return value
        }  else {
            return try Patcher<T>.defaultForType()
        }
    }
}


///decodeIfPresent 为了实现SmartAny 而加的， 不能做兼容处理，否则会影响数据的类型。 非SingleValueDecodingContainer协议方法。
extension JSONDecoderImpl.SingleValueContainer {
    
    func decodeIfPresent(_: SmartAny.Type) -> SmartAny? {
        if let temp = decodeIfPresent(String.self) {
            return .string(temp)
        } else if let temp = decodeIfPresent(Bool.self) as? NSNumber {
            return .number(temp)
        } else if let temp = decodeIfPresent(Double.self) as? NSNumber {
            return .number(temp)
        } else if let temp = decodeIfPresent(Float.self) as? NSNumber {
            return .number(temp)
        } else if let temp = decodeIfPresent(Int.self) as? NSNumber {
            return .number(temp)
        } else if let temp = decodeIfPresent(Int8.self) as? NSNumber {
            return .number(temp)
        } else if let temp = decodeIfPresent(Int16.self) as? NSNumber {
            return .number(temp)
        } else if let temp = decodeIfPresent(Int32.self) as? NSNumber {
            return .number(temp)
        } else if let temp = decodeIfPresent(Int64.self) as? NSNumber {
            return .number(temp)
        } else if let temp = decodeIfPresent(UInt.self) as? NSNumber {
            return .number(temp)
        } else if let temp = decodeIfPresent(UInt8.self) as? NSNumber {
            return .number(temp)
        } else if let temp = decodeIfPresent(UInt16.self) as? NSNumber {
            return .number(temp)
        } else if let temp = decodeIfPresent(UInt32.self) as? NSNumber {
            return .number(temp)
        } else if let temp = decodeIfPresent(UInt64.self) as? NSNumber {
            return .number(temp)
        }

        return nil
    }
    
    
    func decodeIfPresent(_: Bool.Type) -> Bool? {
        guard case .bool(let bool) = self.value else {
            return nil
        }

        return bool
    }

    func decodeIfPresent(_: String.Type) -> String? {
        guard case .string(let string) = self.value else {
            return nil
        }
        return string
    }

    func decodeIfPresent(_: Double.Type) -> Double? {
        decodeIfPresentFloatingPoint()
    }

    func decodeIfPresent(_: Float.Type) -> Float? {
        decodeIfPresentFloatingPoint()
    }

    func decodeIfPresent(_: Int.Type) -> Int? {
        decodeIfPresentFixedWidthInteger()
    }

    func decodeIfPresent(_: Int8.Type) -> Int8? {
        decodeIfPresentFixedWidthInteger()
    }

    func decodeIfPresent(_: Int16.Type) -> Int16? {
        decodeIfPresentFixedWidthInteger()
    }

    func decodeIfPresent(_: Int32.Type) -> Int32? {
        decodeIfPresentFixedWidthInteger()
    }

    func decodeIfPresent(_: Int64.Type) -> Int64? {
        decodeIfPresentFixedWidthInteger()
    }

    func decodeIfPresent(_: UInt.Type) -> UInt? {
        decodeIfPresentFixedWidthInteger()
    }

    func decodeIfPresent(_: UInt8.Type) -> UInt8? {
        decodeIfPresentFixedWidthInteger()
    }

    func decodeIfPresent(_: UInt16.Type) -> UInt16? {
        decodeIfPresentFixedWidthInteger()
    }

    func decodeIfPresent(_: UInt32.Type) -> UInt32? {
        decodeIfPresentFixedWidthInteger()
    }

    func decodeIfPresent(_: UInt64.Type) -> UInt64? {
        decodeIfPresentFixedWidthInteger()
    }
    func decodeIfPresent<T>(_ type: T.Type) -> T? where T: Decodable {
        if let decoded: T = try? self.impl.unwrap(as: type) {
            return decoded
        } else {
            return nil
        }
    }
    
    @inline(__always) private func decodeIfPresentFixedWidthInteger<T: FixedWidthInteger>() -> T? {
        guard let decoded = try? self.impl.unwrapFixedWidthInteger(from: self.value, as: T.self) else {
            return nil
        }
        return decoded
    }

    @inline(__always) private func decodeIfPresentFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>() -> T? {
        
        guard let decoded = try? self.impl.unwrapFloatingPoint(from: self.value, as: T.self) else {
            return nil
        }
        return decoded
    }
}

//
//  ValuePatcher.swift
//  SmartCodable
//
//  Created by Mccc on 2023/8/22.
//

import Foundation



extension Patcher {
    struct Provider {
        static func defaultValue() throws -> T {
            
            
            if let defaultable = T.self as? Defaultable.Type {
                return defaultable.defaultValue as! T
            }
            
            // 处理 SmartDecodable 类型的对象
            if let decodable = T.self as? SmartDecodable.Type {
                return decodable.init() as! T
            }
            
            // 处理 SmartCaseDefaultable 类型的对象
            if let caseDefaultable = T.self as? any SmartCaseDefaultable.Type {
                if let first = caseDefaultable.allCases.first, let firstCase = first as? T {
                    return firstCase
                }
            }
            
            // 处理 SmartAssociatedEnumerable 类型的对象
            if let associatedEnumerable = T.self as? any SmartAssociatedEnumerable.Type {
                return associatedEnumerable.defaultCase as! T
            }
            
            // 如果都没有匹配的类型，抛出错误
            throw DecodingError.valueNotFound(T.self, DecodingError.Context(codingPath: [], debugDescription: "Expected \(T.self) value，but an exception occurred！Please report this issue（请上报该问题）"))
        }
    }
}



protocol Defaultable {
    static var defaultValue: Self { get }
}

extension Date: Defaultable {
    static var defaultValue: Date {
        return Date()
    }
}

extension Data: Defaultable {
    static var defaultValue: Data { Data() }
}

extension Decimal: Defaultable {
    static var defaultValue: Decimal { Decimal(0) }
}

extension Array: Defaultable {
    static var defaultValue: Array<Element> { [] }
}

extension Dictionary: Defaultable {
    static var defaultValue: Dictionary<Key, Value> { return [:] }
}

extension String: Defaultable {
    static var defaultValue: String { "" }
}

extension Bool: Defaultable {
    static var defaultValue: Bool { false }
}


extension Double: Defaultable {
    static var defaultValue: Double { 0.0 }
}

extension Float: Defaultable {
    static var defaultValue: Float { 0.0 }
}

extension CGFloat: Defaultable {
    static var defaultValue: CGFloat { 0.0 }
}

extension Int: Defaultable {
    static var defaultValue: Int { 0 }
}

extension Int8: Defaultable {
    static var defaultValue: Int8 { 0 }
}

extension Int16: Defaultable {
    static var defaultValue: Int16 { 0 }
}

extension Int32: Defaultable {
    static var defaultValue: Int32 { 0 }
}

extension Int64: Defaultable {
    static var defaultValue: Int64 { 0 }
}


extension UInt: Defaultable {
    static var defaultValue: UInt { 0 }
}

extension UInt8: Defaultable {
    static var defaultValue: UInt8 { 0 }
}

extension UInt16: Defaultable {
    static var defaultValue: UInt16 { 0 }
}

extension UInt32: Defaultable {
    static var defaultValue: UInt32 { 0 }
}

extension UInt64: Defaultable {
    static var defaultValue: UInt64 { 0 }
}

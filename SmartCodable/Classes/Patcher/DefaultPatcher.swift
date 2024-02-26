//
//  ValuePatcher.swift
//  SmartCodable
//
//  Created by Mccc on 2023/8/22.
//

import Foundation


/// 默认值兼容器
struct DefaultPatcher<T: Decodable> {
    
    /// 提供默认值
    static func `defalut`() -> T? {
            
        if let value = T.self as? Defaultable.Type {
            return value.defaultValue as? T
        } else if let object = T.self as? SmartDecodable.Type {
            return object.init() as? T
        } else if let object = T.self as? any SmartCaseDefaultable.Type {  // 枚举解析失败，提供对应的默认值。
            return object.defaultCase as? T
        } else {
            SmartLog.logDebug("\(Self.self)提供默认值失败, 发现未知类型，无法提供默认值。如有遇到请反馈，感谢")
            return nil
        }
    }
}

//fileprivate protocol Defaultable {
//    static var defaultValue: Self { get }
//}
//
//
//extension Date: Defaultable {
//    static var defaultValue: Date { Date(timeIntervalSinceReferenceDate: 0) }
//}
//
//extension Data: Defaultable {
//    static var defaultValue: Data { Data() }
//}
//
//extension Decimal: Defaultable {
//    static var defaultValue: Decimal { Decimal(0) }
//}
//
//extension Array: Defaultable {
//    static var defaultValue: Array<Element> { [] }
//}
//
//extension Dictionary: Defaultable {
//    static var defaultValue: Dictionary<Key, Value> {
//        return [:]
//    }
//}
//
//
//extension String: Defaultable {
//    static var defaultValue: String { "" }
//}
//
//extension Bool: Defaultable {
//    static var defaultValue: Bool { false }
//}
//
//
//extension Double: Defaultable {
//    static var defaultValue: Double { 0.0 }
//}
//
//extension Float: Defaultable {
//    static var defaultValue: Float { 0.0 }
//}
//
//extension CGFloat: Defaultable {
//    static var defaultValue: CGFloat { 0.0 }
//}
//
//
//extension Int: Defaultable {
//    static var defaultValue: Int { 0 }
//}
//
//extension Int8: Defaultable {
//    static var defaultValue: Int8 { 0 }
//}
//
//extension Int16: Defaultable {
//    static var defaultValue: Int16 { 0 }
//}
//
//extension Int32: Defaultable {
//    static var defaultValue: Int32 { 0 }
//}
//
//extension Int64: Defaultable {
//    static var defaultValue: Int64 { 0 }
//}
//
//
//
//extension UInt: Defaultable {
//    static var defaultValue: UInt { 0 }
//}
//
//extension UInt8: Defaultable {
//    static var defaultValue: UInt8 { 0 }
//}
//
//extension UInt16: Defaultable {
//    static var defaultValue: UInt16 { 0 }
//}
//
//extension UInt32: Defaultable {
//    static var defaultValue: UInt32 { 0 }
//}
//
//extension UInt64: Defaultable {
//    static var defaultValue: UInt64 { 0 }
//}

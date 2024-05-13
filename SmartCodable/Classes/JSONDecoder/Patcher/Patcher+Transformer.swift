//
//  TypePatcher.swift
//  SmartCodable
//
//  Created by qixin on 2023/9/5.
//

import Foundation




extension Patcher {
    struct Transformer {
        static func typeTransform(from jsonValue: Any?) -> T? {
            guard let value = jsonValue else { return nil }
            return (T.self as? TypeTransformable.Type)?.transformValue(from: value) as? T
        }
    }
}


fileprivate protocol TypeTransformable {
    static func transformValue(from value: Any) -> Self?
}


extension Bool: TypeTransformable {
    static func transformValue(from value: Any) -> Bool? {
        switch value {
        case let temp as Int:
            if temp == 1 { return true}
            else if temp == 0 { return false }
        case let temp as String:
            if ["1","YES","Yes","yes","TRUE","True","true"].contains(temp) { return true }
            if ["0","NO","No","no","FALSE","False","false"].contains(temp) { return false }
        default:
            break
        }
        return nil
    }
}


extension String: TypeTransformable {
    static func transformValue(from value: Any) -> String? {
        // 检查NSNumber实例是否代表Bool类型
        if let number = value as? NSNumber {
            // 检查是否为布尔值，NSNumber表示布尔值时objCType返回的是"c"
            if String(cString: number.objCType) == "c" {
                return nil
            }
        }
        
        switch value {
        case let intValue as Int:
            return String(intValue)
        case let floatValue as Float:
            return String(floatValue)
        case let doubleValue as Double:
            return String(doubleValue)
        default:
            return nil
        }
    }
}


extension Int: TypeTransformable {
    static func transformValue(from value: Any) -> Int? {
        switch value {
        case let temp as String:
            return Int(temp)
        case let temp as Float:
            return Int(temp)
        case let temp as Double:
            return Int(temp)
        case let temp as CGFloat:
            return Int(temp)
        default:
            return nil
        }
    }
}

extension Int8: TypeTransformable {
    static func transformValue(from value: Any) -> Int8? {
        switch value {
        case let temp as String:
            return Int8(temp)
        case let temp as Float:
            return Int8(temp)
        case let temp as Double:
            return Int8(temp)
        case let temp as CGFloat:
            return Int8(temp)
        default:
            return nil
        }
    }
}

extension Int16: TypeTransformable {
    static func transformValue(from value: Any) -> Int16? {
        switch value {
        case let temp as String:
            return Int16(temp)
        case let temp as Float:
            return Int16(temp)
        case let temp as Double:
            return Int16(temp)
        case let temp as CGFloat:
            return Int16(temp)
        default:
            return nil
        }
    }
}


extension Int32: TypeTransformable {
    static func transformValue(from value: Any) -> Int32? {
        switch value {
        case let temp as String:
            return Int32(temp)
        case let temp as Float:
            return Int32(temp)
        case let temp as Double:
            return Int32(temp)
        case let temp as CGFloat:
            return Int32(temp)
        default:
            return nil
        }
    }
}

extension Int64: TypeTransformable {
    static func transformValue(from value: Any) -> Int64? {
        switch value {
        case let temp as String:
            return Int64(temp)
        case let temp as Float:
            return Int64(temp)
        case let temp as Double:
            return Int64(temp)
        case let temp as CGFloat:
            return Int64(temp)
        default:
            return nil
        }
    }
}


extension Float: TypeTransformable {
    static func transformValue(from value: Any) -> Float? {
        if let stringValue = value as? String {
            return Float(stringValue)
        }
        return nil
    }
}


extension Double: TypeTransformable {
    static func transformValue(from value: Any) -> Double? {
        if let temp = value as? String {
            return Double(temp)
        }
        return nil
    }
}


extension CGFloat: TypeTransformable {
    static func transformValue(from value: Any) -> CGFloat? {
        if let temp = value as? String, let doubleValue = Double(temp) {
            return CGFloat(doubleValue)
        }
        return nil
    }
}

/** 注意 inf
 * String类型的 “inf”，可以直接转成Double类型，代表无穷大和无穷小。
 * Swift 能够识别 "inf", "+inf", "-inf", "Infinity", "+Infinity", 和 "-Infinity" 这些表示形式，将它们转换为相应的无穷大或无穷小的 Double 值。
 *
 * 注意 nan
 * String类型的 “nan”，可以直接转成Double类型，代表不是一个数（Not a Number）的特殊值。
 * Swift 能够识别 "NaN", "Nan", "nan" 这些表示形式,并将其转换为表示不是一个数的 Double 值.
 */

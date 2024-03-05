//
//  TypePatcher.swift
//  SmartCodable
//
//  Created by qixin on 2023/9/5.
//

import Foundation




extension Patcher {
    // 负责尝试兼容类型不匹配，只兼容数据有意义的情况（可以合理的进行类型转换的）。
    struct Transformer {
        static func typeTransform(from jsonValue: Any?) -> T? {
            guard let value = jsonValue else { return nil }
            return (T.self as? ValueTransformable.Type)?.transformValue(from: value) as? T
        }
    }
}


protocol ValueTransformable {
    static func transformValue(from value: Any) -> Self?
}


/// 兼容Bool类型的值，Model中定义为Bool类型，但是数据中是String，Int的情况。
extension Bool: ValueTransformable {
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


extension String: ValueTransformable {
    static func transformValue(from value: Any) -> String? {
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


extension Int: ValueTransformable {
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


extension Float: ValueTransformable {
    static func transformValue(from value: Any) -> Float? {
        if let stringValue = value as? String {
            return Float(stringValue)
        }
        return nil
    }
}


extension Double: ValueTransformable {
    static func transformValue(from value: Any) -> Double? {
        if let temp = value as? String {
            return Double(temp)
        }
        return nil
    }
}


extension CGFloat: ValueTransformable {
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

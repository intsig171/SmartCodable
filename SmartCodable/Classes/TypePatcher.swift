//
//  TypePatcher.swift
//  SmartCodable
//
//  Created by qixin on 2023/9/5.
//

import Foundation

/// 类型兼容器，负责尝试兼容类型不匹配，只兼容数据有意义的情况（可以合理的进行类型转换的）。
struct TypeCumulator<T: Decodable> {
    static func compatible(context: DecodingError.Context, originDict: [String: Any]) -> T? {
        if let lastKey = context.codingPath.last?.stringValue {
            if let value = originDict[lastKey] {
                
                switch T.self {
                case is Bool.Type:
                    let smart = compatibleBoolType(value: value)
                    return smart as? T

                case is String.Type:
                    let smart = compatibleStringType(value: value)
                    return smart as? T

                case is Int.Type:
                    let smart = compatibleIntType(value: value)
                    return smart as? T

                case is Float.Type:
                    let smart = compatibleFloatType(value: value)
                    return smart as? T
                    
                case is CGFloat.Type:
                    let smart = compatibleCGFloatType(value: value)
                    return smart as? T

                case is Double.Type:
                    let smart = compatibleDoubleType(value: value)
                    return smart as? T
                default:
                    break
                }
            }
        }
        return nil
    }

    
    /// 兼容Bool类型的值，Model中定义为Bool类型，但是数据中是String，Int的情况。
    static func compatibleBoolType(value: Any) -> Bool? {
        switch value {
        case let intValue as Int:
            if intValue == 1 {
                return true
            } else if intValue == 0 {
                return false
            } else {
                 return nil
            }
        case let stringValue as String:
            switch stringValue {
            case "1", "YES", "Yes", "yes", "TRUE", "True", "true":
                return true
            case "0",  "NO", "No", "no", "FALSE", "False", "false":
                return false
            default:
                return nil
            }
        default:
            return nil
        }
    }
    
    
    /// 兼容String类型的值
    static func compatibleStringType(value: Any) -> String? {
        
        switch value {
        case let intValue as Int:
            let string = String(intValue)
            return string
        case let floatValue as Float:
            let string = String(floatValue)
            return string
        case let doubleValue as Double:
            let string = String(doubleValue)
            return string
        default:
            return nil
        }
    }
    
    /// 兼容Int类型的值
    static func compatibleIntType(value: Any) -> Int? {
        if let v = value as? String, let intValue = Int(v) {
            return intValue
        }
        return nil
    }
    
    /// 兼容 Float 类型的值
    static func compatibleFloatType(value: Any) -> Float? {
        if let v = value as? String {
            return v.toFloat()
        }
        return nil
    }
    
    /// 兼容 double 类型的值
    static func compatibleDoubleType(value: Any) -> Double? {
        if let v = value as? String {
            return v.toDouble()
        }
        return nil
    }
    
    /// 兼容 CGFloat 类型的值
    static func compatibleCGFloatType(value: Any) -> CGFloat? {
        if let v = value as? String {
            return v.toCGFloat()
        }
        return nil
    }
}



extension String {
    fileprivate func toCGFloat() -> CGFloat? {
        switch self {
        case "nan", "NaN", "Nan":
            return nil
        default:
            if let doubleValue = Double(self) {
                return CGFloat(doubleValue)
            }
            return nil
        }
    }
    
    fileprivate func toFloat() -> Float? {
        switch self {
        case "nan", "NaN", "Nan":
            return nil
        default:
            if let value = Float(self) {
                return value
            }
            return nil
        }
    }
    
    fileprivate func toDouble() -> Double? {
        switch self {
        case "nan", "NaN", "Nan":
            return nil
        default:
            if let value = Double(self) {
                return value
            }
            return nil
        }
    }
}

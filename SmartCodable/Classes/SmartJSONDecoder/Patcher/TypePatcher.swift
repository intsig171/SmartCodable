//
//  TypePatcher.swift
//  SmartCodable
//
//  Created by qixin on 2023/9/5.
//

import Foundation

/// 类型兼容器
/// 负责尝试兼容类型不匹配，只兼容数据有意义的情况（可以合理的进行类型转换的）。
struct TypePatcher<T: Decodable> {
    static func tryPatch(_ originValue: Any?) -> T? {
        guard let originValue = originValue else { return nil }
        return (T.self as? TypePatchable.Type)?.tryPatch(from: originValue) as? T
    }
}



protocol TypePatchable {
    static func tryPatch(from value: Any) -> Self?
}


/// 兼容Bool类型的值，Model中定义为Bool类型，但是数据中是String，Int的情况。
extension Bool: TypePatchable {
    static func tryPatch(from value: Any) -> Bool? {
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
            let trueArr = ["1", "YES", "Yes", "yes", "TRUE", "True", "true"]
            if trueArr.contains(stringValue) {
                return true
            }
            
            let falseArr = ["0",  "NO", "No", "no", "FALSE", "False", "false"]
            if falseArr.contains(stringValue) {
                return false
            }
            return nil
        default:
            return nil
        }
    }
}


extension String: TypePatchable {
    static func tryPatch(from value: Any) -> String? {
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

extension Int: TypePatchable {
    static func tryPatch(from value: Any) -> Int? {
        if let v = value as? String, let intValue = Int(v) {
            return intValue
        } else if let floatValue = value as? Float {
            return Int(floatValue)
        } else if let doubleValue = value as? Double {
            return Int(doubleValue)
        } else if let cgFloatValue = value as? CGFloat {
            return Int(cgFloatValue)
        }        
        
        return nil
    }
}

extension Float: TypePatchable {
    static func tryPatch(from value: Any) -> Float? {
        if let v = value as? String {
            return v.toFloat()
        }
        return nil
    }
}


extension Double: TypePatchable {
    static func tryPatch(from value: Any) -> Double? {
        if let v = value as? String {
            return v.toDouble()
        }
        return nil
    }
}

extension CGFloat: TypePatchable {
    static func tryPatch(from value: Any) -> CGFloat? {
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
            return 0
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
            return 0
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
            return 0
        default:
            if let value = Double(self) {
                return value
            }
            return nil
        }
    }
}




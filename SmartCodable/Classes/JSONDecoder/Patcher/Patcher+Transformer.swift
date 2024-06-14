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
        if let number = value as? NSNumber {
            // Check if it's a Boolean, NSNumber is a Boolean and objCType returns "c"
            if String(cString: number.objCType) == "c" {
                return nil
            }
        }
        switch value {
        case let stringValue as String:
            return stringValue
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
        return _fixedWidthInteger(from: value)
    }
}

extension Int8: TypeTransformable {
    static func transformValue(from value: Any) -> Int8? {
        return _fixedWidthInteger(from: value)
    }
}

extension Int16: TypeTransformable {
    static func transformValue(from value: Any) -> Int16? {
        return _fixedWidthInteger(from: value)
    }
}


extension Int32: TypeTransformable {
    static func transformValue(from value: Any) -> Int32? {
        return _fixedWidthInteger(from: value)
    }
}

extension Int64: TypeTransformable {
    static func transformValue(from value: Any) -> Int64? {
        return _fixedWidthInteger(from: value)
    }
}

extension UInt: TypeTransformable {
    static func transformValue(from value: Any) -> UInt? {
        return _fixedWidthInteger(from: value)
    }
}

extension UInt8: TypeTransformable {
    static func transformValue(from value: Any) -> UInt8? {
        return _fixedWidthInteger(from: value)
    }
}

extension UInt16: TypeTransformable {
    static func transformValue(from value: Any) -> UInt16? {
        return _fixedWidthInteger(from: value)
    }
}


extension UInt32: TypeTransformable {
    static func transformValue(from value: Any) -> UInt32? {
        return _fixedWidthInteger(from: value)
    }
}

extension UInt64: TypeTransformable {
    static func transformValue(from value: Any) -> UInt64? {
        return _fixedWidthInteger(from: value)
    }
}




extension Float: TypeTransformable {
    static func transformValue(from value: Any) -> Float? {
        _floatingPoint(from: value)
    }
}


extension Double: TypeTransformable {
    static func transformValue(from value: Any) -> Double? {
        _floatingPoint(from: value)
    }
}


extension CGFloat: TypeTransformable {
    static func transformValue(from value: Any) -> CGFloat? {
        if let temp: Double = _floatingPoint(from: value) {
            return CGFloat(temp)
        }
        return nil
    }
}


private func _floatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>(from value: Any) -> T? {
    
    // In Swift, FixedWidthInteger is a protocol that defines a set of operations and properties that are common to fixed-width integer types.
    // The types that implement this protocol include all the integer types in the standard library,
    // such as Int8, Int16, Int32, Int64 and their unsigned versions UInt8, UInt16, UInt32, UInt64.
    switch value {
    case let temp as String:
        return T(temp)
    case let temp as any FixedWidthInteger:
        return T(temp)
    default:
        return nil
    }
}


private func _fixedWidthInteger<T: FixedWidthInteger>(from value: Any) -> T? {
    switch value {
    case let temp as String:
        return T(temp)
    case let temp as Float:
        return T(temp)
    case let temp as Double:
        return T(temp)
    case let temp as CGFloat:
        return T(temp)
    default:
        return nil
    }
}

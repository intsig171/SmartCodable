//
//  TypePatcher.swift
//  SmartCodable
//
//  Created by qixin on 2023/9/5.
//

import Foundation

extension Patcher {
    struct Transformer {
        static func typeTransform(from jsonValue: JSONValue?, impl: JSONDecoderImpl) -> T? {
            guard let value = jsonValue else { return nil }
            return (T.self as? TypeTransformable.Type)?.transformValue(from: value, impl: impl) as? T
        }
    }
}


fileprivate protocol TypeTransformable {
    static func transformValue(from value: JSONValue, impl: JSONDecoderImpl) -> Self?
}


extension Bool: TypeTransformable {
    static func transformValue(from value: JSONValue, impl: JSONDecoderImpl) -> Bool? {
        
        switch value {
        case .bool(let bool):
            return bool
        case .string(let string):
            if ["1","YES","Yes","yes","TRUE","True","true"].contains(string) { return true }
            if ["0","NO","No","no","FALSE","False","false"].contains(string) { return false }
        case .number(let number):
            if let int = try? impl.unwrapFixedWidthInteger(from: value, as: Int.self) {
                if int == 1 {
                    return true
                } else if int == 0 {
                    return false
                }
            }
        default:
            break
        }
        return nil
    }
}


extension String: TypeTransformable {
    static func transformValue(from value: JSONValue, impl: JSONDecoderImpl) -> String? {
        switch value {
        case .string(let string):
            return string
        case .number(let number):
            if let int = try? impl.unwrapFixedWidthInteger(from: value, as: Int.self) {
                return "\(int)"
            } else if let double = try? impl.unwrapFloatingPoint(from: value, as: Double.self) {
                return "\(double)"
            }
            return number
        default:
            break
        }
        return nil
    }
}


extension Int: TypeTransformable {
    static func transformValue(from value: JSONValue, impl: JSONDecoderImpl) -> Int? {
        return _fixedWidthInteger(from: value)
    }
}

extension Int8: TypeTransformable {
    static func transformValue(from value: JSONValue, impl: JSONDecoderImpl) -> Int8? {
        return _fixedWidthInteger(from: value)
    }
}

extension Int16: TypeTransformable {
    static func transformValue(from value: JSONValue, impl: JSONDecoderImpl) -> Int16? {
        return _fixedWidthInteger(from: value)
    }
}


extension Int32: TypeTransformable {
    static func transformValue(from value: JSONValue, impl: JSONDecoderImpl) -> Int32? {
        return _fixedWidthInteger(from: value)
    }
}

extension Int64: TypeTransformable {
    static func transformValue(from value: JSONValue, impl: JSONDecoderImpl) -> Int64? {
        return _fixedWidthInteger(from: value)
    }
}

extension UInt: TypeTransformable {
    static func transformValue(from value: JSONValue, impl: JSONDecoderImpl) -> UInt? {
        return _fixedWidthInteger(from: value)
    }
}

extension UInt8: TypeTransformable {
    static func transformValue(from value: JSONValue, impl: JSONDecoderImpl) -> UInt8? {
        return _fixedWidthInteger(from: value)
    }
}

extension UInt16: TypeTransformable {
    static func transformValue(from value: JSONValue, impl: JSONDecoderImpl) -> UInt16? {
        return _fixedWidthInteger(from: value)
    }
}


extension UInt32: TypeTransformable {
    static func transformValue(from value: JSONValue, impl: JSONDecoderImpl) -> UInt32? {
        return _fixedWidthInteger(from: value)
    }
}

extension UInt64: TypeTransformable {
    static func transformValue(from value: JSONValue, impl: JSONDecoderImpl) -> UInt64? {
        return _fixedWidthInteger(from: value)
    }
}


extension Float: TypeTransformable {
    static func transformValue(from value: JSONValue, impl: JSONDecoderImpl) -> Float? {
        _floatingPoint(from: value)
    }
}


extension Double: TypeTransformable {
    static func transformValue(from value: JSONValue, impl: JSONDecoderImpl) -> Double? {
        _floatingPoint(from: value)
    }
}


extension CGFloat: TypeTransformable {
    static func transformValue(from value: JSONValue, impl: JSONDecoderImpl) -> CGFloat? {
        if let temp: Double = _floatingPoint(from: value) {
            return CGFloat(temp)
        }
        return nil
    }
}


private func _floatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>(from value: JSONValue) -> T? {
    switch value {
    case .string(let string):
        return T(string)
    case .number(let number):
        return T(number)
    default:
        break
    }
    return nil
}


private func _fixedWidthInteger<T: FixedWidthInteger>(from value: JSONValue) -> T? {
    switch value {
    case .string(let string):
        if let integer = T(string) {
            return integer
        } else if let float = Double(string) {
            return T(float)
        }
    case .number(let number):
        if let integer = T(number) {
            return integer
        } else if let float = Double(number) {
            return T(float)
        }
    default:
        break
    }
    return nil
}

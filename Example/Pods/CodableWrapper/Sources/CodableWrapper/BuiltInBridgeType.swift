//
//  BuiltInBridgeType.swift
//  HandyJSON
//
//  Created by zhouzhuo on 15/07/2017.
//  Copyright © 2017 aliyun. All rights reserved.
//

import Foundation

protocol _BuiltInBridgeType {
    static func _transform(from object: Any) -> Self?
}

// Suppport integer type

protocol IntegerPropertyProtocol: FixedWidthInteger, _BuiltInBridgeType {
    init?(_ text: String, radix: Int)
    init(_ number: NSNumber)
}

extension IntegerPropertyProtocol {
    static func _transform(from object: Any) -> Self? {
        switch object {
        case let str as String:
            return Self(str, radix: 10)
        case let num as NSNumber:
            return Self(num)
        default:
            return nil
        }
    }
}

extension Int: IntegerPropertyProtocol {}
extension UInt: IntegerPropertyProtocol {}
extension Int8: IntegerPropertyProtocol {}
extension Int16: IntegerPropertyProtocol {}
extension Int32: IntegerPropertyProtocol {}
extension Int64: IntegerPropertyProtocol {}
extension UInt8: IntegerPropertyProtocol {}
extension UInt16: IntegerPropertyProtocol {}
extension UInt32: IntegerPropertyProtocol {}
extension UInt64: IntegerPropertyProtocol {}

extension Bool: _BuiltInBridgeType {
    static func _transform(from object: Any) -> Bool? {
        switch object {
        case let str as NSString:
            let lowerCase = str.lowercased
            if ["0", "false"].contains(lowerCase) {
                return false
            }
            if ["1", "true"].contains(lowerCase) {
                return true
            }
            return nil
        case let num as NSNumber:
            return num.boolValue
        default:
            return nil
        }
    }
}

// Support float type

protocol FloatPropertyProtocol: _BuiltInBridgeType, LosslessStringConvertible {
    init(_ number: NSNumber)
}

extension FloatPropertyProtocol {
    static func _transform(from object: Any) -> Self? {
        switch object {
        case let str as String:
            return Self(str)
        case let num as NSNumber:
            return Self(num)
        default:
            return nil
        }
    }
}

extension Float: FloatPropertyProtocol {}
extension Double: FloatPropertyProtocol {}

private let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = false
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 16
    return formatter
}()

extension String: _BuiltInBridgeType {
    static func _transform(from object: Any) -> String? {
        switch object {
        case let str as String:
            return str
        case let num as NSNumber:
            // Boolean Type Inside
            if NSStringFromClass(type(of: num)) == "__NSCFBoolean" {
                if num.boolValue {
                    return "true"
                } else {
                    return "false"
                }
            }
            return formatter.string(from: num)
        case _ as NSNull:
            return nil
        default:
            return "\(object)"
        }
    }
}

extension NSString: _BuiltInBridgeType {
    static func _transform(from object: Any) -> Self? {
        if let str = String._transform(from: object) {
            return Self(string: str)
        }
        return nil
    }
}

extension NSNumber: _BuiltInBridgeType {
    static func _transform(from object: Any) -> Self? {
        switch object {
        case let num as Self:
            return num
        case let str as NSString:
            let lowercase = str.lowercased
            if lowercase == "true" {
                return Self(booleanLiteral: true)
            } else if lowercase == "false" {
                return Self(booleanLiteral: false)
            } else {
                return Self(value: str.doubleValue)
            }
        default:
            return nil
        }
    }
}

extension NSArray: _BuiltInBridgeType {
    static func _transform(from object: Any) -> Self? {
        return object as? Self
    }
}

extension NSDictionary: _BuiltInBridgeType {
    static func _transform(from object: Any) -> Self? {
        return object as? Self
    }
}

extension Optional: _BuiltInBridgeType {
    static func _transform(from object: Any) -> Optional? {
        if let value = (Wrapped.self as? _BuiltInBridgeType.Type)?._transform(from: object) as? Wrapped {
            return Optional(value)
        } else if let value = object as? Wrapped {
            return Optional(value)
        }
        return nil
    }
}

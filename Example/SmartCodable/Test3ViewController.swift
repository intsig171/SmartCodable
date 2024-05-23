//
//  Test3ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/18.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import HandyJSON



class Test3ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let value = "1111"
        let value: UInt64 = 1111
//        let value: Float = 2.3

        
        if let float: Float = _floatingPoint(from: value) {
            print(float)
        }
        
        if let float: Double = _floatingPoint(from: value) {
            print(float)
        }
        
//        if let int: UInt = _unwrapFixedWidthInteger(from: value) {
//            print(int)
//        }
//        
//        if let int8: UInt8 = _unwrapFixedWidthInteger(from: value) {
//            print(int8)
//        }
//        
//        if let int16: UInt16 = _unwrapFixedWidthInteger(from: value) {
//            print(int16)
//        }
//        
//        if let int32: UInt32 = _unwrapFixedWidthInteger(from: value) {
//            print(int32)
//        }
//        
//        if let int64: UInt64 = _unwrapFixedWidthInteger(from: value) {
//            print(int64)
//        }
        
  
//        let dict: [String: Any] = [
//            "int": "11",
//            "int8": "12",
//            "uInt": "13",
//            "uInt8": "14",
//        ]
//
//        
//        if let model = IntModel.deserialize(from: dict) {
//            print(model)
//        }
    }
    
    
    struct IntModel: SmartCodable {
        var int: Int = 0
        var int8: Int8 = 0
        var uInt: UInt = 0
        var uInt8: UInt8 = 0
    }
}

func _unwrapFixedWidthInteger<T: FixedWidthInteger>(from value: Any) -> T? {
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


private func _floatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>(from value: Any) -> T? {
    switch value {
    case let temp as String:
        return T(temp)
    case let temp as any FixedWidthInteger:
        return T(temp)
    default:
        return nil
    }
}

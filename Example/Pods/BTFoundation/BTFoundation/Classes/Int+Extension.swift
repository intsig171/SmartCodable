//
//  Array+Extension.swift
//  BTFoundation
//
//  Created by Mccc on 2020/4/7.
//

import Foundation
import BTNameSpace


/** 待处理
 * 根据情况： 金额的转换，千为单位，万为单位，各种单位。大小写等
 
 */

extension Int : NamespaceWrappable { }


//MARK: 类型转换
extension NamespaceWrapper where T == Int {


    /// Int -> 字符串
    public var stringValue: String {
        return String(wrappedValue)
    }


    /// Int -> Float
    public var folatValue: Float {
        return Float(wrappedValue)
    }

    /// Int -> Double
    public var doubleValue: Double {
        return Double(wrappedValue)
    }
    
    
    /// Int -> NSNumber
    public var numberValue: NSNumber {
        return NSNumber.init(value: wrappedValue)
    }

}

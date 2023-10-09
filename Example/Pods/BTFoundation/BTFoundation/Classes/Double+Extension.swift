//
//  Array+Extension.swift
//  BTFoundation
//
//  Created by Mccc on 2020/4/7.
//

import Foundation
import BTNameSpace

/** 待处理
 * 启信宝下金额的处理
 
 */

extension Double : NamespaceWrappable { }
    

extension NamespaceWrapper where T == Double {

    /// 保留小数到百分位
    public var percentileValue: String {
        return String.init(format: "%.2f", wrappedValue)
    }
}


//MARK: 类型转换
extension NamespaceWrapper where T == Double {


    /// Double -> 字符串
    public var stringValue: String {
        return String(wrappedValue)
    }
    
    

    /// Double -> Float
    public var folatValue: Float {
        return Float(wrappedValue)
    }

    /// Double -> NSNumber
    public var numberValue: NSNumber {
        return NSNumber.init(value: wrappedValue)
    }
}


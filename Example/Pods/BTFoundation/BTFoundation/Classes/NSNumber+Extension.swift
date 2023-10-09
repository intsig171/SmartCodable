//
//  Array+Extension.swift
//  BTFoundation
//
//  Created by Mccc on 2020/4/7.
//

import Foundation
import BTNameSpace


/** 待补充
 
 */


extension NSNumber : NamespaceWrappable { }
extension NamespaceWrapper where T == NSNumber {
    /// 保留小数到百分位
    public var percentileValue: String {
        return String.init(format: "%.2f", wrappedValue.floatValue)
    }
}


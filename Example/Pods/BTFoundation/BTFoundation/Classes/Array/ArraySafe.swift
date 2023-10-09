//
//  ArraySafe+Extension.swift
//  BTFoundation
//
//  Created by Mccc on 2020/4/7.
//

import Foundation


/** 说明
 数组安全的处理
 使用方式
 
 let item = arr[1000~]
 let items = arr[(1...2)~]
 返回时一个可选值
 */


// ~
postfix operator ~

public postfix func ~ (value: Int?) -> BTSafeArray? {
    return BTSafeArray(value: value)
}

public postfix func ~ (value: Range<Int>?) -> BTSafeRange? {
    return BTSafeRange(value: value)
}

public postfix func ~ (value: CountableClosedRange<Int>?) -> BTSafeRange? {
    guard let value = value else {
        return nil
    }
    return BTSafeRange(value: Range<Int>(value))
}

// Struct
public struct BTSafeArray {
    var index: Int
    init?(value: Int?) {
        guard let value = value else {
            return nil
        }
        self.index = value
    }
}

public struct BTSafeRange {
    var range: Range<Int>
    init?(value: Range<Int>?) {
        guard let value = value else {
            return nil
        }
        self.range = value
    }
}

// subscript
public extension Array {
    
    
    /// 单个
    subscript(index: BTSafeArray?) -> Element? {
        get {
            if let index = index?.index {
                return (self.startIndex..<self.endIndex).contains(index) ? self[index] : nil
            }
            return nil
        }
        set {
            if let index = index?.index, let newValue = newValue {
                if (self.startIndex ..< self.endIndex).contains(index) {
                    self[index] = newValue
                }
            }
        }
    }
    
    /// 范围
    subscript(bounds: BTSafeRange?) -> ArraySlice<Element>? {
        get {
            if let range = bounds?.range {
                return self[range.clamped(to: self.startIndex ..< self.endIndex)]
            }
            return nil
        }
        set {
            if let range = bounds?.range, let newValue = newValue {
                self[range.clamped(to: self.startIndex ..< self.endIndex)] = newValue
            }
        }
    }
}

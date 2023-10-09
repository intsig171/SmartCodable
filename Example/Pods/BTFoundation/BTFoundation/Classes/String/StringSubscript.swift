//
//  Array+Extension.swift
//  BTFoundation
//
//  Created by Mccc on 2020/4/7.
//

import Foundation




/** 给String类添加下标扩展
 * sting[1] 获取index为1位的字符串
 * string[1, 2] 获取index为1长度为2的字符串
 */
public extension String {
    
    subscript(start:Int, length:Int) -> String {
        get {
            if start >= self.count { return "" }
            
            if (start + length) > self.count {
                let selfIndex = self.index(self.startIndex, offsetBy: start)
                let str = self.suffix(from: selfIndex)
                return String(str)
            }
            
            let index1 = self.index(self.startIndex, offsetBy: start)
            let index2 = self.index(index1, offsetBy: length)
            let range = Range(uncheckedBounds: (lower: index1, upper: index2))
            return String(self[range])
        }
        set {
            let tmp = self
            var s = ""
            var e = ""
            for (idx, item) in tmp.enumerated() {
                if(idx < start) {
                    s += "\(item)"
                }
                if(idx >= start + length) {
                    e += "\(item)"
                }
            }
            self = s + newValue + e
        }
    }
    
    subscript(index:Int) -> String {
        get {
            if index >= self.count {
                return ""
            }
            return String(self[self.index(self.startIndex, offsetBy: index)])
        }
        set {
            let tmp = self
            self = ""
            for (idx, item) in tmp.enumerated() {
                if idx == index {
                    self += "\(newValue)"
                } else {
                    self += "\(item)"
                }
            }
        }
    }
}

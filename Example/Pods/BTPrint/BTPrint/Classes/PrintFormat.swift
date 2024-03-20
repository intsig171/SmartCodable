//
//  File.swift
//  BTLog
//
//  Created by qixin on 2023/3/16.
//

import Foundation

extension Dictionary {
    
    internal func format() -> String {
     return formatIn()
    }
    
    
    /// 对字典格式化
    /// - Parameter level: 当前字典所在第几层级
    /// - Returns: 格式化的字符串
    fileprivate func formatIn(level: Int = 0) -> String {
        
        // 最终输出的字符串
        var desc: String = ""

        // tab 换行
        var tabSting: String = ""
        for _ in 0..<level {
            tabSting.append("\t")
        }

        var tab = ""
        if level > 0 {
            tab = tabSting
        }

        desc.append("{\n")

        // 对字典排序
        var allKeys = Array(keys)
        allKeys = allKeys.sorted { a, b in
            let tempA = "\(a)"
            let tempB = "\(b)"
            return tempA < tempB
        }

        let tempLevel = level + 1

        for k in allKeys {
            let obj = self[k]
            // AnyHashable
            var key = "\(k)"
            if key.count > 0 {
                key = "\"" + key + "\""
            }
            if let temp = obj as? String {
                let str = "\(tab)\t\(key): \"\(temp)\",\n"
                desc.append(str)
            } else if let temp = obj as? Bool {
                let tem2 = temp ? "true" : "false"
                let str = "\(tab)\t\(key): \(tem2),\n"
                desc.append(str)
            } else if let temp = obj as? [AnyHashable: Any] {
                let tem2 = temp.formatIn(level: tempLevel)
                let str = "\(tab)\t\(key): \(tem2),\n"
                desc.append(str)
            } else if let temp = obj as? [Any] {
                let tem2 = temp.formatIn(level: tempLevel)
                let str = "\(tab)\t\(key): \(tem2),\n"
                desc.append(str)
            }
            else {
                if let temp = obj {
                    let str = "\(tab)\t\(key): \(temp),\n"
                    desc.append(str)
                }
            }
        }
        // 查出最后一个,的范围
        if let range = desc.range(of: ",", options: .backwards) {
            desc.replaceSubrange(range, with: "")
        }
        desc.append("\(tab)}")
        return desc
    }
}




extension Array {
    
    public func format() -> String {
        return formatIn(level: 0)
    }

    /// 对数组格式化
    /// - Parameter level: 当前数组所在第几层级
    /// - Returns: 格式化的字符串
    internal func formatIn(level: Int = 0) -> String {
        // 最终输出的字符串
        var desc: String = ""

        // tab 换行
        var tabSting: String = ""
        for _ in 0..<level {
            tabSting.append("\t")
        }

        var tab = ""
        if level > 0 {
            tab = tabSting
        }

        desc.append("[\n")
        let tempLevel = level + 1
        for obj in self {
            if let temp = obj as? [AnyHashable: Any] {
                let dictStr = temp.formatIn(level: tempLevel)
                let str = "\(tab)\t\(dictStr),\n"
                desc.append(str)
            } else if let temp = obj as? [Any] {
                let arrStr = temp.formatIn(level: tempLevel)
                let str = "\(tab)\t\(arrStr),\n"
                desc.append(str)
            }
            else if let temp = obj as? String {
                let str = "\(tab)\t\"\(temp)\",\n"
                desc.append(str)
            } else if let temp = obj as? Bool {
                let tem2 = temp ? "true" : "false"
                let str = "\(tab)\t\(tem2),\n"
                desc.append(str)
            } else {
                let str = "\(tab)\t\(obj),\n"
                desc.append(str)
            }
        }
        // 查出最后一个,的范围
        if let range = desc.range(of: ",", options: .backwards) {
            desc.replaceSubrange(range, with: "")
        }
        desc.append("\(tab)]")
        return desc
    }
}

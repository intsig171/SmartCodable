//
//  UIPasteboard+Extension.swift
//  BTFoundation
//
//  Created by 满聪 on 2020/6/19.
//

import Foundation

import BTNameSpace

extension UIPasteboard: NamespaceWrappable { }


extension NamespaceWrapper where T == UIPasteboard {
    
    
    /// 复制（在整个设备范围内使用）
    /// - Parameter string: 要复制的内容
    public static func copyInEquipment(with string: String) {
        /// 删除空格
        var tempStr = string
        tempStr = tempStr.trimmingCharacters(in: .whitespaces)
        let pasteboard = UIPasteboard.general
        pasteboard.string = tempStr
    }
    
    
    /// 粘贴（获取整个设备内的复制内容，粘贴）
    public static func pasteInEquipment() -> String? {
        let pasteboard = UIPasteboard.general
        return pasteboard.string
    }
}

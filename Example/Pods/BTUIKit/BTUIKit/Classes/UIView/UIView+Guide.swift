//
//  UIView+Guide.swift
//  BTUIKit
//
//  Created by Mccc on 2021/6/1.
//

import Foundation
import BTNameSpace


extension NamespaceWrapper where T == UIView {

    /// 分割线
    /// - Parameter hex: 色值
    /// - Returns: UIView
    public static func dividerLine(_ hex: String = "E9E9E9") -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.bt.hex(hex)
        return view
    }
}

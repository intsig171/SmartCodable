//
//  UIViewControllerJumpHelper.swift
//  BTFoundation
//
//  Created by qxb171 on 2020/11/17.
//

import Foundation




@objc public class UIViewControllerJumpHelper: NSObject {
    @objc public static let shared = UIViewControllerJumpHelper()

    
    /// tabbarController的根控制器，用来控制tabbar的显示隐藏
    @objc public var vcs: [UIViewController] = []
}

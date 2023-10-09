//
//  CAGradientLayer+UINavigationBar.swift
//  BTFoundation
//
//  Created by 满聪 on 2020/8/24.
//

import Foundation
import BTNameSpace


extension NamespaceWrapper where T == UINavigationBar {

    
    /// 创建渐变的导航栏背景
    /// - Parameters:
    ///   - colors: 颜色集合
    ///   - locations: 位置集合
    ///   - direction: 方向，默认为水平渐变
    ///   - type: 渐变类型
    public func makeGradientBackground(
        colors: [UIColor],
        locations: [NSNumber]? = nil,
        direction: CAGradientLayer.BTWrapperType.BTGradientDirection = .horizontal,
        type: CAGradientLayer.BTWrapperType.BTGradientType = .axial) {

        var updatedFrame = wrappedValue.bounds
        updatedFrame.size.height += wrappedValue.frame.origin.y
        let gradientLayer = CAGradientLayer.bt.make(colors: colors, frame: updatedFrame, direction: direction, type: type)
        
        wrappedValue.setBackgroundImage(gradientLayer.bt.makeImage(), for: UIBarMetrics.default)
    }
}



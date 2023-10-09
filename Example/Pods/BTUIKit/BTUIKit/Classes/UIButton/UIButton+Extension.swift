//
//  UIButton+Extension.swift
//  BTFoundation
//
//  Created by qxb171 on 2020/9/1.
//

import Foundation
import BTNameSpace

extension NamespaceWrapper where T: UIButton {

    /// 图片相对于文字的位置
    public enum BTButtonImagePosition {
        /// 图片在上，文字在下，垂直居中对齐
        case top
        /// 图片在下，文字在上，垂直居中对齐
        case bottom
        /// 图片在左，文字在右，水平居中对齐
        case left
        /// 图片在右，文字在左，水平居中对齐
        case right
    }
}

extension NamespaceWrapper where T: UIButton {

    /// 设置button中 图片和文字的位置 （图片相对于文字的位置）
    /// - Parameters:
    ///   - style: 图片的位置类型
    ///   - spacing: 图片和文字之间的间距
    public func imagePosition(_ style: BTButtonImagePosition, spacing: CGFloat) {
        //得到imageView和titleLabel的宽高
        
        let title = wrappedValue.titleLabel?.text
        if title == nil {
            return
        }
        
        let image = wrappedValue.imageView?.image
        if image == nil {
            return
        }
        
        let imageWidth = wrappedValue.imageView?.frame.size.width ?? 0
        let imageHeight = wrappedValue.imageView?.frame.size.height ?? 0
        var labelWidth = wrappedValue.titleLabel?.intrinsicContentSize.width ?? 0
        let labelHeight = wrappedValue.titleLabel?.intrinsicContentSize.height ?? 0
        //初始化imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        //根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .top:
            //上 左 下 右
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-spacing, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight-spacing, right: 0)
            break;
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing/2)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
            break;
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight-spacing, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight-spacing, left: -imageWidth, bottom: 0, right: 0)
            break;
        case .right:
            labelWidth = wrappedValue.titleLabel?.bounds.width ?? 0
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+spacing/2, bottom: 0, right: -labelWidth-spacing/2)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth-spacing/2, bottom: 0, right: imageWidth+spacing/2)
            break;
        }
        wrappedValue.titleEdgeInsets = labelEdgeInsets
        wrappedValue.imageEdgeInsets = imageEdgeInsets
    }
}

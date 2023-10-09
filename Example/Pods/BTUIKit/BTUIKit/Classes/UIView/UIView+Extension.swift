//
//  UIView+Extension.swift
//  BTNameSpace
//
//  Created by Mccc on 2020/4/15.
//

import UIKit
import BTNameSpace

extension UIView: NamespaceWrappable { }
extension NamespaceWrapper where T: UIView {

    /// 将一个UIView视图转为图片
    /// - Parameter opaque: 是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES
    public func makeImage(_ opaque: Bool = true) -> UIImage? {
        let size = wrappedValue.bounds.size
        
        /**
         * 第一个参数表示区域大小。
         第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。
         第三个参数就是屏幕密度了
         */
        UIGraphicsBeginImageContextWithOptions(size, opaque, UIScreen.main.scale)
        if let content = UIGraphicsGetCurrentContext() {
            wrappedValue.layer.render(in: content)
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return image
            }
        }
        return nil
    }
}



extension NamespaceWrapper where T: UIView {
    
    ///获取当前视图相对 屏幕的frame
    /// - Returns: 相对屏幕的rect
    public func convertFrameToScreen() -> CGRect {
        
        if let keyWindow = UIApplication.shared.keyWindow, let newBounds = wrappedValue.superview?.convert(wrappedValue.frame, to: keyWindow) {
            return newBounds
        }
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        var view: UIView = wrappedValue
        
        while ((view.superview as? UIWindow) == nil) {
            x += view.frame.origin.x
            y += view.frame.origin.y
            
            
            guard let father = view.superview else {
                break
            }
            
            view = father
            
            if view.isKind(of: UIScrollView.self) {
                x -= (view as! UIScrollView).contentOffset.x
                y -= (view as! UIScrollView).contentOffset.y
            }
        }
        
        return CGRect(x: x, y: y, width: wrappedValue.frame.size.width, height: wrappedValue.frame.size.height)
    }
}



extension NamespaceWrapper where T: UIView {

    
    /// （贝塞尔）裁切任意角为圆角
    ///   - roundedRect: 范围，如果传值就用此frame，否则用self.bound
    /// - Parameters:
    ///   - corner: 要裁切角的位置
    ///   - radii: 半径
    public func addCorners(in roundedRect: CGRect = .zero, corner: UIRectCorner, radii: CGFloat) {
        
        /** 使用示例
         imageView.bt.addCorners([.bottomRight, bottomLeft], radii: 5)
         */
        
        var rect = roundedRect
        if rect == .zero {
            rect = wrappedValue.bounds
        }
        
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize.init(width: radii, height: radii))
        let layer = CAShapeLayer()
        layer.frame = rect
        layer.path = maskPath.cgPath
        wrappedValue.layer.mask = layer
    }
    
    
    
    /// （贝塞尔）添加描边
    /// - Parameters:
    ///   - roundedRect: 范围，如果传值就用此frame，否则用self.bound
    ///   - borderColor: 描边线条颜色
    ///   - lineWidth: 线条宽度
    ///   - fillColor: 填充色 
    public func addBorder(in roundedRect: CGRect = .zero,
                          borderColor: UIColor,
                          lineWidth: CGFloat,
                          fillColor: UIColor? = nil) {
        var rect = roundedRect
        if rect == .zero {
            rect = wrappedValue.bounds
        }
        let linePath = UIBezierPath.init(rect: rect)
        let layer = CAShapeLayer()
        layer.frame = rect
        layer.path = linePath.cgPath
        layer.lineWidth = lineWidth
        layer.strokeColor = borderColor.cgColor
        layer.fillColor = fillColor?.cgColor
        wrappedValue.layer.addSublayer(layer)
    }
    
    
    /// （贝塞尔）添加圆角和描边
    /// - Parameters:
    ///   - roundedRect: 范围，如果传值就用此frame，否则用self.bound
    ///   - corner: 圆角位置
    ///   - radii: 半径
    ///   - borderColor: 描边颜色 默认#E9E9E9
    ///   - lineWidth: 描边宽度 默认0.5
    ///   - fillColor: 填充色
    public func addCornersAndBorder(in roundedRect: CGRect = .zero,
                                    corner: UIRectCorner = .allCorners,
                                    radii: CGFloat,
                                    borderColor: UIColor = UIColor.bt.uE9E9E9,
                                    lineWidth: CGFloat = 0.5,
                                    fillColor: UIColor? = nil) {
        var rect = roundedRect
        if rect == .zero {
            rect = wrappedValue.bounds
        }
        let maskPath = UIBezierPath.init(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize.init(width: radii, height: radii))

        let layer = CAShapeLayer.init()
        layer.frame = rect
        layer.path = maskPath.cgPath
        layer.strokeColor = borderColor.cgColor
        layer.fillColor = fillColor?.cgColor
        layer.lineWidth = lineWidth
        wrappedValue.layer.addSublayer(layer)
    }



    /// 添加阴影
    /// - Parameters:
    ///   - shadowOpacity: 阴影透明度 （0~1）
    ///   - shadowColor: 阴影颜色
    ///   - shadowOffset: 阴影偏移量 width: 横向偏移量，正右负左  height:纵向偏移量，正下负上
    ///   - shadowRadius: 阴影半径
    public func addShadow(shadowOpacity: CGFloat,
                          shadowColor: UIColor,
                          shadowOffset: CGSize,
                          shadowRadius: CGFloat) {
        let subLayer = CALayer()
        subLayer.backgroundColor = wrappedValue.backgroundColor?.cgColor
        subLayer.frame = wrappedValue.frame
        subLayer.shadowColor = shadowColor.cgColor
        subLayer.shadowOffset = shadowOffset
        subLayer.shadowOpacity = Float(shadowOpacity)
        subLayer.shadowRadius = shadowRadius;
        wrappedValue.superview?.layer.insertSublayer(subLayer, below: wrappedValue.layer)
    }


    
    /// （贝塞尔）添加圆角和描边
    /// - Parameters:
    ///   - roundedRect: 范围，如果传值就用此frame，否则用self.bound
    ///   - corner: 圆角位置
    ///   - radii: 半径
    ///   - shadowOpacity: 阴影透明度 （0~1）
    ///   - shadowColor: 阴影颜色
    ///   - shadowOffset: 阴影偏移量 width: 横向偏移量，正右负左  height:纵向偏移量，正下负上
    ///   - shadowRadius: 阴影半径
    public func addCornersAndShadow(corner: UIRectCorner,
                                    radii: CGFloat,
                                    shadowOpacity: CGFloat,
                                    shadowColor: UIColor,
                                    shadowOffset: CGSize,
                                    shadowRadius: CGFloat) {
        let rect = wrappedValue.bounds
        let maskPath = UIBezierPath.init(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize.init(width: radii, height: radii))
        
        let layer = CAShapeLayer()
        layer.frame = rect
        layer.path = maskPath.cgPath
        wrappedValue.layer.mask = layer
        
        let subLayer = CALayer()
        subLayer.backgroundColor = wrappedValue.backgroundColor?.cgColor
        subLayer.frame = wrappedValue.frame
        subLayer.cornerRadius = radii
        subLayer.masksToBounds = false
        subLayer.shadowColor = shadowColor.cgColor
        subLayer.shadowOffset = shadowOffset
        subLayer.shadowOpacity = Float(shadowOpacity)
        subLayer.shadowRadius = shadowRadius;
        wrappedValue.superview?.layer.insertSublayer(subLayer, below: wrappedValue.layer)
    }
}



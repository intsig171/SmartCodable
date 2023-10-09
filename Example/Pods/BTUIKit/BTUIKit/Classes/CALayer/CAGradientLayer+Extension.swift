//
//  CAGradientLayer+Extension.swift
//  BTNameSpace
//
//  Created by Mccc on 2020/4/15.
//

import UIKit
import BTNameSpace


/// 渐变色
extension CAGradientLayer: NamespaceWrappable { }
extension NamespaceWrapper where T == CAGradientLayer {

    /// 渐变方向
    public enum BTGradientDirection {
        /// 水平渐变
        case horizontal
        /// 纵向渐变
        case vertical
        /// 斜向上渐变
        case obliqueUpward
        /// 斜向下渐变
        case obliqueDown
    }
    
    /// 渐变样式
    public enum BTGradientType: String {
        
        /// 轴向渐变样式（默认）：表示按像素均匀变化
        case axial
        /// 径向渐变样式
        case radial
        /// 二次曲线渐变样式
        case conic
    }

}


extension NamespaceWrapper where T == CAGradientLayer {

    /// 创建渐变色图层
    /// - Parameters:
    ///   - colors: 颜色数组【UIColor】类型，定义渐变层的各个颜色
    ///   - frame: 图层的frame，一定要添加之前测试
    ///   - direction: 渐变方向
    ///   - locations: 决定每个渐变颜色的终止位置，这些值必须是递增的。区间在[0-1]之间.
    ///   比如三种颜色的集合[A,B,C],设置的区间为[0, 0.2, 1] 那么A和B均分前0~0.2区间的位置颜色，B和C均分[0.2~1]区间的位置颜色
    ///   - type: 渐变类型 默认值是axial，表示按像素均匀变化
    public static func make(
        colors: [UIColor],
        locations: [NSNumber]? = nil,
        frame: CGRect = .zero,
        direction: BTGradientDirection = .horizontal,
        type: BTGradientType = .axial) -> CAGradientLayer {
        
        let layer = CAGradientLayer()
        layer.frame = frame

        
        let cgColors = colors.map { $0.cgColor }

        // 确保 locations 的数量跟 colors一致
        var isNeedCustomLocations: Bool = false
        if let locations = locations {
            if locations.count != colors.count {
                isNeedCustomLocations = true
            }
        } else {
            isNeedCustomLocations = true
        }
        var gradientLocations = locations
        if isNeedCustomLocations {
            var arrayM: [NSNumber] = []
            
            let temp: Double = Double((cgColors.count - 1))
            let spacing = 1 / temp

            for i in 0..<cgColors.count {
                let tempI: Double = Double(i)
                let location = tempI * spacing
                arrayM.append(NSNumber(value: location))
            }
            gradientLocations = arrayM
        }

        
        //创建CAGradientLayer对象并设置参数
        layer.colors = cgColors
        layer.locations = gradientLocations
        layer.type = CAGradientLayerType.init(rawValue: type.rawValue)
        
    
        
        /** 设置渲染的起始结束位置
         * startPoint -> 渲染的起始位置，默认值是：[.5,0]
         * endPoint -> 渲染的终止位置，默认值是：[.5,1]
         * 由这两个点的连线，来决定渐变方向。
         */
        switch direction {
        case .horizontal:
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 1, y: 0)
        case .vertical:
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 0, y: 1)
        case .obliqueDown:
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 1, y: 1)
        case .obliqueUpward:
            layer.startPoint = CGPoint(x: 0, y: 1)
            layer.endPoint = CGPoint(x: 1, y: 0)
        }
        return layer
    }
}




extension NamespaceWrapper where T == CAGradientLayer {

    /// 创建主色渐变色图层
    /// - Parameters:
    ///   - frame: 图层的frame
    ///   - direction: 渐变方向
    ///   - locations: 决定每个渐变颜色的终止位置，这些值必须是递增的
    public static func makeMain(
           frame: CGRect = .zero,
           locations: [NSNumber]? = nil,
           direction: BTGradientDirection = .horizontal,
           type: BTGradientType = .axial) -> CAGradientLayer {
        
        let colors = [UIColor.bt.hex("33B2FF"), UIColor.bt.hex("467FD7")]
        let layer = CAGradientLayer.bt.make(colors: colors, locations: locations, frame: frame, direction: direction, type: type)
        return layer
    }
    
    
    /// 创建辅助色渐变色图层
    /// - Parameters:
    ///   - frame: 图层的frame
    ///   - direction: 渐变方向
    ///   - locations: 决定每个渐变颜色的终止位置，这些值必须是递增的
    public static func makeAssist(
           frame: CGRect = .zero,
           locations: [NSNumber]? = nil,
           direction: BTGradientDirection = .horizontal,
           type: BTGradientType = .axial) -> CAGradientLayer {
        
        let colors = [UIColor.bt.hex("FFE600"), UIColor.bt.hex("FFB400")]
        let layer = CAGradientLayer.bt.make(colors: colors, locations: locations, frame: frame, direction: direction, type: type)
        return layer
    }
    
    
    /// 创建警告色渐变色图层
    /// - Parameters:
    ///   - frame: 图层的frame
    ///   - direction: 渐变方向
    ///   - locations: 决定每个渐变颜色的终止位置，这些值必须是递增的
    public static func makeWarning(
           frame: CGRect = .zero,
           locations: [NSNumber]? = nil,
           direction: BTGradientDirection = .horizontal,
           type: BTGradientType = .axial) -> CAGradientLayer {
        
        let colors = [UIColor.bt.hex("FF8C1C"), UIColor.bt.hex("F5573E")]
        let layer = CAGradientLayer.bt.make(colors: colors, locations: locations, frame: frame, direction: direction, type: type)
        return layer
    }
    
}

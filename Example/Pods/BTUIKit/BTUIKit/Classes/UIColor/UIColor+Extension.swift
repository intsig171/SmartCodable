//
//  UIColor+Extension.swift
//  BTUIKit
//
//  Created by Mccc on 2020/4/14.
//

import UIKit
import BTNameSpace


extension UIColor: NamespaceWrappable { }
extension NamespaceWrapper where T == UIColor {
    
    /// 生成Color对象
    /// - Parameters:
    ///   - r: 红色数值 不用除以255
    ///   - g: 绿色数值 不用除以255
    ///   - b: 蓝色数值 不用除以255
    public static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        
        let red: CGFloat = r / 255.0
        let green: CGFloat = g / 255.0
        let blue: CGFloat = b / 255.0
        
        return UIColor.init(red:red, green: green, blue: blue, alpha: 1)
    }
    
    
    /// 随机颜色
    
    
    /// 获取随机颜色
    /// - Parameter index: 颜色库中的下标，默认为-1，内部随机。
    /// - Returns: UIColor
    public static func random(_ index: Int = -1) -> UIColor {
        
        let colors: [String] = ["7DA5E3", "9DA4DC", "D6A889", "80B8CF", "D1BE85", "D99898"]
        
        let count = colors.count
        
        var temp = index
        
        if temp < 0 {
            let sample = UInt32(count)
            temp = Int(arc4random_uniform(sample))
        } else {
            temp = index % count
        }
        let colorHex = colors[temp]
        return hex(colorHex)
    }

    
    /// 生成Color对象
    /// - Parameters:
    ///   - hex: 16进制的颜色色值
    ///   - alpha: 透明度
    public static func hex(_ hex: String, alpha: CGFloat? = nil) -> UIColor {
        
        /**
         * #ff000000 此为16进制颜色代码
         * 前两位ff为透明度，后六位为颜色值（000000为黑色，ffffff为白色，可以用ps等软件获取）
         * 透明度分为256阶（0~255），计算机上16进制表示为（00~ff）,透明为0阶，不透明为255阶，如果50%透明度就是127阶（256的一半当然是128，但是因为从0开始，所以实际上是127）
         * 如果是6位，默认是不透明。
         */
        
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        
        var useAlpha: CGFloat = 1


        
        var hex:   String = hex
        
        /** 开头是用0x开始的 */
        if hex.hasPrefix("0X") {
            let index = hex.index(hex.startIndex, offsetBy: 2)
            hex = String(hex[index...])
        }
        
        /** 开头是以＃＃开始的 */
        if hex.hasPrefix("##") {
            let index = hex.index(hex.startIndex, offsetBy: 2)
            hex = String(hex[index...])
        }
        
        /** 开头是以＃开头的 */
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }

        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                let index = hex.index(hex.startIndex, offsetBy: 1)
                
                /// 处理透明度
                let alphaStr = String(hex[hex.startIndex..<index])
                if let doubleValue = Double(alphaStr) {
                    useAlpha = CGFloat(doubleValue) / 15
                }
                
                hex = String(hex[index...])
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                let index = hex.index(hex.startIndex, offsetBy: 2)
                /// 处理透明度
                let alphaStr = String(hex[hex.startIndex..<index])
                if let doubleValue = Double(alphaStr) {
                    useAlpha = CGFloat(doubleValue) / 255
                }
                
                hex = String(hex[index...])
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                

            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
            return UIColor.white
        }
        
        if let temp = alpha {
            useAlpha = temp
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: useAlpha)
    }
}



extension NamespaceWrapper where T == UIColor {
    
    /// 通过颜色生成图片
    public func makeImage() -> UIImage? {
        let rect = CGRect.init(x: 0.0, y: 0.0, width: 6.0, height: 6.0)
        UIGraphicsBeginImageContext(rect.size)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(wrappedValue.cgColor)
            context.fill(rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
}

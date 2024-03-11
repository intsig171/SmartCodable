//
//  BubbleTools.swift
//  BTBubble
//
//  Created by Mccc on 2022/11/21.
//

import Foundation
import UIKit



extension UIView {
    
    ///获取当前视图相对 屏幕的frame
    /// - Returns: 相对屏幕的rect
    public func convertFrameToScreen() -> CGRect {
        
        if let keyWindow = UIApplication.shared.keyWindow, let newBounds = superview?.convert(frame, to: keyWindow) {
            return newBounds
        }
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        var view: UIView = self
        
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
        
        return CGRect(x: x, y: y, width: frame.size.width, height: frame.size.height)
    }
}






//MARK: - 字体的设置
extension NSMutableAttributedString {
    /// 设置字体
    func addFont(_ font: UIFont, on range: NSRange) {
        
        if string.count == 0 { return }
        
        if length < range.location + range.length { return }
        let attrs = [NSAttributedString.Key.font: font]
        addAttributes(attrs, range: range)
    }
}

extension UIEdgeInsets {
    var horizontal: CGFloat {
        return self.left + self.right
    }
    
    var vertical: CGFloat {
        return self.top + self.bottom
    }
}


extension UIDevice {
    
    static var width: CGFloat {
        let size = UIScreen.main.bounds.size
        return size.width
    }
    
    static var height: CGFloat {
        let size = UIScreen.main.bounds.size
        return size.height
    }
}

extension String {
    
    /// 字符串 转 Number
    var numberValue: NSNumber? {
        let str = self
        if let value = Int(str) {
            return NSNumber.init(value: value)
        } else {
            return nil
        }
    }
    
    
    /// 计算字符串的宽度
    func getWidth(font: UIFont, height: CGFloat) -> CGFloat {
        let statusLabelText: NSString = self as NSString
        let size = CGSize.init(width: 9999, height: height)
        
        var dic: [NSAttributedString.Key : Any] = [:]
        dic[NSAttributedString.Key.font] = font
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context: nil).size
        return strSize.width + 1
    }
}


extension UIColor {
    /// 生成Color对象
    /// - Parameters:
    ///   - hex: 16进制的颜色色值
    ///   - alpha: 透明度
    static func hex(_ hex: String, alpha: CGFloat? = nil) -> UIColor {
        
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







extension UIWindow {
    /// 获取当前的window
    static var current: UIWindow? {
        if #available(iOS 13.0, *) {
            if let window =  UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first{
                return window
            }else if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return nil
            }
        } else {
            if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return nil
            }
        }
    }
}




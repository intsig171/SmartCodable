//
//  UIFont+Extension.swift
//  BTNameSpace
//
//  Created by Mccc on 2020/4/15.
//

import UIKit
import BTNameSpace

/** 待处理
 * 常用自定义字体
 */

extension UIFont: NamespaceWrappable { }
extension NamespaceWrapper where T == UIFont {
    
    // s 代表 system。 系统字体的意思
    public static let s8 = UIFont.bt.font(8)
    public static let s9 = UIFont.bt.font(9)
    public static let s10 = UIFont.bt.font(10)
    
    public static let s11 = UIFont.bt.font(11)
    public static let s12 = UIFont.bt.font(12)
    public static let s13 = UIFont.bt.font(13)
    public static let s14 = UIFont.bt.font(14)
    public static let s15 = UIFont.bt.font(15)
    public static let s16 = UIFont.bt.font(16)
    public static let s17 = UIFont.bt.font(17)
    public static let s18 = UIFont.bt.font(18)
    public static let s19 = UIFont.bt.font(19)
    public static let s20 = UIFont.bt.font(20)
    
    public static let s21 = UIFont.bt.font(21)
    public static let s22 = UIFont.bt.font(22)
    public static let s23 = UIFont.bt.font(23)
    public static let s24 = UIFont.bt.font(24)
    public static let s25 = UIFont.bt.font(25)
    public static let s26 = UIFont.bt.font(26)
    public static let s27 = UIFont.bt.font(27)
    public static let s28 = UIFont.bt.font(28)
    public static let s29 = UIFont.bt.font(29)
    public static let s30 = UIFont.bt.font(30)
    
    public static let s31 = UIFont.bt.font(31)
    public static let s32 = UIFont.bt.font(32)



    // b == bold  加粗 系统字体的加粗
    public static let b8 = UIFont.bt.bFont(8)
    public static let b9 = UIFont.bt.bFont(9)
    public static let b10 = UIFont.bt.bFont(10)
    
    public static let b11 = UIFont.bt.bFont(11)
    public static let b12 = UIFont.bt.bFont(12)
    public static let b13 = UIFont.bt.bFont(13)
    public static let b14 = UIFont.bt.bFont(14)
    public static let b15 = UIFont.bt.bFont(15)
    public static let b16 = UIFont.bt.bFont(16)
    public static let b17 = UIFont.bt.bFont(17)
    public static let b18 = UIFont.bt.bFont(18)
    public static let b19 = UIFont.bt.bFont(19)
    public static let b20 = UIFont.bt.bFont(20)
    
    public static let b21 = UIFont.bt.bFont(21)
    public static let b22 = UIFont.bt.bFont(22)
    public static let b23 = UIFont.bt.bFont(23)
    public static let b24 = UIFont.bt.bFont(24)
    public static let b25 = UIFont.bt.bFont(25)
    public static let b26 = UIFont.bt.bFont(26)
    public static let b27 = UIFont.bt.bFont(27)
    public static let b28 = UIFont.bt.bFont(28)
    public static let b29 = UIFont.bt.bFont(29)
    public static let b30 = UIFont.bt.bFont(30)
    
    public static let b31 = UIFont.bt.bFont(31)
    public static let b32 = UIFont.bt.bFont(32)



    /// 系统字体
    /// - Parameter size: 字号
    public static func font(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }

    
    /// 系统加粗字体
    /// - Parameter size: 字号
    public static func bFont(_ size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    
    /// 自定义字体
    /// - Parameters:
    ///   - name: 字体名
    ///   - size: 字号
    public static func customFont(name: String, size: CGFloat) -> UIFont? {
        
        if let font = UIFont.init(name: name, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }

    /// UI要求使用的数字字体（DIN Alternate Bold）
    public static func number(size: CGFloat) -> UIFont {
        
        // 后续要把这个字体库加进来。
        if let font = UIFont.init(name: "DIN Alternate Bold", size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
}

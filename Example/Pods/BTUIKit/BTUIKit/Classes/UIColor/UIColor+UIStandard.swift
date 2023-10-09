//
//  UIColor+UIStandard.swift
//  BTFoundation
//
//  Created by Mccc on 2020/8/20.
//


import UIKit
import BTNameSpace




/// 灰色系列
extension NamespaceWrapper where T == UIColor {

    
    /// 一级标题，关键功能
    public static var u212121 = UIColor.bt.hex("212121")
    
    /// 正文文本
    public static var u666666 = UIColor.bt.hex("666666")
    
    /// 说明文字，提示文案
    public static var u888888 = UIColor.bt.hex("888888")
    
    /// CCCCCC 默认提示，输入框提示
    public static var uCCCCCC = UIColor.bt.hex("CCCCCC")
    
    /// E9E9E9 分割线
    public static var uE9E9E9 = UIColor.bt.hex("E9E9E9")
    
    /// 页面背景色
    public static var uF5F5F5 = UIColor.bt.hex("F5F5F5")
    
    /// 白色背景，浅色卡片
    public static var uF7F7F7 = UIColor.bt.hex("F7F7F7")
}



/// 常用色
extension NamespaceWrapper where T == UIColor {

    /// 0D53FB 主色 （蓝色）
    public static var u0D53FB = UIColor.bt.hex("0D53FB")
    
    /// FFB400 辅助色 （橘色）
    public static var uFFB400 = UIColor.bt.hex("FFB400")
    
    /// FE4C24 警告色 负面色 （红色）
    public static var uFE4C24 = UIColor.bt.hex("FE4C24")
    
    /// FDCF01 品牌色 （黄色）
    public static var uFDCF01 = UIColor.bt.hex("FDCF01")
}



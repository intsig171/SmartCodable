//
//  BTFlexibleView.swift
//  swiftTest
//
//  Created by Allen on 2020/6/11.
//  Copyright © 2020 Allen. All rights reserved.
//  带有展开收起功能的label

public protocol BTFlexibleViewSuffixBtnStyleDataSource: NSObjectProtocol {
    
    /// 字体
    func textFontForSuffixButton(isOpen: Bool) -> UIFont
    
    /// 文本颜色
    func textColorForSuffixButton(isOpen: Bool) -> UIColor
    
    /// 按钮背景色
    func backGroundColorForSuffixButton(isOpen: Bool) -> UIColor
    
    /// 展开和收起状态下按钮的文字
    func textForSuffixButton(isOpen: Bool) -> String
    
    /// 按钮尺寸
    func sizeForSuffixButton(isOpen: Bool) -> CGSize
    
    /// 自定义操作
    func makeCustomSetting(suffixBtn: UIButton)
}

extension BTFlexibleViewSuffixBtnStyleDataSource {
    
    public func textFontForSuffixButton(isOpen: Bool) -> UIFont { return UIFont.systemFont(ofSize: 14) } // 字体

    public func textColorForSuffixButton(isOpen: Bool) -> UIColor { return UIColor.blue }// 文本颜色
    
    public func backGroundColorForSuffixButton(isOpen: Bool) -> UIColor { return UIColor.white }// 按钮背景色
        
    public func textForSuffixButton(isOpen: Bool) -> String {// 展开和收起状态下按钮的文字
        
        if isOpen {
            return "收起"
        } else {
            return "展开"
        }
    }
    
    public func sizeForSuffixButton(isOpen: Bool) -> CGSize { return CGSize(width: 30, height: 20)} ///按钮尺寸
    
    public func makeCustomSetting(suffixBtn: UIButton) {} // 对按钮做一些自定义操作
}

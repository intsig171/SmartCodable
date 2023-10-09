//
//  BTFlexibleView.swift
//  swiftTest
//
//  Created by Allen on 2020/6/11.
//  Copyright © 2020 Allen. All rights reserved.
//  带有展开收起功能的label

public protocol BTFlexibleFlexDelegate: NSObjectProtocol {
    
    /// 点击展开收起按钮的代理方法,修改后的控件size请使用selfSize()方法获取，别直接用view.frame!!!!
    func flexibleViewDidFlex(view:BTFlexibleView, isOpen: Bool)
}

extension BTFlexibleViewSuffixBtnStyleDataSource {
    
    public func didClickStuffixBtn(view:BTFlexibleView, isOpen: Bool) {}
}

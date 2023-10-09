//
//  BTFlexibleLabel.swift
//  swiftTest
//
//  Created by Allen on 2020/6/11.
//  Copyright © 2020 Allen. All rights reserved.
//  带有展开收起功能的label

import UIKit
import CoreText
import BTNameSpace
import Foundation

open class BTFlexibleLabel: BTVerticalAlignmentLabel {
    
    ///设置BTFlexibleLabel的配置
    public var config:BTFlexibleLabelConfig = .no(1)
    
    ///是否允许label长按复制 默认false
    public var enableCopy: Bool = false {
        didSet {
            if enableCopy {
                enableCopy()
            } else {
                disableCopyAbility()
            }
        }
    }
    
    ///控件的最大宽度，这个宽度和frameWidth一样 ,当init没有给明确的frame的时候，需要手动去设置maxWidth
    public var labelMaxWidth:CGFloat = 0
    
    ///BTFlexibleLabel的代理
    weak var privateDelegate: BTFlexibleLabelDelegate?
    
    public init(frame: CGRect, delegate: BTFlexibleLabelDelegate? = nil) {
        
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        self.lineBreakMode = .byTruncatingTail
        
        if let pDelegate = delegate {
            privateDelegate = pDelegate
        }
        
        //默认最大宽度就是frame的width
        labelMaxWidth = frame.size.width
        
        self.addSubview(suffixBtn)
        suffixBtn.isHidden = true
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var suffixBtn: UIButton = {
        let newBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 20))
        newBtn.setTitle("展开", for: UIControl.State.normal)
        newBtn.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        newBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        newBtn.backgroundColor = UIColor.gray
        newBtn.addTarget(self, action:#selector(didClickSuffixButton(sender:)), for: UIControl.Event.touchUpInside)
        return newBtn
    }()
}

// MARK: - public methods
extension BTFlexibleLabel {
    
    /// 使用普通字符串的方式
    /// - Parameters:
    ///   - text: label上的文本
    ///   - isOpen: 当前是否展开
    public func updateContent(text: String, isOpen:Bool) {
        let attrText = NSMutableAttributedString.init(string: text)
        attrText.addAttribute(NSAttributedString.Key.font, value: self.font ?? UIFont.systemFont(ofSize: 16), range: NSMakeRange(0, text.count))
        updateContent(attString: attrText, isOpen: isOpen)
    }
    
    /// 使用属性字符串的方式
    /// - Parameters:
    ///   - attString: 属性字符串
    ///   - isOpen: 当前是否展开
    public func updateContent(attString: NSAttributedString, isOpen:Bool){
        
        self.attributedText = checkFontAttributeExistence(attString: attString)
        
        switch config {
        case .no(_): suffixBtn.isHidden = true
        case .openAndClose(_,_): suffixBtn.isHidden = false
        case .onlyOpen(_,_): suffixBtn.isHidden = isOpen
        }
        
        if isOpen {
            spread()
        }else {
            shrink()
        }
    }
}

// MARK: - event response
extension BTFlexibleLabel {
    
    /// 点击按钮去展开或者收缩Label
    /// - Parameter sender: 展开收起的按钮
    @objc private func didClickSuffixButton(sender:UIButton){
        
        if  sender.isSelected {
            shrink()
        }else {
            //有些地方展开后不需要收起按钮，
            spread()
        }
        sender.isSelected = !sender.isSelected
        
        privateDelegate?.flexibleLabel(self, isOpen: sender.isSelected)
    }
}

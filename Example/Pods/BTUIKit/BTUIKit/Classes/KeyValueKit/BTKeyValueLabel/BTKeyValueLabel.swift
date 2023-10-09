//
//  BTFlexibleLabel.swift
//  swiftTest
//
//  Created by Allen on 2020/6/11.
//  Copyright © 2020 Allen. All rights reserved.
//  left and right Label

import UIKit


public class BTKeyValueLabel: UIView {
    
    /// 左侧控件的最小宽度,只针对左右布局的label有效
    public var keyMinWidth: CGFloat = 70
    
    /// 左侧控件的做大宽度,只针对左右布局的label有效
    public var keyMaxWidth: CGFloat = 70
    
    /// 内边距
    public var padding: UIEdgeInsets = .zero
        
    /// 左侧label，不要改它的lineBreakModel
    public lazy var keyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.bt.hex("212121")
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    /// 右侧label ，继承BTFlexibleLabel 可以设置一些对应的属性
    public lazy var valueLabel: BTFlexibleLabel = {
        let label = BTFlexibleLabel.init(frame: .zero, delegate: self)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.bt.hex("888888")
        return label
    }()
    
    public init(delegate: BTKeyValueLabelDelegate? = nil, layout: LayoutDirection = .horizontal(3)) {
        super.init(frame: .zero)
        self.privateDelegate = delegate
        self.layout = layout
        self.addSubview(keyLabel)
        self.addSubview(valueLabel)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///代理
    weak var privateDelegate: BTKeyValueLabelDelegate?
    
    /// 控件的布局方式，默认是左右布局
    var layout: LayoutDirection = .horizontal(0)
    
    ///用于保存点击事件需要传递的一个字典
    private var userInfo: [String: Any]? = nil
    
    
    private lazy var tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(valueLabelClickEvent))
}

extension BTKeyValueLabel{
    
    /// 更新keyLabel的文字
    /// - Parameters:
    ///   - text: 文字
    ///   - isOpen: 是否展开
    public func updateKey(_ text: String, isOpen: Bool = false) {
        updateContent(left: text, rightAtt: valueLabel.attributedText, isOpen: isOpen)
    }
    
    /// 更新valueLabel的文字
    /// - Parameters:
    ///   - text: 文字
    ///   - isOpen: 是否展开
    public func updateValue(_ text: String, isOpen: Bool = false) {
        let leftText = keyLabel.text ?? ""
        let rightAtt = createAttributedString(text: text)
        updateContent(left: leftText, rightAtt: rightAtt, isOpen: isOpen)
    }
    
    /// 更新valueLabel的文字
    /// - Parameters:
    ///   - string: 富文本
    ///   - isOpen: 是否展开
    public func updateValue(withAttributedString string: NSAttributedString, isOpen: Bool = false) {
        let leftText = keyLabel.text ?? ""
        updateContent(left: leftText, rightAtt: string, isOpen: isOpen)
    }
    
    ///设置右侧按钮点击事件
    public func valueLabelTapEnable(ableClick: Bool, userInfo: [String: Any]?) {
        if ableClick {
            self.userInfo = userInfo
            valueLabel.addGestureRecognizer(tap)
        } else {
            valueLabel.removeGestureRecognizer(tap)
        }
    }
}

// MARK: - customDelegate
extension BTKeyValueLabel: BTFlexibleLabelDelegate{
    
    public func flexibleLabel(_ flexibleLabel: BTFlexibleLabel, isOpen: Bool) {
        
        switch layout {
        case .horizontal(_):
            
            var maxHeight: CGFloat = keyLabel.frame.size.height
            if keyLabel.frame.size.height < valueLabel.frame.size.height {
                maxHeight = valueLabel.frame.size.height
            }
            
            frame = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: maxHeight)
        case .vertical(_):
            let itemsSpacing = layout.getSpacing()
            let height: CGFloat = keyLabel.frame.size.height + itemsSpacing + valueLabel.frame.size.height
            self.frame = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: height)
        }
        self.privateDelegate?.keyValueLabel(self, switchStatus: isOpen)
    }
}

// MARK: - event response
extension BTKeyValueLabel {
    ///点击valueLabel的事件
    @objc private func valueLabelClickEvent() {
        privateDelegate?.keyValueLabel(self, didClickValueLabel: userInfo)
    }
}

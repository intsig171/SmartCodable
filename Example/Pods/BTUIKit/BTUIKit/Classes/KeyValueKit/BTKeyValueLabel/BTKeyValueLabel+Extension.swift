//
//  BTKeyValueLabel+Extension.swift
//  BTFoundation
//
//  Created by qxb171 on 2020/9/2.
//

import Foundation

public protocol BTKeyValueLabelDelegate: NSObjectProtocol {
    
    /// 当前 展开/收起 开关状态
    func keyValueLabel(_ keyValueLabel: BTKeyValueLabel, switchStatus: Bool)
    
    /// 当前frame
    func keyValueLabel(_ keyValueLabel: BTKeyValueLabel, currentFrame: CGRect)
    
    /// 点击右侧label触发的点击事件
    func keyValueLabel(_ keyValueLabel: BTKeyValueLabel, didClickValueLabel userInfo:[String: Any]?)
}

extension BTKeyValueLabelDelegate {
    
    public func keyValueLabel(_ keyValueLabel: BTKeyValueLabel, switchStatus: Bool) { }
    
    public func keyValueLabel(_ keyValueLabel: BTKeyValueLabel, currentFrame: CGRect) { }
    
    public func keyValueLabel(_ keyValueLabel: BTKeyValueLabel, didClickValueLabel userInfo:[String: Any]?) { }
}

extension BTKeyValueLabel {
    
    public enum LayoutDirection {
        
        /// 水平布局(间距: 左右间距)
        case horizontal(CGFloat)
        
        /// 纵向布局(间距: 上下间距)
        case vertical(CGFloat)
        
        /// 获取当前两个label之间的间距
        func getSpacing() -> CGFloat {
            switch self {
            case .horizontal(let spacing): return spacing
            case .vertical(let spacing): return spacing
            }
        }
    }
}

extension BTKeyValueLabel {
    
    func createAttributedString(text: String) -> NSAttributedString {
        let rightAtt = NSMutableAttributedString(string: text)
        rightAtt.addAttributes([NSMutableAttributedString.Key.font: valueLabel.font ?? UIFont.systemFontSize], range: NSMakeRange(0, text.count))
        return rightAtt
    }
}

// MARK: 刷新view
extension BTKeyValueLabel {
    
    /// 刷新keyValueLabel的左右数据源
    @discardableResult
    func updateContent(left: String, rightAtt: NSAttributedString?, isOpen: Bool) -> CGRect {
        
        // 约束布局的情况下好获取frame
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        assert(self.frame.size.width != 0, "为了计算出控件的宽度，调用updateContent方法前必须设置left、right的约束")
        
        keyLabel.text = left
        
        let contaninerWidth = frame.size.width - padding.left - padding.right

        let itemsSpacing = layout.getSpacing()
        
        switch layout {
        case .horizontal(_):
            //第一次用sizeToFit计算的宽度是一行的情况下的显示宽度
            keyLabel.frame = CGRect.zero
            keyLabel.sizeToFit()
            
            if keyLabel.frame.size.width < keyMinWidth {
                keyLabel.frame = CGRect.init(x: padding.left, y: padding.top, width: keyMinWidth, height: keyLabel.frame.size.height)
            }
            
            if keyLabel.frame.size.width > keyMaxWidth {
                //左侧一行显示的宽度超过了设置的最大宽度，所以需要换行
                keyLabel.numberOfLines = 0
                let size = keyLabel.sizeThatFits(CGSize(width: keyMaxWidth, height: 99999))
                keyLabel.frame = CGRect.init(x: padding.left, y: padding.top, width: keyMaxWidth, height: size.height)
            }
            
            let rightMaxWidth = contaninerWidth - keyLabel.frame.size.width - itemsSpacing
            valueLabel.labelMaxWidth = rightMaxWidth
            if let tempAtt = rightAtt, tempAtt.string.count > 0 {
                valueLabel.updateContent(attString: tempAtt, isOpen: isOpen)
            }
            
            //设置新的frame

            self.frame = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: max(keyLabel.frame.size.height, valueLabel.frame.size.height) + padding.top + padding.bottom)
            keyLabel.frame = CGRect.init(x: padding.left, y: padding.top, width: keyLabel.frame.size.width, height: keyLabel.frame.size.height)
            valueLabel.frame = CGRect.init(x:keyLabel.frame.maxX + itemsSpacing, y: padding.top, width: valueLabel.frame.size.width, height: valueLabel.frame.size.height)

        case .vertical(_):
            //设置frame，然后就可以计算出宽高
            keyLabel.frame = CGRect.init(x: padding.left, y: padding.top, width: contaninerWidth, height: 20)
            keyLabel.numberOfLines = 0
            keyLabel.sizeToFit()
            valueLabel.labelMaxWidth = contaninerWidth
            if let tempAtt = rightAtt, tempAtt.string.count > 0 {
                valueLabel.updateContent(attString: tempAtt, isOpen: isOpen)
            }
            
            //设置新的frame
            self.frame = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: keyLabel.frame.size.height + itemsSpacing + valueLabel.frame.size.height)
            keyLabel.frame = CGRect.init(x: padding.left, y: padding.top, width: keyLabel.frame.size.width, height: keyLabel.frame.size.height)
            valueLabel.frame = CGRect.init(x: padding.left, y: keyLabel.frame.maxY + itemsSpacing, width: valueLabel.frame.size.width, height: valueLabel.frame.size.height)
        }
        privateDelegate?.keyValueLabel(self, currentFrame: frame)
        
        return frame
    }
}

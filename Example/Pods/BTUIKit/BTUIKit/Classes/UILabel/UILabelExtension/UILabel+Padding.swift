//
//  File.swift
//  BTFoundation
//
//  Created by Mccc on 2020/7/27.
//

import Foundation


/// 支持设置内边距的Label
public class BTPaddingLabel: UILabel {
    
    /// 设置内边距
    public var textInsets: UIEdgeInsets = .zero
}


extension BTPaddingLabel {
    override public func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = textInsets
        var rect = super.textRect(forBounds: bounds.inset(by: insets),
                                  limitedToNumberOfLines: numberOfLines)
        
        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
}

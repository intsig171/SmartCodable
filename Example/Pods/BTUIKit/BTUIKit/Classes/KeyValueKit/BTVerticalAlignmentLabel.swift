//
//  BTFlexibleLabel.swift
//  swiftTest
//
//  Created by Allen on 2020/6/11.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit

public enum VerticalAlignment{
    
    ///label的文本顶在最上面
    case top
    
    ///label的文本上下居中
    case middle
    
    ///label的文本顶在最底部
    case bottom
}

open class BTVerticalAlignmentLabel: UILabel {
    
    /// 设置纵向位置
    public var verticalAlignment:VerticalAlignment?{
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - override
extension BTVerticalAlignmentLabel {
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        
        var textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        
        if let alignment = verticalAlignment {
            switch alignment {
            case .top:
                textRect.origin.y = bounds.origin.y
            case .bottom:
                textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            case .middle:
                let height: CGFloat = (bounds.size.height - textRect.size.height) / 2.0
                textRect.origin.y = bounds.origin.y + height
            }
        }
        return textRect
    }
    
    open override func drawText(in rect: CGRect) {
        let actualRect = textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: actualRect)
    }
}

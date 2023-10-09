//
//  BTLimitRowLabel.swift
//  BTFoundation
//
//  Created by Allen on 2020/12/24.
//

import UIKit
import SnapKit

open class BTLimitRowLabel: BTVerticalAlignmentLabel {
    
    /// 设置label的最大显示行数，默认为0展示全部内容
    public var limitedRow: Int = 0
    
    /// 设置当前布局的方式
    public var layoutStyle: BTLabelLayoutStyleType = .useConstraints

    /// 文本部分刷新后的size
    private var contentSize : CGSize = .init(width: 0, height: 0)

    /// 获取当前刷新后的size
    public func selfSize() -> CGSize {
        return contentSize
    }
    
    /// 存当前允许的最大宽度
    public private (set) var maxWidth: CGFloat = 0
    
    /// 提供一个默认的字体一个默认的字体
    private lazy var defaultFont: UIFont = UIFont.systemFont(ofSize: 16)
    
    ///初始化只能用它！！！
    public convenience init(layoutStyle: BTLabelLayoutStyleType) {
        
        self.init(frame: .zero)
        
        lineBreakMode = .byTruncatingTail
        font = defaultFont
        verticalAlignment = .top
        self.layoutStyle = layoutStyle
    }
    
    open override var text: String? {
        
        didSet {
            // 这边如果直接取attributedText计算行数拿到的只有一行，必须要设置为属性字符串才能计算出正确的行数
            let attString = NSMutableAttributedString.init(string: text ?? "")
            attString.addAttribute(NSAttributedString.Key.font, value: font ?? defaultFont, range: NSMakeRange(0, attString.string.count))
            attributedText = attString
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
extension BTLimitRowLabel {
 
    open override func updateConstraints() {
        
        // 根据布局类型使用相应方式刷新UI
        switch layoutStyle {
        
        case .useframe(_):
            frame.size = selfSize()

        case .useConstraints:
            self.snp.updateConstraints { make in
                make.height.equalTo(selfSize().height)
            }
        }
                
        super.updateConstraints()
    }
    
    /// 保证通过frame设置的控件也能调用系统的updateConstraints方法
    open override class var requiresConstraintBasedLayout: Bool {
        get {
            return true
        }
    }

}

// MARK: - public func

extension BTLimitRowLabel {
    
    // 提供一个类似于tableview.reload的方法，在设置结束后统一调用方法刷新UI
   @objc public func refreshLabel() {
    
    switch layoutStyle {
    case .useframe(let labelFrameMaxWidth):
        
        assert(labelFrameMaxWidth > 0, "设置的frame最大宽度必须大于0")
        
        if labelFrameMaxWidth > 0 {
            maxWidth = labelFrameMaxWidth
        } else {
            maxWidth = UIScreen.main.bounds.size.width
        }
        
    case .useConstraints :
        
        setNeedsLayout()
        layoutIfNeeded()
        
        if frame.size.width > 0 {
            maxWidth = frame.size.width
        } else {
            assertionFailure("BTLimitRowLabel无法根据已有约束推断出最大宽度，请检查约束设置！！！！")
            maxWidth = UIScreen.main.bounds.size.width
        }
    }
    
    updateLabelFrame()
   
   }
    
}

// MARK: - private func
extension BTLimitRowLabel {

    /// 更新label的frame
    @objc private func updateLabelFrame(){
        
        /// 每次设置text 、attributeText 、limitedRow 重新设置frame
        if (text?.count ?? 0) > 0 {
                                    
            let linesArray = getMaxLineCount(size: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT))) as NSArray
            
            if limitedRow == 0 || linesArray.count <= limitedRow {
                //完全展示所有行数
                numberOfLines = 0;
            } else {
                // 展示部分行
                self.numberOfLines = limitedRow;
            }
            let newSize = sizeThatFits(.init(width: maxWidth, height: CGFloat(MAXFLOAT)))
            contentSize = newSize
        } else {
            contentSize = CGSize(width: 0, height: 0)
        }
        
        /// 告知系统需要更新约束，保证会在将来触发一次updateConstraints方法
        self.setNeedsUpdateConstraints()
    }
}


//
//  Array+Extension.swift
//  BTFoundation
//
//  Created by Mccc on 2020/4/7.
//

import Foundation
import BTNameSpace


extension NSMutableAttributedString: NamespaceWrappable {}


//MARK: - 字体的设置
extension NamespaceWrapper where T == NSMutableAttributedString {
    /// 设置字体
    public func addFont(_ font: UIFont, on range: NSRange) {
        
        if wrappedValue.string.count == 0 { return }
        
        if wrappedValue.length < range.location + range.length { return }
        let attrs = [NSAttributedString.Key.font: font]
        wrappedValue.addAttributes(attrs, range: range)
    }
    
    /// 设置字体颜色
    public func addForegroundColor(_ color: UIColor, range: NSRange) {
        if wrappedValue.string.count == 0 { return }

        if wrappedValue.length < range.location + range.length { return }
        let attrs = [NSAttributedString.Key.foregroundColor: color]
        wrappedValue.addAttributes(attrs, range: range)
    }
    
    /// 设置字体的背景颜色
    public func addBackgroundColor(_ color: UIColor, range: NSRange) {
        if wrappedValue.string.count == 0 { return }

        if wrappedValue.length < range.location + range.length { return }
        let attrs = [NSAttributedString.Key.backgroundColor: color]
        wrappedValue.addAttributes(attrs, range: range)
    }
}


//MARK: - 文本的处理
extension NamespaceWrapper where T == NSMutableAttributedString {

    /// 字符间距的设置 字符间距 正值间距加宽，负值间距变窄
    public func addKern(_ kern: Int, range: NSRange) {
        if wrappedValue.string.count == 0 { return }

        if wrappedValue.length < range.location + range.length { return }
        let attrs = [NSAttributedString.Key.kern: kern]
        wrappedValue.addAttributes(attrs, range: range)
    }
    
    /// 设置字体倾斜度，正值右倾，负值左倾
    public func addObliqueness(_ obliqueness: CGFloat, range: NSRange) {
        if wrappedValue.string.count == 0 { return }

        if wrappedValue.length < range.location + range.length { return }
        let attrs = [NSAttributedString.Key.obliqueness: obliqueness]
        wrappedValue.addAttributes(attrs, range: range)
    }
    
    /// 设置字体的横向拉伸，正值拉伸 ，负值压缩
    public func addExpansion(_ expansion: CGFloat, range: NSRange) {
        if wrappedValue.string.count == 0 { return }

        if wrappedValue.length < range.location + range.length { return }
        let attrs = [NSAttributedString.Key.expansion: expansion]
        wrappedValue.addAttributes(attrs, range: range)
    }
    
    /// 文字书写方向
    public func addWritingDirection(_ direction: NSWritingDirection, range: NSRange) {
        if wrappedValue.string.count == 0 { return }

        if wrappedValue.length < range.location + range.length { return }
        
        var value: (Int) = (0)
        
        if direction == .leftToRight {
            if #available(iOS 9.0, *) {
                value = (NSWritingDirectionFormatType.override.rawValue |  NSWritingDirection.leftToRight.rawValue)
            } else {
                // Fallback on earlier versions
            }
        } else {
            if #available(iOS 9.0, *) {
                value = (NSWritingDirectionFormatType.override.rawValue |  NSWritingDirection.rightToLeft.rawValue)
            } else {
                // Fallback on earlier versions
            }
        }
        
        /**
         NSAttributedString.Key.writingDirection接收的是一个数组
         */
        
        /**
         //@[@(NSWritingDirectionLeftToRight | NSWritingDirectionEmbedding)]
         //@[@(NSWritingDirectionLeftToRight | NSWritingDirectionOverride)]
         //@[@(NSWritingDirectionRightToLeft | NSWritingDirectionEmbedding)]
         //@[@(NSWritingDirectionRightToLeft | NSWritingDirectionOverride)]
         // NSWritingDirectionOverride 和 NSWritingDirectionEmbedding 是指定Unicode双向定义的格式控制算法（具体的没太搞清楚）
         */
        
        let attrs = [NSAttributedString.Key.writingDirection: [value]]
        wrappedValue.addAttributes(attrs, range: range)
    }
}


//MARK: - 删除线
extension NamespaceWrapper where T == NSMutableAttributedString {

    /// 设置删除线 NSUnderlineStyle: none不设置，single单细线删除，thick粗单线， Double双细线
    public func addStrikethrough(style: NSUnderlineStyle = .single, color: UIColor? = nil, range: NSRange) {
        if wrappedValue.string.count == 0 { return }

        if wrappedValue.length < range.location + range.length { return }
        
        let attr1 = [NSAttributedString.Key.strikethroughStyle: style.rawValue]
        wrappedValue.addAttributes(attr1, range: range)
        
        if let tempColor = color {
            let attr2 = [NSAttributedString.Key.strikethroughColor: tempColor]
            wrappedValue.addAttributes(attr2, range: range)
        }
    }
}

//MARK: - 下划线
extension NamespaceWrapper where T == NSMutableAttributedString {

    /// 设置下划线 NSUnderlineStyle: none不设置，single单细线删除，thick粗单线， Double双细线
    public func addUnderLine(style: NSUnderlineStyle = .single, color: UIColor? = nil, range: NSRange) {
        if wrappedValue.string.count == 0 { return }

        if wrappedValue.length < range.location + range.length { return }
        
        let attrs = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        wrappedValue.addAttributes(attrs, range: range)
        
        if let tempColor = color {
            let attr2 = [NSAttributedString.Key.underlineColor: tempColor]
            wrappedValue.addAttributes(attr2, range: range)
        }
    }
}


extension NamespaceWrapper where T == NSMutableAttributedString {

    /// 设置文字的描边 (可以用此值做字体加粗效果)
    public func addStroke(color: UIColor, width: CGFloat, range: NSRange) {
        if wrappedValue.string.count == 0 { return }

        /**
         设置文字描边颜色，需要NSStrokeWidthAttributeName设置描边宽度，这样就能使文字空心.
         
         NSStrokeWidthAttributeName,该值改变笔画宽度（相对于字体 size 的百分比），负值填充效果，正值中空效果，默认为 0，即不改变。正数只改变描边宽度。负数同时改变文字的描边和填充宽度。例如，对于常见的空心字，这个值通常为 3.0。
         同时设置了空心描边和文字前景两个属性，并且NSStrokeWidthAttributeName 属性设置为整数，文字前景色就无效果了
         */
        
        if wrappedValue.length < range.location + range.length { return }
        
        let attrs = [
            NSAttributedString.Key.strokeWidth: width,
            NSAttributedString.Key.strokeColor: color
            ] as [NSAttributedString.Key : Any]
        wrappedValue.addAttributes(attrs, range: range)
    }
    
    /// 阴影
    public func addShadow(_ shadow: NSShadow, range: NSRange) {
        if wrappedValue.string.count == 0 { return }
        if wrappedValue.length < range.location + range.length { return }
        let attrs = [NSAttributedString.Key.shadow: shadow]
        wrappedValue.addAttributes(attrs, range: range)
    }
    
    /// 设置文字的特殊NSAttributedString.Key这一个凸版印刷效果)
    public func addTextEffect(effect: NSAttributedString.TextEffectStyle = .letterpressStyle, range: NSRange) {
        if wrappedValue.string.count == 0 { return }
        if wrappedValue.length < range.location + range.length { return }
        let attrs = [NSAttributedString.Key.textEffect: effect]
        wrappedValue.addAttributes(attrs, range: range)
    }
}


// MARK: - 偏移量
extension NamespaceWrapper where T == NSMutableAttributedString {

    /// 设置上下偏移量 正数上移，负数下移
    public func addBaselineOffset(_ offset: CGFloat, range: NSRange) {
        if wrappedValue.string.count == 0 { return }
        if wrappedValue.length < range.location + range.length { return }
        let attrs = [NSAttributedString.Key.baselineOffset: offset]
        wrappedValue.addAttributes(attrs, range: range)
    }
    
    /// 设置行间距
    public func addLineSpacing(_ style: NSMutableParagraphStyle, range: NSRange) {
        
        if wrappedValue.string.count == 0 { return }

        /**
         具体请看： https://www.jianshu.com/p/b0afc45bb642
         
         NSAttributedString.Key.paragraphStyle     设置文本段落排版，为NSParagraphStyle对象
         
         paragraphStyle.lineSpacing            = 0.0; //增加行高
         paragraphStyle.headIndent             = 0;   //头部缩进，相当于左padding
         paragraphStyle.tailIndent             = 0;   //相当于右padding
         paragraphStyle.lineHeightMultiple     = 0;   //行间距是多少倍
         paragraphStyle.alignment              = NSTextAlignmentLeft;//对齐方式
         paragraphStyle.firstLineHeadIndent    = 0;   //首行头缩进
         paragraphStyle.paragraphSpacing       = 0;   //段落后面的间距
         paragraphStyle.paragraphSpacingBefore = 0;   //段落之前的间距
         */
        
        if wrappedValue.length < range.location + range.length { return }
        
        let attrs = [NSAttributedString.Key.paragraphStyle: style]
        wrappedValue.addAttributes(attrs, range: range)
    }
}



extension NamespaceWrapper where T == NSMutableAttributedString {

    /// 插入图片
    public func addTextAttachment(image: UIImage?, imageFrame: CGRect, atIndex index: Int) {
        
        let attachment = NSTextAttachment.init()
        attachment.image = image
        attachment.bounds = imageFrame
        let att = NSAttributedString(attachment: attachment)
        wrappedValue.insert(att, at: index)
    }
}


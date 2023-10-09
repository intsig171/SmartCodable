//
//  UILabel+BTLabelExtension.swift
//
//  Created by Allen on 2020/12/24.
//  和label行计算有关的方法

extension UILabel {
    
    /// 计算出在宽度固定、高度不限的情况下文本在label上展示需要的行数
    /// coreText局限性，为了计算label需要的行数，必须使用《属性字符串》，直接使用text计算不出行数
    /// - Parameter size: 传入绘制文本矩形范围
    /// - Returns: 将每行文本拆分为CTLine后组成的数组
    public func getMaxLineCount(size: CGSize)->(CFArray){
        if let attString = self.attributedText {
            let path = CGPath(rect: CGRect.init(x: 0, y: 0, width:size.width , height: size.height), transform: nil)
            let framesetter = CTFramesetterCreateWithAttributedString(attString)
            let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0,attString.string.count), path, nil)
            let lines = CTFrameGetLines(frame) as NSArray
            
            return lines
        }else {
            return [] as CFArray
        }
    }
}

public extension UILabel {
    
    enum BTLabelLayoutStyleType {
        
        /// 使用frame布局(最大宽度)
        case useframe(CGFloat)
        
        /// 使用约束布局，初始化必须设置初始约束，并且必须设置 :make.height.qualTo(20) ，方便内部自动修改行高
        case useConstraints
    }

    enum BTLabelSuffixButtonType {
        
        /// 不需要任何操作
        case none
        
        /// 只需要展开，展开后按钮隐藏
        case onlyOpen
        
        /// 可以展开和收起
        case openAndClose
    }
    
    ///文本后的展开收起按钮的跟随样式
    enum BTLabelSuffixButtonPosition {
        ///右下角
        case rightBottom
        
        ///底部居中 CGFloat：按钮和文本之间的间距
        case middleBottom(CGFloat)
        
        ///跟在最后一行文本的末尾
        case followBottomLine(CGFloat)
        
        /// 重写枚举相等的判断方法，只要枚举大类型一致就判断相等
        static func == (before: BTLabelSuffixButtonPosition, after: BTLabelSuffixButtonPosition) -> Bool {
            switch (before, after) {
            case (.rightBottom, .rightBottom): return true
            case (.middleBottom(_), .middleBottom(_)): return true
            case (.followBottomLine(_), .followBottomLine(_)): return true
            default: return false
            }
        }
        
        static func getMargin(_ position:BTLabelSuffixButtonPosition) -> CGFloat {
            switch position {
            case .followBottomLine(let margin): return margin
            case .middleBottom(let margin): return margin
            default: return 0
            }
        }
    }
}

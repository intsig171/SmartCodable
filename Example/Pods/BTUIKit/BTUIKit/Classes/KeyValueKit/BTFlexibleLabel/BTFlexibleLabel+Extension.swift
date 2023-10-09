//
//  BTFlexibleLabel+Extension.swift
//  BTFoundation
//
//  Created by Allen on 2020/9/8.
//

import Foundation

extension BTFlexibleLabel {
    
    public enum BTFlexibleLabelConfig {
        
        ///功能：指定最大行数显示label Int：最大显示行数
        case no(Int)
        
        ///功能：1.指定最大行数显示label 2.设置展开按钮 3.收起按钮
        ///Int：最大显示行数 suffixButtonPosition：展开收起按钮的样式
        case openAndClose(Int, SuffixButtonPosition)
        
        ///功能： 1.指定最大行数显示label 2.设置展开按钮 3.点击展开后按钮隐藏无法收起
        ///Int：最大显示行数 suffixButtonPosition：展开收起按钮的样式
        case onlyOpen(Int, SuffixButtonPosition)
        
        ///文本后的展开收起按钮的跟随样式
        public enum SuffixButtonPosition {
            ///右下角
            case rightBottom
            
            ///底部居中 CGFloat：按钮和文本之间的间距
            case middleBottom(CGFloat)
            
            ///跟在最后一行文本的末尾
            case followBottomLine(CGFloat)
            
            ///不显示按钮
            case no
        }
        
        ///取出最大行数，并且过滤掉小于1的值
        static func getMaxNumberOfLine(_ config:BTFlexibleLabelConfig) -> Int {
            switch config {
            case .no(let lineCount): return max(lineCount,1)
            case .onlyOpen(let lineCount, _): return max(lineCount,1)
            case .openAndClose(let lineCount, _): return max(lineCount,1)
            }
        }
        
        /// 取出展开收起按钮的位置样式
        static func getSuffixButtonPosition(_ config: BTFlexibleLabelConfig) -> SuffixButtonPosition {
            switch config {
            case .no(_): return .no
            case .onlyOpen(_,let position): return position
            case .openAndClose(_,let position): return position
            }
        }
        
        /// 取出再展开收起按钮单独一行的情况下和文本之间的间距
        static func getSuffixButtonSpacing(_ config:BTFlexibleLabelConfig) -> CGFloat {
            switch getSuffixButtonPosition(config) {
            case .middleBottom(let spacing): return spacing
            case .followBottomLine(let spacing): return spacing
            case .rightBottom: return CGFloat(0)
            case .no: return CGFloat(0)
            }
        }
        
        /// 重写枚举相等的判断方法，只要枚举大类型一致就判断相等
        static func == (before: BTFlexibleLabelConfig, after: BTFlexibleLabelConfig) -> Bool {
            switch (before, after) {
            case (.no(_), .no(_)): return true
            case (.openAndClose(_,_), .openAndClose(_,_)): return true
            case (.onlyOpen(_,_), .onlyOpen(_,_)): return true
            default: return false
            }
        }
    }
}

// MARK: - BTFlexibleLabelDelegate
//代理方法用于通知父view去刷新整体UI BTFlexibleLabel本身的高度在内部自动调整好，无需处理
public protocol BTFlexibleLabelDelegate: NSObjectProtocol{
    
    /// 点击展开收起按钮
    /// - Parameter isOpen:是否当前处于展开状态 openStatus??
    func flexibleLabel(_ flexibleLabel: BTFlexibleLabel, isOpen:Bool)->(Void)
}

// MARK: - override delegate func
extension BTFlexibleLabel {
    func flexibleLabel(_ flexibleLabel: BTFlexibleLabel, isOpen:Bool){}
}

// MARK: - updateUI
extension BTFlexibleLabel {
    
    /// 调用该方法后label会被收起
    func shrink(){
        let linesArray = getMaxLineCount(size: CGSize.init(width: labelMaxWidth, height: CGFloat(MAXFLOAT))) as NSArray
        let maxCount = linesArray.count
        
        let allowedMaxCount = BTFlexibleLabelConfig.getMaxNumberOfLine(config)
        
        if maxCount > allowedMaxCount {
            //显示不下需要展开按钮
            suffixBtn.setTitle("展开", for: UIControl.State.normal)
            
            //sizeToFit方法调用前控件的CGRect必须有一个值且不能为zero，不然算不出多行的高度，只会算成一行
            self.frame = CGRect.init(x: 0, y: 0, width: labelMaxWidth, height: 20)
            self.numberOfLines = allowedMaxCount
            self.sizeToFit()
            
            switch BTFlexibleLabelConfig.getSuffixButtonPosition(config) {
                
            case .followBottomLine:
                
                //可以展开的情况下按钮肯定是在右下角的
                self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: labelMaxWidth, height: self.frame.size.height)
                
                let x: CGFloat = self.frame.size.width - suffixBtn.frame.size.width
                let y: CGFloat = self.frame.size.height - suffixBtn.frame.size.height
                suffixBtn.frame = CGRect.init(x: x, y: y, width: suffixBtn.frame.size.width, height: suffixBtn.frame.size.height)
                
            case .middleBottom:
                
                if suffixBtn.isHidden == false {
                    verticalAlignment = .top
                    
                    let spacing = BTFlexibleLabelConfig.getSuffixButtonSpacing(config)
                    
                    let x: CGFloat = (self.frame.size.width - suffixBtn.frame.size.width)/2
                    let y: CGFloat = self.frame.size.height + spacing
                    suffixBtn.frame = CGRect.init(x: x, y: y, width:suffixBtn.frame.size.width , height: suffixBtn.frame.size.height)
                    
                    let selfHeight: CGFloat = self.frame.size.height + suffixBtn.frame.size.height + spacing
                    self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: labelMaxWidth, height: selfHeight)
                    
                } else {
                    
                    self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: labelMaxWidth, height: self.frame.size.height)
                }
                
            case .rightBottom:
                
                self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: labelMaxWidth, height: self.frame.size.height)
                
                let x:  CGFloat = self.frame.size.width - suffixBtn.frame.size.width
                let y: CGFloat = self.frame.size.height - suffixBtn.frame.size.height
                
                suffixBtn.frame = CGRect.init(x: x, y: y, width: suffixBtn.frame.size.width, height: suffixBtn.frame.size.height)
                
                
            case .no:
                self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: labelMaxWidth, height: self.frame.size.height)
            }
            
        }else {
            //最大行数够显示
            suffixBtn.isHidden = true
            //sizeToFit方法调用前控件的CGRect必须有一个值且不能为zero，不然算不出多行的高度，只会算成一行
            self.frame = CGRect.init(x: 0, y: 0, width: labelMaxWidth, height: 20)
            self.numberOfLines = maxCount
            self.sizeToFit()
            
            if self.frame.size.width > labelMaxWidth {
                self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: labelMaxWidth, height: self.frame.size.height)
                
            } else {
                self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
            }
        }
    }
    
    /// 调用该方法后label会被展开
    func spread(){
        
        let linesArray = getMaxLineCount(size: CGSize.init(width: labelMaxWidth, height: CGFloat(MAXFLOAT))) as NSArray
        let maxCount = linesArray.count
        
        if  config == BTFlexibleLabelConfig.no(1) || config == BTFlexibleLabelConfig.onlyOpen(1,.no) {
            suffixBtn.isHidden = true
        } else {
            suffixBtn.isHidden = false
        }
        
        self.numberOfLines = maxCount
        self.sizeToFit()
        
        suffixBtn.setTitle("收起", for: UIControl.State.normal)
        
        switch BTFlexibleLabelConfig.getSuffixButtonPosition(config) {
            
        case .followBottomLine:
            
            let lineWidth:CGFloat = CGFloat((linesArray.lastObject as! CTLine).width())
            
            let spacing = BTFlexibleLabelConfig.getSuffixButtonSpacing(config)
            
            if lineWidth + suffixBtn.frame.size.width + spacing >= labelMaxWidth {
                //直接放在最后面
                suffixBtn.frame = CGRect.init(x: self.frame.size.width - 30, y: self.frame.size.height - 20, width: suffixBtn.frame.size.width, height: suffixBtn.frame.size.height)
            }else {
                suffixBtn.frame = CGRect.init(x: lineWidth + spacing, y: self.frame.size.height - suffixBtn.frame.size.height, width: suffixBtn.frame.size.width, height: suffixBtn.frame.size.height)
            }
            
            self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: labelMaxWidth, height: self.frame.size.height)
            
        case .middleBottom:
            if suffixBtn.isHidden == false {
                
                let spacing = BTFlexibleLabelConfig.getSuffixButtonSpacing(config)
                
                suffixBtn.frame = CGRect.init(x: (self.frame.size.width - suffixBtn.frame.size.width)/2, y: self.frame.size.height + spacing, width:suffixBtn.frame.size.width , height: suffixBtn.frame.size.height)
                self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: labelMaxWidth, height: self.frame.size.height + suffixBtn.frame.size.height + spacing)
            } else {
                suffixBtn.frame = CGRect.init(x: self.frame.size.width - suffixBtn.frame.size.width, y: self.frame.size.height - suffixBtn.frame.size.height, width: suffixBtn.frame.size.width, height: suffixBtn.frame.size.height)
                self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: labelMaxWidth, height: self.frame.size.height)
            }
            
        case .rightBottom:
            self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: labelMaxWidth, height: self.frame.size.height)
            suffixBtn.frame = CGRect.init(x: self.frame.size.width - suffixBtn.frame.size.width, y: self.frame.size.height - suffixBtn.frame.size.height, width: suffixBtn.frame.size.width, height: suffixBtn.frame.size.height)
        case .no:
            self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: labelMaxWidth, height: self.frame.size.height)
        }
    }
    
}

// MARK: - private methods
extension BTFlexibleLabel {
    
    /// 用于解析属性字符串是否包含font属性，如果没有的话会影响展示，给它设置一个默认的font
    func checkFontAttributeExistence(attString: NSAttributedString) -> NSMutableAttributedString{
        
        //为空字符串会崩溃
        if attString.string.count == 0 {
            return NSMutableAttributedString.init(string: "-")
        }
        
        let attM = NSMutableAttributedString(attributedString: attString)
        
        //获取属性字符串所有的属性
        var hasFontAtt = false
        let attributes = attM.attributes(at: 0, effectiveRange:nil)
        
        attributes.forEach { attributeDict in
            if attributeDict.key == NSMutableAttributedString.Key.font {
                //判断当前属性字符串中包含font的属性
                hasFontAtt = true
            }
        }
        
        //如果属性字符串没有设置过font 默认给个font字体
        if !hasFontAtt {
            attM.addAttribute(NSMutableAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16), range: NSMakeRange(0, attM.string.count))
        }
        return attM
    }
}


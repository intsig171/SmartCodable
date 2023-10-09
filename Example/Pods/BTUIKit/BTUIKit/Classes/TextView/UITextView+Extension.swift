//
//  UITextView+Extension.swift
//  BTFoundation
//
//  Created by Mccc on 2020/6/4.
//

import BTNameSpace

//extension UITextView: NamespaceWrappable { }

extension NamespaceWrapper where T: UITextView {
    
    /// 添加链接文本 scheme为空表示无链接
    /// - Parameters:
    ///   - text: 显示的文字内容
    ///   - scheme: 跳转链接标识
    ///   - showUnderline: 是否显示下划线
    ///   - underlineColor: 下划线颜色
    public func appendLink(text: String,
                           scheme: String = "",
                           showUnderline: Bool = false,
                           underlineColor: UIColor? = nil) {
        //原来的文本内容
        let attrString:NSMutableAttributedString = NSMutableAttributedString()
        attrString.append(wrappedValue.attributedText)
        
        //新增的文本内容（使用默认设置的字体样式）
        let attrs = [NSAttributedString.Key.font : wrappedValue.font ?? UIFont.systemFont(ofSize: 14)]
        let appendString = NSMutableAttributedString(string: text, attributes:attrs)
        //判断是否是链接文字
        if scheme != "" {
            let range:NSRange = NSMakeRange(0, appendString.length)
            appendString.beginEditing()
            appendString.addAttribute(NSAttributedString.Key.link, value:scheme, range:range)
            
            if showUnderline {
                appendString.addAttribute(NSAttributedString.Key.underlineStyle, value:NSUnderlineStyle.single.rawValue, range:range)
                
                if let color = underlineColor {
                    appendString.addAttribute(NSAttributedString.Key.underlineColor, value:color, range:range)
                }
            }
            appendString.endEditing()
        }
        //合并新的文本
        attrString.append(appendString)
        //设置合并后的文本
        wrappedValue.attributedText = attrString
    }
}



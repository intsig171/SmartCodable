//
//  UILabel+BTLabelExtension.swift
//
//  Created by Allen on 2020/12/24.
//

extension CTLine {
    
    /// 根据CTline获取某一行字符串的宽度
    /// - Returns: 某行的文本宽度
    public func width() -> Double {
        var lineAscent = CGFloat()
        var lineDescent = CGFloat()
        var lineLeading = CGFloat()
        return CTLineGetTypographicBounds(self , &lineAscent, &lineDescent, &lineLeading)
    }
}

//
//  BTTextViewConfig.swift
//  BTFoundation
//
//  Created by Mccc on 2020/6/4.
//

//
//继续处理
//1. 修改BTTextView+Extension的命名。容易引起歧义  (完成)
//2. 是否动态更新TextView的高度。 （最小高度，最大高度）
//3. 优化实现代码

extension BTTextView {
    
    /// 占位文字的设置
    public struct PlaceHolder {
        public var text: String = ""
        public var color: UIColor = UIColor.placeholderColor
        ///未设置时的默认值
        public var textContainerInset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
}


extension BTTextView {
    
    /// TextView 限制文字的设置
    public struct LimitText {
        public var count: Int = 0
        public var color: UIColor = UIColor.placeholderColor
        public var font: UIFont = UIFont.limitFont
        public var margin:(top: CGFloat ,bottom: CGFloat, right: CGFloat) = (5 , 5, 5)
    }
}


extension BTTextView {
    
    /// TextView 动态高度的配置
    public struct DynamicHeight {
        public var isSupport: Bool = false
        public var min: CGFloat = 44
        public var max: CGFloat = CGFloat.greatestFiniteMagnitude
    }
}


extension UIColor {
    internal static var placeholderColor = UIColor.init(red: 202/255.0, green: 202/255.0, blue: 204/255.0, alpha: 1)
}


extension UIFont {
    internal static var limitFont = UIFont.systemFont(ofSize: 12)
    internal static var defaultFont = UIFont.systemFont(ofSize: 14)
}

extension String {
    // 字符串的截取 从头截取到指定index
    func bt_prefix(index:Int) -> String {
        if self.count <= index {
            return self
        } else {
            let index = self.index(self.startIndex, offsetBy: index)
            let str = self.prefix(upTo: index)
            return String(str)
        }
    }
}

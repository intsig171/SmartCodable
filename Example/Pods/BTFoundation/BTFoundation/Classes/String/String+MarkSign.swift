//
//  String+MarkSign.swift
//  BTFoundation
//
//  Created by qxb171 on 2021/3/4.
//

import Foundation
import BTNameSpace


extension NamespaceWrapper where T == String {

    /// 转换字符串标签格式为富文本
    /// - Parameter defaultAttr: 设置属性字符串基础的颜色、字体等设置
    /// - Parameter callBack: 回调 如果没有link标签，不需要处理
    /// - Returns: 富文本
    public func smartMarkSign(defaultAttr: [NSAttributedString.Key: Any] = [:], callBack: (([NSRange]) -> Void)? = nil) -> NSMutableAttributedString? {
        
        var tempStr = wrappedValue

        /// 1. 先处理换行符号
        tempStr = tempStr.replaceNewline()

        /// 3. 初始化富文本
        let att = NSMutableAttributedString(string: tempStr)
        if defaultAttr.keys.count > 0 { // 默认设置属性字符串的基本属性，其他标签的颜色字体修改在这个的基础上在进行
            att.addAttributes(defaultAttr, range: NSRange(location: 0, length: att.string.count))
        }
        
        /// 5. 再处理特殊标签
        att.doingMarkSign()
        
        /// 6. 获取所有的link标签的range
        let ranges = att.replaceLinkMarkSign()
        callBack?(ranges)
        
        return att
    }
}

extension NamespaceWrapper where T == NSMutableAttributedString {

    /// 处理多个标签的高亮显示，覆盖顺序按照数组顺序来（不重要的尽量放前面）
    /// 转换字符串标签格式为富文本
    /// - Parameter markSignInfos: 标记符号信息数组
    /// - Returns: 富文本
    public func transformMarkSign(markSignInfos: [BTMarkSignInfo]) {
        
        let attString =  wrappedValue
        
        for markItem in markSignInfos {
            wrappedValue.mapping(attString: attString, markItem: markItem) { (range) in
                attString.addAttributes(markItem.alteredAttributes, range: range)
            }
        }
    }
}


extension String {
    /// 将字符串中的换行符号（\r 或 \n） 替换为 <br> (HTML的换行符号)
    func replaceNewline() -> String {
        var replacedStr = ""
        let sign = "\n"
        replacedStr = replacingOccurrences(of: "<br>", with: sign)
        replacedStr = replacedStr.replacingOccurrences(of: "\r\n", with: sign)
        replacedStr = replacedStr.replacingOccurrences(of: "\n\r", with: sign)
        replacedStr = replacedStr.replacingOccurrences(of: "\r", with: sign)
        return replacedStr
    }
}



extension NSMutableAttributedString {
    
    /// 处理Link标签
    /// - Returns: link标签包裹的内容所在的范围
    func replaceLinkMarkSign() -> [NSRange] {
        
        /// 处理多个标签的高亮显示，覆盖顺序按照数组顺序来（不重要的尽量放前面）
        func getRange(markArray: [BTMarkSignInfo]) -> [NSRange] {
            let attString =  self
            var rangeArr: [NSRange] = []
            for markItem in markArray {
                mapping(attString: attString, markItem: markItem) { (range) in
                    rangeArr.append(range)
                }
            }
            return rangeArr
        }

        
        let link = BTMarkSignCustomType.link
        
        let start = link.startSignFormat()
        let end = link.endSignFormat()
        
        var markinfo = BTMarkSignInfo(startSign: start, endSign: end, alteredAttributes: link.getAttDict())
        markinfo.startSign = start
        markinfo.endSign = end
        let ranges = getRange(markArray: [markinfo])
        return ranges
    }
    
    
    /// 处理标签
    /// - Returns: 富文本
    func doingMarkSign() {
        var arr: [BTMarkSignInfo] = []
        for item in BTMarkSignCustomType.allCases {
            // 先不处理link标签，后边做范围的获取
            if item == .link { break }
            let start = item.startSignFormat()
            let end = item.endSignFormat()
            let markinfo = BTMarkSignInfo(startSign: start, endSign: end, alteredAttributes: item.getAttDict())
            arr.append(markinfo)
        }
        bt.transformMarkSign(markSignInfos: arr)
    }
    

    /// 循环匹配标签
    func mapping(attString: NSMutableAttributedString, markItem: BTMarkSignInfo, callBack: (NSRange) -> Void) {
        var needSearch = true
        while needSearch {
            let matchBegin = (attString.string as NSString).range(of: markItem.startSign, options: .caseInsensitive)
            if matchBegin.location != NSNotFound {
                attString.deleteCharacters(in: matchBegin)
                let firstCharacter = matchBegin.location
                let range = NSMakeRange(firstCharacter, attString.length - firstCharacter)
                let matchEnd = (attString.string as NSString).range(of: markItem.endSign, options: .caseInsensitive, range: range)
                if matchEnd.location != NSNotFound {
                    attString.deleteCharacters(in: matchEnd)
                    let lastCharacter = matchEnd.location
                    let tempRange = NSMakeRange(firstCharacter, lastCharacter - firstCharacter)
                    callBack(tempRange)
                } else {
                    needSearch = false
                }
            } else {
                needSearch = false
            }
        }
    }
}

/// 用于保存某一种标签需要的一些数据
public struct BTMarkSignInfo {
    public var startSign: String = ""
    public var endSign: String = ""
    public var alteredAttributes: [NSAttributedString.Key : Any] = [:]
    
    public init(startSign: String, endSign: String, alteredAttributes: [NSAttributedString.Key : Any]) {
        self.startSign = startSign
        self.endSign = endSign
        self.alteredAttributes = alteredAttributes
    }
}



/// 自定义的标签类型（不能被html识别的）
fileprivate enum BTMarkSignCustomType: String, CaseIterable {
    
    /// 加粗
    case b
    /// 颜色（变红色） #F5573E
    case em
    /// 颜色（变蓝色）品牌色 #0D53FB
    case bm
    /// 颜色（变灰色）#B6B8C1
    case gm
    /// 颜色（变灰色#B6B8C1）+ 添加删除线
    case gm_del
    /// 删除线
    case del
    /// 支持点击
    case link

    /// 获取枚举项对应的富文本内容
    func getAttDict() -> [NSAttributedString.Key: Any] {
        var att: [NSAttributedString.Key: Any] = [:]
        
        switch self {
        case .b:
            // 字体加粗
            // NSAttributedString.Key.strokeWidth这个属性所对应的值是一个 NSNumber 对象(小数)。该值改变描边宽度（相对于字体size 的百分比）。默认为 0，即不改变。正数只改变描边宽度。负数同时改变文字的描边和填充宽度。
            att.updateValue(NSNumber.init(value: -3.5), forKey: NSAttributedString.Key.strokeWidth)
        case .em:
            att.updateValue(UIColor.hex("FE4C24"), forKey: NSAttributedString.Key.foregroundColor)
        case .bm:
            att.updateValue(UIColor.hex("0D53FB"), forKey: NSAttributedString.Key.foregroundColor)
        case .gm:
            att.updateValue(UIColor.hex("B6B8C1"), forKey: NSAttributedString.Key.foregroundColor)
        case .gm_del:
            att.updateValue(UIColor.hex("B6B8C1"), forKey: NSAttributedString.Key.foregroundColor)
            att.updateValue(NSUnderlineStyle.single.rawValue, forKey: NSAttributedString.Key.strikethroughStyle)
        case .del:
            att.updateValue(NSUnderlineStyle.single.rawValue, forKey: NSAttributedString.Key.strikethroughStyle)
        case .link:
            break
        }
        return att
    }
    
    
    /// 获取开始的标记符号
    func startSignFormat() -> String {
        return "<\(self.rawValue)>"
    }
    
    /// 获取结束的标记符号
    func endSignFormat() -> String {
        return "</\(self.rawValue)>"
    }
}


extension UIColor {
    /// 生成Color对象
    /// - Parameters:
    ///   - hex: 16进制的颜色色值
    ///   - alpha: 透明度
    fileprivate static func hex(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        
        /**
         * #ff000000 此为16进制颜色代码
         * 前两位ff为透明度，后六位为颜色值（000000为黑色，ffffff为白色，可以用ps等软件获取）
         * 透明度分为256阶（0~255），计算机上16进制表示为（00~ff）,透明为0阶，不透明为255阶，如果50%透明度就是127阶（256的一半当然是128，但是因为从0开始，所以实际上是127）
         * 如果是6位，默认是不透明。
         */
        
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = alpha
        var hex:   String = hex
        
        /** 开头是用0x开始的 */
        if hex.hasPrefix("0X") {
            let index = hex.index(hex.startIndex, offsetBy: 2)
            hex = String(hex[index...])
        }
        
        /** 开头是以＃＃开始的 */
        if hex.hasPrefix("##") {
            let index = hex.index(hex.startIndex, offsetBy: 2)
            hex = String(hex[index...])
        }
        
        /** 开头是以＃开头的 */
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
            return UIColor.white
        }
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

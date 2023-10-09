//
//  Array+Extension.swift
//  BTFoundation
//
//  Created by Mccc on 2020/4/7.
//

import Foundation


import UIKit
import CommonCrypto
import BTNameSpace


/** 待处理
 * 密码强度的判断，是否需要多种
 */


extension String : NamespaceWrappable { }


//MARK: - 类型转换
extension NamespaceWrapper where T == String {

    /// 字符串 转 Int
    public var intValue: Int {
        let str = wrappedValue
        return Int(str) ?? 0
    }

    /// 字符串 转 Float
    public var floatValue: Float {
        let str = wrappedValue
        return Float(str) ?? 0
    }
    
    /// 字符串 转 Double
    public var doubleValue: Double {
        let str = wrappedValue
        return Double(str) ?? 0
    }
    
    /// 字符串 转 Number
    public var numberValue: NSNumber? {
        let str = wrappedValue
        if let value = Int(str) {
            return NSNumber.init(value: value)
        } else {
            return nil
        }
    }
}

//MARK: - 字符串的判断
extension NamespaceWrapper where T == String {

    // 电话号码打码处理
    public func mosaicPhoneNumber() -> String {
        let phone = wrappedValue
        
        if phone.count <= 3 {
            // 不打码
            return phone
            
        } else if phone.count <= 7 {
            // 前3位不打码，后面全部打码
            let range = NSRange(location: 3, length: phone.count - 3)
            var starString = ""
            for _ in 0..<range.length {
                starString = starString + "*"
            }
            let mockPhone = (phone as NSString).replacingCharacters(in: range, with: starString)
            return mockPhone
            
        } else {
            // 前3位 最后4位不打码，中间剩余部分打码
            let range = NSRange(location: 3, length: phone.count - 7)
            var starString = ""
            for _ in 0..<range.length {
                starString = starString + "*"
            }
            let mockPhone = (phone as NSString).replacingCharacters(in: range, with: starString)
            return mockPhone
        }
    }
    
    /// 字符串是否业务空
    /// - Returns: Bool, 如果为空，返回true
    public var isBusinessEmpty: Bool {
        if wrappedValue == "" || wrappedValue == "-" || wrappedValue == " " {
            return true
        }
        return false
    }
    
    /// 判断是否电话号码 11位并且首位是1
    public func isPhoneNumber() -> Bool {
        if wrappedValue.count != 11 { return false }
        if wrappedValue.first != "1" { return false }
        return true
    }
    
    /// 校验密码强度，必须包含字母和数字，长度范围[8, 20]
    public func isValidPassword() -> Bool {
        let pattern = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$"
        let regex = try? NSRegularExpression.init(pattern: pattern, options: .caseInsensitive)
        guard let result = regex?.matches(in: wrappedValue,options: .reportCompletion, range: NSRange(location: 0, length: wrappedValue.count)) else {
            return false
        }
        if result.count > 0 {
            return true
        } else {
            return false
        }
    }
}

//MARK: - 字符串的长度/高度/行数
extension NamespaceWrapper where T == String {

    /// 获取字符串的行数
    public func getLines(maxWidth: CGFloat, font: UIFont) -> Int {
        let content = wrappedValue
        let currentFont = font
        let myFont = CTFontCreateWithName(currentFont.fontName as CFString, currentFont.pointSize, nil)
        let attStr = NSMutableAttributedString.init(string: content)
        let range = NSRange(location: 0, length: attStr.length)
        attStr.addAttributes([NSAttributedString.Key.font : myFont], range: range)

        let frameSetter = CTFramesetterCreateWithAttributedString(attStr)
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: maxWidth, height: 9999))
        let frame = CTFramesetterCreateFrame(frameSetter, CFRange(location: 0, length: 0), path, nil)
        let lines = CTFrameGetLines(frame) as NSArray
        return lines.count
    }

    
    /// 计算字符串的高度
    public func getHeight(fontValue: CGFloat, width: CGFloat, lineSpacing: CGFloat = 0) -> CGFloat {
        return getHeight(font: UIFont.systemFont(ofSize: fontValue), width: width, lineSpacing: lineSpacing)
    }
    
    /// 计算字符串的高度
    public func getHeight(font: UIFont, width: CGFloat, lineSpacing: CGFloat = 0) -> CGFloat {
        let statusLabelText: NSString = wrappedValue as NSString
        let size = CGSize.init(width: width, height: 9000)
        
        var dic: [NSAttributedString.Key : Any] = [:]

        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = lineSpacing
        dic[NSAttributedString.Key.paragraphStyle] = paraStyle


        dic[NSAttributedString.Key.font] = font
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context: nil).size
        return strSize.height + 1
    }
    
    /// 计算字符串的宽度
    public func getWidth(fontValue: CGFloat, height: CGFloat) -> CGFloat {
        return getWidth(font: UIFont.systemFont(ofSize: fontValue), height: height)
    }
    
    /// 计算字符串的宽度
    public func getWidth(font: UIFont,height: CGFloat) -> CGFloat {
        let statusLabelText: NSString = wrappedValue as NSString
        let size = CGSize.init(width: 9999, height: height)
        
        var dic: [NSAttributedString.Key : Any] = [:]
        dic[NSAttributedString.Key.font] = font
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context: nil).size
        return strSize.width + 1
    }
}



//MARK: - 字符串的截取
extension NamespaceWrapper where T == String {

    /// 截取指定的区间
    public func clip(range: (location: Int, length: Int)) -> String {

        if range.location < 0 || range.length < 0 {
            return wrappedValue
        }

        if range.location + range.length > wrappedValue.count {
            return wrappedValue
        }
        let locationIndex = wrappedValue.index(wrappedValue.startIndex, offsetBy: range.location)
        let range = locationIndex..<wrappedValue.index(locationIndex, offsetBy: range.length)
        return String(wrappedValue[range])
    }
    
    /// 字符串的截取 从头截取到指定index
    public func clipFromPrefix(to index: Int) -> String {
        
        if wrappedValue.count <= index || index < 0 {
            return wrappedValue
        } else {
            let index = wrappedValue.index(wrappedValue.startIndex, offsetBy: index)
            let str = wrappedValue.prefix(upTo: index)
            return String(str)
        }
    }

    /// 字符串的截取 从指定位置截取到尾部
    public func cutToSuffix(from index: Int) -> String {
        if wrappedValue.count <= index || index < 0 {
            return wrappedValue
        } else {
            let selfIndex = wrappedValue.index(wrappedValue.startIndex, offsetBy: index)
            let str = wrappedValue.suffix(from: selfIndex)
            return String(str)
        }
    }

    /// 获取字符出现的位置信息(支持多次位置获取)
    /// - Parameter string: 要查找的字符串（小字符串）
    public func queryRangesOf(_ string: String) -> [NSRange] {

        var ranges: [NSRange] = []

        if string.elementsEqual("") { return ranges }

        guard let _ = wrappedValue.range(of: wrappedValue) else { return ranges }

        let zero = wrappedValue.startIndex
        let target = Array(string)
        let total = Array(wrappedValue)

        let lenght = string.count
        var startPoint = 0

        while total.count >= startPoint + string.count {
            if total[startPoint] == target[0] {
                let startIndex = wrappedValue.index(zero, offsetBy: startPoint)
                let endIndex = wrappedValue.index(startIndex, offsetBy: lenght)
                let child = wrappedValue[startIndex..<endIndex]
                if child.elementsEqual(string) {
                    ranges.append(NSRange.init(location: startPoint, length: lenght))
                    startPoint += lenght
                }else{
                    startPoint += 1
                }
            }else{
                startPoint += 1
            }
        }
        return ranges
    }



    /// 查找字符串的range
    /// - Parameter longString: 长的字符串
    /// - Returns: NSRange
    public func rangInString(longString: String) -> NSRange? {
        
        if wrappedValue.count == 0 {
            return nil
        }
        
        if longString.count == 0 {
            return nil
        }
        
        if longString.count < wrappedValue.count {
            return nil
        }
        guard let range = longString.range(of: wrappedValue) else {
            return nil
        }

        if range.lowerBound >= longString.endIndex {
            return nil
        }

        let location = longString.distance(from: longString.startIndex, to: range.lowerBound)
        return NSRange.init(location: location, length: wrappedValue.count)
    }
}


//MARK: - 字符串的转换
extension NamespaceWrapper where T == String {

    /// 对播放路径中的中文字符处理
    public func amendEncoding() -> String {
        func isIncludeChineseIn(string: String) -> Bool {
            
            for (_, value) in string.enumerated() {
                if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                    return true
                }
            }
            return false
        }
        
        var endPlayPath = ""
        if isIncludeChineseIn(string: wrappedValue) {
            endPlayPath = wrappedValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        } else {
            endPlayPath = wrappedValue
        }
        return endPlayPath
    }
    
    /// MD5加密 需要在桥接文件中引入 <CommonCrypto/CommonDigest.h>
    public func md5() -> String {
        let str = wrappedValue.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(wrappedValue.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize(count: 0)
        
        return String(format: hash as String)
    }
    
    /// JSONString转换为字典
    public func toDictionary() -> Dictionary<String, Any>? {
        guard let jsonData:Data = wrappedValue.data(using: .utf8) else {
            return nil
        }
        if let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
            
            if let temp = dict as? Dictionary<String, Any> {
                return temp
            }
        }
        return nil
    }

    /// JSONString转换为数组
    public func toArray() -> Array<Any>? {
        
        let jsonData:Data = wrappedValue.data(using: .utf8)!
        
        if let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
            if let temp = array as? Array<Any> {
                return temp
            }
        }
        return nil
    }
    
    /// 将HTML字符串转化为富文本
    public func htmlFormat() -> NSMutableAttributedString? {
        
        guard let data = wrappedValue.data(using: String.Encoding.utf16) else {
            return nil
        }
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        let attStr = try? NSMutableAttributedString.init(data: data, options: options, documentAttributes: nil)
        return attStr
    }


    /// 手机号格式化 （123 4567 8910)
    public func phoneNumberFormat() -> String {
        guard let number = wrappedValue.bt.numberValue else {
            return wrappedValue
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.positiveFormat = "###,####,####" //设置格式
        if var format = numberFormatter.string(from: number) {
            format = format.replacingOccurrences(of: ",", with: " ")
            return format
        } else {
            return wrappedValue
        }
    }
}

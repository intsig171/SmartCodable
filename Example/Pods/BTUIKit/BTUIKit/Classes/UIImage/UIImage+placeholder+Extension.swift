//
//  UIImage+placeholder+Extension.swift
//  BTNameSpace
//
//  Created by Mccc on 2020/5/14.
//

import Foundation
import BTNameSpace
import BTFoundation

extension NamespaceWrapper where T == UIImage {
    
    // 实现规则情况： https://doc.intsig.net/pages/viewpage.action?pageId=80773374
    
    /// 默认的文字图片类型
    public enum UIImageTextPlaceholderType {
        /// 企业类型的 文字图片类型
        case company
        /// 人员类型的 文字图片类型
        case person
        /// 集团类型的 效果与企业一致
        case group
        /// 自定义显示文字的个数
        case custom(Int)
    }
    
        
    /// 生成文字图，适用于列表场景。通过传入eid，确定背景颜色，保证同一个企业的背景颜色一样。
    /// - Parameters:
    /// - Parameters:
    ///   - text: 文案内容（优先显示）
    ///   - assistText: 文案内容 (text没有值，使用这个显示)
    ///   - type: 使用场景类型
    ///   - wAndH: 图片长或宽的长度（正方形）
    ///   - id: id
    /// - Returns: UIImage?
    public static func make(
        text: String?,
        assistText: String?,
        type: UIImageTextPlaceholderType,
        wAndH: CGFloat,
        id: String) -> UIImage? {


        func getColorHex(id: String) -> String {
            guard let tail = id.last else { return "E37D7D" }
            switch tail {
            case "0", "1":
                return "E37D7D"
            case "2", "3":
                return "7DA5E3"
            case "4", "5":
                return "7D95E3"
            case "6", "7":
                return "6AB5DA"
            case "8", "9":
                return "D9C487"
            case "a", "b":
                return "85D1B0"
            case "c", "d":
                return "E3A97D"
            case "e", "f":
                return "9B91E5"
            default:
                return "E37D7D"
            }
        }

        let hex = getColorHex(id: id)
        let color = UIColor.bt.hex(hex)
        let image = NamespaceWrapper.make(text: text, assistText: assistText, type: type, wAndH: wAndH, backgroudColor: color)
        return image
    }


    public static func make(
        text: String?,
        assistText: String?,
        type: UIImageTextPlaceholderType,
        wAndH: CGFloat,
        row: Int) -> UIImage? {
        let color = UIColor.bt.random(row)
        let image = NamespaceWrapper.make(text: text, assistText: assistText, type: type, wAndH: wAndH, backgroudColor: color)
        return image
    }

    
    /// 通过文字创建图片
    /// - Parameters:
    ///   - text: 文案内容（优先显示）
    ///   - assistText: 文案内容 (text没有值，使用这个显示)
    ///   - type: 使用场景类型
    ///   - wAndH: 图片长或宽的长度（正方形）
    ///   - backgroudColor: 生成的图片背景颜色，如果传nil。默认使用UIColor.bt.random(0)
    public static func make(
        text: String?,
        assistText: String?,
        type: UIImageTextPlaceholderType,
        wAndH: CGFloat,
        backgroudColor: UIColor? = nil) -> UIImage? {

        
        var showTest = ""
        if let temp = text, temp != "-", temp.count > 0 {
            switch type {
            case .group:
                showTest = makeGroupString(text: temp)
            default:
                showTest = temp
            }
        } else {
            if let temp = assistText {
                switch type {
                case .group:
                    showTest = makeGroupString(text: temp)
                default:
                    showTest = temp
                }
            }
        }
        
        /// 处理集团的文字图片展示，去除末尾的集团二字
            func makeGroupString(text: String) -> String {
                let count: Int = text.count
                if text.hasSuffix("集团") && count > 2 {
                    let finalString: String = text.bt.clipFromPrefix(to: count - 2)
                    return finalString
                } else {
                    return text
                }
            }
        
        /// 判断是否英文
        func isEnglishText(str: String) -> Bool {
            for char in str.utf8 {
                if (char > 64 && char < 91) || (char > 96 && char < 123) {
                    return true
                }
            }
            return false
        }
        
        /// 截取要显示的文案
        func clipText() -> String? {
            if showTest.count == 0 { return nil }
            if isEnglishText(str: showTest) {
                return showTest.bt.clipFromPrefix(to: 1)
            } else {
                switch type {
                case .company:
                    /// 内部做了长度不足的处理
                    return showTest.bt.clipFromPrefix(to: 4)
                case .person:
                    return showTest.bt.clipFromPrefix(to: 1)
                case .group:
                    return showTest.bt.clipFromPrefix(to: 4)
                case .custom(let length):
                    return showTest.bt.clipFromPrefix(to: length)
                }
            }
        }

        /// 计算字体的Size
        func calculateFontSize(text: String) -> UIFont {
            var scale: CGFloat = 2
            if text.count == 1 {
                scale = 2
            } else {
                scale = 3.333
            }
            let fontSize: CGFloat = wAndH / scale
            return UIFont.systemFont(ofSize: fontSize)
        }
        
        /// 绘制
        func draw(x: CGFloat, y: CGFloat, text: String, att: [NSAttributedString.Key: NSObject]) {
            let point = CGPoint(x: x, y: y)
            text.draw(at: point, withAttributes: att)
        }
        
        var scale: CGFloat = 1
        
        /// 获取无文字的替代图
        func getPlaceholderImage(size: CGSize) -> UIImage? {
            var imageNmae: String = ""
            switch type {
            case .company:
                imageNmae = "company"
            case .person:
                imageNmae = "person"
            case .group:
                imageNmae = "company"
            case .custom(_):
                scale = 0.56
                imageNmae = "placeholder"
            }
            
            
            let bundle = Bundle.bt.getBundleWithName("BTUIKitUIImageBundle", inPod: "BTUIKit")
            let temp = UIImage.bt.loadImage(imageNmae, inBundle: bundle)
            let tempImage = UIImage.bt.placeholder(size: size, image: temp,scale: scale)
            
            return tempImage
        }
        
        let size: CGSize = CGSize(width: wAndH, height: wAndH)
        // 如果没有文字，就使用UI提供的默认图
        guard let showText = clipText() else {
            let tempImage = getPlaceholderImage(size: size)
            return tempImage
        }
        let font: UIFont = calculateFontSize(text: showText)

        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.drawPath(using: .stroke)
        
        if let bc = backgroudColor {
            context?.setFillColor(bc.cgColor)
        } else {
            let color = UIColor.bt.random(0)
            context?.setFillColor(color.cgColor)
        }
        
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))

        // 计算一个字符的宽度 （sizeToFit）
        let first: String = String(showText.first!)
        let attributes = [NSAttributedString.Key.font:font,NSAttributedString.Key.foregroundColor:UIColor.white]
        let sizeToFit = first.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: font.pointSize), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        // 根据不同的文字字数，进行绘制
        switch showText.count {
        case 1:
            let x = (size.width - sizeToFit.size.width) / 2
            let y = (size.height - sizeToFit.size.height) / 2
            draw(x: x, y: y, text: showText, att: attributes)
        case 2:
            let x = (size.width - sizeToFit.size.width * 2) / 2
            let y = (size.height - sizeToFit.size.height) / 2
            draw(x: x, y: y, text: showText, att: attributes)
        case 3:
            let string1 = showText.bt.clip(range: (0, 2))
            let x1 = (size.width - sizeToFit.size.width*2) / 2
            let y1 = size.height / 2 - sizeToFit.size.height
            draw(x: x1, y: y1, text: string1, att: attributes)
            
            let string2 = showText.bt.cutToSuffix(from: 2)
            let x2 = (size.width - sizeToFit.size.width) / 2
            let y2 = size.height / 2
            draw(x: x2, y: y2, text: string2, att: attributes)
        case 4:
            let string1 = showText.bt.clip(range: (0, 2))
            let x1 = (size.width - sizeToFit.size.width * 2) / 2
            let y1 = size.height / 2 - sizeToFit.size.height
            draw(x: x1, y: y1, text: string1, att: attributes)

            let string2 = showText.bt.cutToSuffix(from: 2)
            let x2 = (size.width - sizeToFit.size.width * 2) / 2
            let y2 = size.height / 2
            draw(x: x2, y: y2, text: string2, att: attributes)
        default:
            break
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}









extension NamespaceWrapper where T == UIImage {

    /// 1:1 占位图
    public static let placeholder1x1 = placeholder(size: CGSize(width: 100, height: 100))
    /// 2:1 占位图
    public static let placeholder2x1 = placeholder(size: CGSize(width: 200, height: 100))
    /// 3:1 占位图
    public static let placeholder3x1 = placeholder(size: CGSize(width: 300, height: 100))
    /// 3:2 占位图
    public static let placeholder3x2 = placeholder(size: CGSize(width: 300, height: 200))
    /// 5:3 占位图
    public static let placeholder5x3 = placeholder(size: CGSize(width: 500, height: 300))
    
    
    /// 生成占位图
    /// - Parameters:
    ///   - size: 占位图总大小
    ///   - image: 内容图片
    ///   - bgColor: 背景颜色
    public static func placeholder (
        size     :CGSize = CGSize(width: 100, height: 100),
        image: UIImage? = nil,
        bgColor: UIColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1),
        scale: CGFloat = 0.56
    ) -> UIImage? {
        
        /** 关于占位图的说明
         * 产品要求默认背景颜色为 245 245 245 即 f5f5f5
         * 内容图片在占位图的中心位置
         * 内容图片的宽或者高 占占位图的65%。以最大情况适配，并保证不变形
         */
                
        // 尺寸的判断
        var tempSize = size
        if tempSize.width <= 0 { tempSize.width = 50 }
        if tempSize.height <= 0 { tempSize.height = 50 }
        
        
        // 绘图
        UIGraphicsBeginImageContextWithOptions(tempSize, false, UIScreen.main.scale)
        bgColor.set()
        UIRectFill(CGRect.init(x: 0, y: 0, width: tempSize.width, height: tempSize.height))
        
        var tempImage = image
        if tempImage == nil {
            let bundle = Bundle.bt.getBundleWithName("BTUIKitUIImageBundle", inPod: "BTUIKit")
            tempImage = UIImage.bt.loadImage("placeholder", inBundle: bundle)
        }
        
        if let contentImage = tempImage {
            contentImage.draw(in: getRect(size: tempSize, image: contentImage, scale: scale))
            let resImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resImage
        }
        return nil
    }
}



// 计算内容区域图片，在占位图上的frame
fileprivate func getRect(size: CGSize, image: UIImage, scale: CGFloat = 0.56) -> CGRect {
    let containerW: CGFloat = size.width
    let containerH: CGFloat = size.height
    
    var logoW: CGFloat = image.size.width
    var logoH: CGFloat = image.size.height
    
    
    let wScale: CGFloat = logoW / containerW
    let hScale: CGFloat = logoH / containerH
    
    
    var needScale = scale
    
    if wScale > hScale {
        needScale = needScale / wScale
    } else {
        needScale = needScale / hScale
    }
    
    logoW = logoW * needScale
    logoH = logoH * needScale
    
    
    let imageX: CGFloat = (containerW - logoW) / 2
    let imageY: CGFloat = (containerH - logoH) / 2
    
    return CGRect.init(x: imageX, y: imageY, width: logoW, height: logoH)
}

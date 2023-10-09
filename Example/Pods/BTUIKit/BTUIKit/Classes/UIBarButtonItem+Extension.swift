//
//  UIBarButtonItem+Extension.swift
//  MBProgressHUD
//
//  Created by MC on 2018/12/7.
//

import UIKit
import BTNameSpace

extension UIBarButtonItem: NamespaceWrappable { }
extension NamespaceWrapper where T == UIBarButtonItem {
    
    /// 添加导航栏Image类型元素项
     ///
     /// - Parameters:
     ///   - image: 要显示的图片
     ///   - target: target
     ///   - selector: 事件
     ///   - isRight: 是否左侧导航栏元素项(默认右侧导航栏元素项)
     /// - Returns: UIBarButtonItem
     public static func setImage(_ image: UIImage?, target: Any?, selector: Selector?, isRight: Bool = false) -> UIBarButtonItem {
         
        

        
        
        
         var size = image?.size ?? CGSize.zero
         if size.width < 20 { size.width = 20 }
         if size.height < 20 { size.height = 20 }
         
         let imageView = UIImageView()
         
         imageView.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
         imageView.isUserInteractionEnabled = true
         imageView.image = image
         let tap = UITapGestureRecognizer.init(target: target, action: selector)
         imageView.addGestureRecognizer(tap)
         
         
         if isRight {
            imageView.contentMode = .right
         } else {
            imageView.contentMode = .left
         }
         return UIBarButtonItem.init(customView: imageView)
     }
     
     /// 添加导航栏文本类型元素项
     ///
     /// - Parameters:
     ///   - text: 要显示的文字内容
     ///   - textColor: 文字颜色
     ///   - font: 文字字体 UIFont
     ///   - target: target
     ///   - selector: 事件
     ///   - isRight: 是否左侧导航栏元素项（默认右侧）
     /// - Returns: UIBarButtonItem
     public static func setText(_ text: String, textColor: UIColor, font: UIFont, target: Any?, selector: Selector?, isRight: Bool = true) -> UIBarButtonItem {
         
        let lineHeight = font.lineHeight
         var strWidth = text.getWidth(font: font, height: lineHeight + 4)
         
         if strWidth < 44 { strWidth = 44 }
         
         let button = UIButton.init(type: UIButton.ButtonType.custom)
         button.frame = CGRect.init(x: 0, y: 0, width: strWidth, height: 44)
         if let temp = selector {
             button.addTarget(target, action: temp, for: UIControl.Event.touchUpInside)
         }
         button.adjustsImageWhenHighlighted = false
         
         button.titleLabel?.font = font
         button.setTitle(text, for: UIControl.State.normal)
         button.setTitleColor(textColor, for: UIControl.State.normal)
         
         if isRight {
            button.contentHorizontalAlignment = .right
         } else {
            button.contentHorizontalAlignment = .left
         }
         return UIBarButtonItem.init(customView: button)
     }
}


extension String {
    
    ///  计算字符串的宽度  不对外开放
    fileprivate func getWidth(font: UIFont, height: CGFloat) -> CGFloat {
        let statusLabelText: NSString = self as NSString
        let size = CGSize.init(width: 9999, height: height)
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context: nil).size
        return strSize.width
    }
}

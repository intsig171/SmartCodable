//
//  UILabel+CopyExtension.swift
//  BTFoundation
//
//  Created by 满聪 on 2020/6/19.
//

import Foundation
import BTNameSpace

var copyingBackgroundColor: UIColor? = UIColor.init(red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1)
var originBackgroundColor: UIColor?

extension NamespaceWrapper where T: UILabel {

    /// 开启复制功能
    /// - Parameters:
    ///   - isShowMenu: 是否展示menu
    ///   - copyingColor: 按压下去，copy的背景颜色
    ///   - block: menu的显示状态闭包回调, 返回true->弹出menu
    public func enableCopy(copyingColor: UIColor? = nil) {
        wrappedValue.enableCopy(copyingColor: copyingColor)
    }
    
    /// 禁用长按复制能力。（会移除所有的长按手势）
    public func disableCopy() {
        wrappedValue.disableCopyAbility()
    }
}

extension UILabel {
    
    /// 禁用长按复制能力。（会移除所有的长按手势）
    func disableCopyAbility() {
        if let gestures = self.gestureRecognizers {
            for gesture in gestures {
                if gesture.isKind(of: UILongPressGestureRecognizer.self) {
                    self.removeGestureRecognizer(gesture)
                }
            }
        }
    }
    
    /// 开启长按复制功能
    /// - Parameters:
    ///   - copyingColor: 长按复制时选中的文字背景色
    ///   - block: 复制菜单显示的回调
    func enableCopy(copyingColor: UIColor? = nil) {
                
        if let _ = copyingColor {
            copyingBackgroundColor = copyingColor
        }
        
        isUserInteractionEnabled = true
        /// 清除重复添加的长按手势（对一个label重复执行enableCopy，长按手势不会覆盖，只会叠加）
        if let gestures = gestureRecognizers {
            for gesture in gestures {
                if gesture.isKind(of: UILongPressGestureRecognizer.self) {
                    self.removeGestureRecognizer(gesture)
                }
            }
        }
  
        addGestureRecognizer(UILongPressGestureRecognizer.init(target: self, action: #selector(self.longTapImmediatelyCopyEvent)))
    }
}


extension UILabel {
    /// 长按直接复制
    @objc func longTapImmediatelyCopyEvent(recognizer: UIGestureRecognizer) {

        if text == "" || text == "-" {
            return
        }

        if recognizer.state == .began {
            originBackgroundColor = backgroundColor
            backgroundColor = copyingBackgroundColor
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.backgroundColor = originBackgroundColor
                originBackgroundColor = nil
                UIPasteboard.bt.copyInEquipment(with: self.text ?? "")
                recognizer.state = .ended
                Prompt.showText("复制成功" ,duration: 2)
            }
        }
    }
    
    @objc func copyEvent(menu: UIMenuController) {
        UIPasteboard.bt.copyInEquipment(with: text ?? "")
    }
}

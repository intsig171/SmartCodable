//
//  BTToast+Remove.swift
//  BTToast
//
//  Created by Mccc on 2020/6/24.
//

import Foundation



internal extension Selector {
    static let hideNotice = #selector(Prompt.hideNotice(_:))
}

extension Prompt {
    
    /// 隐藏
    @objc static func hideNotice(_ sender: AnyObject) {
        if let window = sender as? UIWindow {
            
            if let v = window.subviews.first {
                UIView.animate(withDuration: 0.2, animations: {
                    v.alpha = 0
                }, completion: { b in
                    
                    if let index = windows.firstIndex(where: { (item) -> Bool in
                        return item == window
                    }) {
                        windows.remove(at: index)
                    }
                })
            }
        }
    }
}


extension Prompt {
    
    /// 自动隐藏
    static func autoRemove(window: UIWindow, duration: CGFloat) {
        let autoClear : Bool = duration > 0 ? true : false
        if autoClear {
            self.perform(.hideNotice, with: window, afterDelay: TimeInterval(duration))
        }
    }
}

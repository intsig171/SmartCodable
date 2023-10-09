//
//  BTToast.swift
//  BTToast
//
//  Created by Mccc on 2019/4/19.
//


/** 适配横竖屏
 * 将所有的frame修改为layout布局。
 * demo中写横竖屏切换的方法，验证效果。
 */



import Foundation
import UIKit



public class Prompt: NSObject {
    
    /// 管理所有的windows
    internal static var windows = Array<UIWindow?>()
    internal static let keyWindow = UIApplication.shared.keyWindow?.subviews.first as UIView?
    internal static var timer: DispatchSource!
    internal static var timerTimes = 0
    
    private override init() { }
}





extension Prompt {
    
    /// 创建Window
    /// - Parameters:
    ///   - respond: 交互类型
    ///   - frame: window的frame
    static func createWindow(frame: CGRect) -> UIWindow {
        
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        


        guard let keyWindow = keyWindow else { return window }

        
        window.frame = keyWindow.frame
        window.center = keyWindow.center
        window.windowLevel = UIWindow.Level.init(9999999)
        window.isHidden = false
        
        return window
    }
    
    /// 创建主视图区域
    static func createMainView(frame: CGRect) -> UIView {
        let mainView = UIView()
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        mainView.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: {
            mainView.alpha = 1
        })
        return mainView
    }
}

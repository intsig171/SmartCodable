//
//  UIDevice+Extension.swift
//  BTUIKit
//
//  Created by Mccc on 2020/4/14.
//


import UIKit
import BTNameSpace




fileprivate var mcScreenWidth: CGFloat?
fileprivate var mcScreenHeight: CGFloat?
fileprivate var mcStatusBarHeight: CGFloat?
fileprivate var mcTabBarHeight: CGFloat?
fileprivate var mcNavigationBarHeight: CGFloat?




extension UIDevice: NamespaceWrappable { }
    
//MARK: - 各种高度/宽度的获取
extension NamespaceWrapper where T == UIDevice {

    /// 屏幕的比例
    public static let scale: CGFloat  = UIScreen.main.scale
    
    ///屏幕宽（默认短的一边）(存疑，这样就没横竖屏的概念了)
    public static var width: CGFloat {

        if let temp = mcScreenWidth {
            return temp
        } else {
            let size = UIScreen.main.bounds.size
            let width = min(size.width, size.height)
            mcScreenWidth = width
            return width
        }
    }
   
    ///屏幕高（默认长的一边）(存疑，这样就没横竖屏的概念了)
    public static var height: CGFloat {

        if let temp = mcScreenHeight {
            return temp
        } else {
            let size = UIScreen.main.bounds.size
            let height = max(size.width, size.height)
            mcScreenHeight = height
            return height
        }
    }

    ///状态栏高度
    public static var statusBarHeight: CGFloat {
        if let temp = mcStatusBarHeight {
            return temp
        } else {
            var statusBarHeight: CGFloat = 0
            if #available(iOS 13.0, *) {
                let scene = UIApplication.shared.connectedScenes.first
                guard let windowScene = scene as? UIWindowScene else { return 0 }
                guard let statusBarManager = windowScene.statusBarManager else { return 0 }
                statusBarHeight = statusBarManager.statusBarFrame.height
            } else {
                statusBarHeight = UIApplication.shared.statusBarFrame.height
            }
            return statusBarHeight
        }
    }
    
    /// tabbar的高度
    public static var tabBarHeight: CGFloat {

        if let temp = mcTabBarHeight {
            return temp
        } else {
            let barHeight = 49 + bottomSafeAreaHeight
            mcTabBarHeight = barHeight
            return barHeight
        }
    }
    
    

    
    
    ///导航栏高度。将44获取拆出来，就叫
    public static var navigationBarHeight: CGFloat {

        if let temp = mcNavigationBarHeight {
            return temp
        } else {
            let barHeight = 44 + statusBarHeight
            mcNavigationBarHeight = barHeight
            return barHeight
        }
    }
    
    /// 顶部安全区域的高度 (20 / 44 / 47 / 59)
    public static var topSafeAreaHeight: CGFloat {
        UIDevice.safeAreaInsets().top
    }

    /// 底部安全区域 (0 or 34)
    public static var bottomSafeAreaHeight: CGFloat {
        UIDevice.safeAreaInsets().bottom
    }
}


//MARK: - 获取系统本身的一些信息
extension NamespaceWrapper where T == UIDevice {

    /// 版本号
    public static let appVersion =  Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    /// 构建号
    public static let appBuild      = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    /// app的名称
    public static let appName        = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    /// 工程名
    public static let appProjectName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""

    ///获取系统名称
    public static let systemName = UIDevice.current.systemName
    
    /// 获取设备名称 如 XXX的iphone
    public static let deviceUserName = UIDevice.current.name
}




//MARK: - 可以不关注。内部实现，为外部调用提供服务
extension UIDevice {
    
    fileprivate static func safeAreaInsets() -> (top: CGFloat, bottom: CGFloat) {
       
        // 既然是安全区域，非全面屏获取的虽然是0，但是毕竟有20高度的状态栏。也要空出来才可以不影响UI展示。
        let defalutArea: (CGFloat, CGFloat) = (20, 0)
        
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return defalutArea }
            guard let window = windowScene.windows.first else { return defalutArea }
            let inset = window.safeAreaInsets
            
            return (inset.top, inset.bottom)
            
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return defalutArea }
            let inset = window.safeAreaInsets
            return (inset.top, inset.bottom)

        } else {
            return defalutArea
        }
        
        
        
        
        
//        if #available(iOS 11.0, *) {
//            // safeAreaInsets 需要在iOS11里面
//            if let inset = UIApplication.shared.delegate?.window??.safeAreaInsets {
//
//                let top = inset.top
//
//                if top == 0 {
//                    return (20, inset.bottom)
//                } else {
//                    return (inset.top, inset.bottom)
//                }
//            } else {
//                return (20, 0)
//            }
//        } else {
//            return (20, 0)
//        }
    }
}

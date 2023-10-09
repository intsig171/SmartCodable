//
//  UIViewController+Extension.swift
//  GMJKExtension
//
//  Created by 满聪 on 2019/11/12.
//

import UIKit
import BTNameSpace


/** 待处理
 * 获取根控制器
 */

extension UIViewController: NamespaceWrappable { }
    


extension NamespaceWrapper where T: UIViewController {

    /// 获取当前控制器，少用！（内部实现使用了递归函数）
    public static func current(_ window: UIWindow? = UIApplication.shared.keyWindow) -> UIViewController? {
        if let vc = window?.rootViewController {
            return UIViewController.bt.findBest(vc: vc)
        } else {
            return nil
        }
    }
    
    private static func findBest(vc: UIViewController) -> UIViewController {
        if vc.presentedViewController != nil {
            return UIViewController.bt.findBest(vc: vc.presentedViewController!)
        } else if vc.isKind(of: UISplitViewController.self) {
            let svc = vc as! UISplitViewController
            if svc.viewControllers.count > 0 {
                return UIViewController.bt.findBest(vc: svc.viewControllers.last!)
            } else {
                return vc
            }
        } else if vc.isKind(of: UINavigationController.self) {
            let svc = vc as! UINavigationController
            if svc.viewControllers.count > 0 {
                return UIViewController.bt.findBest(vc: svc.topViewController!)
            } else {
                return vc
            }
        } else if vc.isKind(of: UITabBarController.self) {
            let svc = vc as! UITabBarController
            if (svc.viewControllers?.count ?? 0) > 0 {
                return UIViewController.bt.findBest(vc: svc.selectedViewController!)
            } else {
                return vc
            }
        } else {
            return vc
        }
    }
}



extension NamespaceWrapper where T: UIViewController {
    /// 获取模态跳转的最底层的控制器
    public func bottomestPresentedViewController() -> UIViewController {
        var bottomestVC = wrappedValue as UIViewController
        while bottomestVC.presentingViewController != nil {
            bottomestVC = bottomestVC.presentingViewController!
        }
        return bottomestVC
    }
    
    /// 获取模态跳转的最顶层的控制器
    public func topestPresentedViewController() -> UIViewController {
        var topestVC = wrappedValue as UIViewController
        while topestVC.presentedViewController != nil {
            topestVC = topestVC.presentedViewController!
        }
        return topestVC
    }
}


extension NamespaceWrapper where T: UIViewController {
    
    
    /// 获取当前控制器类名，去掉命名空间
    public func getClassName() -> String? {
        let mirro = Mirror(reflecting: wrappedValue)
        if let className = String(describing: mirro.subjectType).components(separatedBy: ".").first {
            return className
        }
        return nil
    }
}


/// 隐藏导航栏下的灰色线的协议
public protocol BTNavigationBarHairlineHideable: NSObjectProtocol {


    /// 隐藏
    /// - Parameter color: 传nil，直接隐藏。 传UIColor可以修改为对应的颜色
    func hideHairline(color: UIColor?)
    /// 恢复灰色线的展示
    func showHairline()
}

extension BTNavigationBarHairlineHideable where Self: UIViewController {

    public func hideHairline(color: UIColor?) {

        var image: UIImage? = UIImage()

        if let color = color {
            image = color.bt.makeImage()
        }

        self.navigationController?.navigationBar.shadowImage = image
        self.navigationController?.toolbar.setShadowImage(image, forToolbarPosition: .any)
        
        if #available(iOS 15.0, *) {
            let barApp = UINavigationBarAppearance()
            barApp.shadowColor = .clear
            barApp.backgroundColor = .white
            navigationController?.navigationBar.scrollEdgeAppearance = barApp
            navigationController?.navigationBar.standardAppearance = barApp
        }
    }

    public func showHairline() {
        self.navigationController?.navigationBar.shadowImage = nil
    }
}

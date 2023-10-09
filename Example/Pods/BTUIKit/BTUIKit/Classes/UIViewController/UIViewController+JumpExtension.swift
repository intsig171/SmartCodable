
//
//  UIViewController+Jump+Extension.swift
//  BTNameSpace
//
//  Created by Mccc on 2020/4/21.
//

import BTNameSpace


//MARK: - 模态跳转
extension NamespaceWrapper where T: UIViewController {
    /// 模态跳转方法
    /// - Parameters:
    ///   - targetViewController: 要跳转到的目标控制器
    ///   - style: 模态风格
    ///   - animated: 是否动画
    public func present(to targetViewController: UIViewController?,
                        style: UIModalPresentationStyle = .fullScreen,
                        animated:Bool = true) {
        
        guard let targetViewController = targetViewController else {
            return
        }
        targetViewController.modalPresentationStyle = style
        wrappedValue.present(targetViewController, animated: animated, completion: nil)
    }
}


//MARK: - 导航跳转
extension NamespaceWrapper where T: UIViewController {
    /// 导航跳转
    /// - Parameters:
    ///   - targetViewController: 要跳转的目标控制器
    ///   - animated: 是否动画
    public func push(to targetViewController: UIViewController?,
                     animated:Bool = true) {
        guard let targetViewController = targetViewController else {
            return
        }

        if wrappedValue.navigationController == nil {
            targetViewController.modalPresentationStyle = .fullScreen
            wrappedValue.present(targetViewController, animated: animated, completion: nil)
            wrappedValue.printLog(isJump: true, isNavigation: true)
        } else {
            wrappedValue.hidesBottomBarWhenPushed = true
            wrappedValue.navigationController?.pushViewController(targetViewController, animated: animated)
            let vcs = UIViewControllerJumpHelper.shared.vcs
            if vcs.contains(wrappedValue) {
                wrappedValue.hidesBottomBarWhenPushed = false
            } else {
                wrappedValue.hidesBottomBarWhenPushed = true
            }
        }
    }
}


//MARK: - 返回上一个控制器
extension NamespaceWrapper where T: UIViewController {
    
    
    /// 导航返回（Pop）
    /// - Parameters:
    ///   - targetViewController: 返回的目标控制器类名字符串（如果有相同的类型，只能跳转最上层一个），为nil即返回上一级
    ///   - animated: 是否动画
    public func pop(to targetViewController: String? = nil, animated: Bool = true) {
     
        /// 如果不存在目标控制器
        guard let tempVC = targetViewController else {
            if let tempNav = wrappedValue.navigationController {
                // 导航栈中至少有两个才能确定是导航跳转
                if tempNav.viewControllers.count > 1 {
                    tempNav.popViewController(animated: animated)
                    return
                }
                
                if let _ = tempNav.presentingViewController {
                    tempNav.dismiss(animated: animated, completion: nil)
                    wrappedValue.printLog(isJump: false, isNavigation: true)
                } else {
                    tempNav.popViewController(animated: animated)
                }
            } else {
                wrappedValue.dismiss(animated: animated, completion: nil)
                wrappedValue.printLog(isJump: false, isNavigation: true)
            }
            return
        }
        
        /// 目标控制器存在
        if let tempNav = wrappedValue.navigationController {
            //如果目标控制器存在于当前的stack中，直接pop到该控制器
            for vc: UIViewController in tempNav.viewControllers {
                if vc.bt.getClassName() == tempVC {
                    tempNav.popToViewController(vc, animated: animated)
                    return
                }
            }
            
            // 不在堆栈中，就直接pop上一级
            if tempNav.viewControllers.count > 1 {
                tempNav.popViewController(animated: animated)
                return
            }
            
            // 如果存在presentingViewController，就dismiss
            if let _ = tempNav.presentingViewController {
                tempNav.dismiss(animated: animated, completion: nil)
                wrappedValue.printLog(isJump: false, isNavigation: true)
            } else {
                tempNav.popViewController(animated: animated)
            }
        } else {
            wrappedValue.dismiss(animated: animated, completion: nil)
            wrappedValue.printLog(isJump: false, isNavigation: true)
        }
    }
    
    
    /// 模态返回（dismiss）
    /// - Parameters:
    ///   - targetViewController: 返回的目标控制器类名字符串（如果有相同的类型，只能跳转最上层一个），为nil即返回上一级
    ///   - animated: 是否动画
    public func dismiss(to targetViewController: String? = nil, animated: Bool = true) {
        
        /// 如果不存在目标控制器
        guard let tempVCString = targetViewController else {
            
            if let temp = wrappedValue.presentingViewController {
                temp.dismiss(animated: animated, completion: nil)
            } else {
                wrappedValue.navigationController?.popViewController(animated: animated)
                wrappedValue.printLog(isJump: false, isNavigation: false)
            }
            return
        }

        var previousVC = wrappedValue as UIViewController
        while previousVC.presentingViewController != nil {
            previousVC = previousVC.presentingViewController!
            
            if previousVC.bt.getClassName() == tempVCString {
                previousVC.dismiss(animated: animated, completion: nil)
                return
            }
            
            /// 有存在导航栏的present的情况
            if let nav = previousVC as? UINavigationController {
                for vc: UIViewController in nav.viewControllers {
                    if vc.bt.getClassName() == targetViewController {
                        nav.dismiss(animated: animated, completion: nil)
                        return
                    }
                }
            }
        }
        
        if let _ = wrappedValue.presentingViewController as? UINavigationController {
            wrappedValue.navigationController?.popViewController(animated: true)
            wrappedValue.printLog(isJump: false, isNavigation: false)
        } else {
            wrappedValue.dismiss(animated: animated, completion: nil)
        }
    }
}



//MARK: - 返回根控制器
extension NamespaceWrapper where T: UIViewController {

    /// 导航返回到根控制器
    /// - Parameter animated: 是否动画
    public func popToRootViewController(animated: Bool = true) {
        
        if let tempNav = wrappedValue.navigationController, tempNav.viewControllers.count > 1 {
            tempNav.popToRootViewController(animated: animated)
        } else {
            let vc = bottomestPresentedViewController()
            vc.dismiss(animated: animated, completion: nil)
            wrappedValue.printLog(isJump: false, isNavigation: true)
        }
    }
    
    
    /// 模态返回根控制器
    /// - Parameters:
    ///   - animated: 是否动画
    ///   - completion: 完成返回的闭包
    public func dismissToRootViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        
        let vc = bottomestPresentedViewController()
        
        if let _ = vc.presentingViewController {
            vc.dismiss(animated: animated, completion: completion)
        } else {
            wrappedValue.bt.pop()
        }
    }
    
    
    /// 处理混合跳转（模态&&导航），会采用遍历的方式，如无必要，尽量不要使用
    /// - Parameter completion: 完成返回的回调
    public func backToRootViewController(completion: (() -> Void)? = nil) {
        
        
        /// 获取根控制器
        guard let tempRootVC = UIApplication.shared.keyWindow?.rootViewController else {
            print("未获取到根控制器")
            completion?()
            return
        }

        var list: Array<UIViewController> = []
        
        var topViewController = tempRootVC
        while true {
            if topViewController.presentedViewController != nil {
                topViewController = topViewController.presentedViewController!
                list.append(topViewController)
            } else if topViewController.isKind(of: UINavigationController.self) {
                let nav = topViewController as? UINavigationController
                topViewController = (nav?.topViewController)!
            } else if topViewController.isKind(of: UITabBarController.self) {
                let tab = topViewController as? UITabBarController
                topViewController = (tab?.selectedViewController)!
            } else {
                break;
            }
        }
        
        if list.count == 0 {
            if let nav = wrappedValue as? UINavigationController {
                nav.popToRootViewController(animated: false)
            } else if wrappedValue.isKind(of: UIViewController.self) {
                wrappedValue.navigationController?.popToRootViewController(animated: false)
            }
            completion?()
            return;
        }
        
        for (index, vc) in list.enumerated().reversed() {
            if index == 0 {
                if vc.isKind(of: UINavigationController.self) {
                    (vc as? UINavigationController)?.popToRootViewController(animated: false)
                }
                vc.presentingViewController?.dismiss(animated: false, completion: completion)

                if let temp = vc.presentingViewController {
                    if temp.isKind(of: UINavigationController.self) {
                        (temp as? UINavigationController)?.popToRootViewController(animated: false)
                    }
                    
                    if temp.isKind(of: UITabBarController.self) {
                        let firstVC = (temp as! UITabBarController).viewControllers?.first
                          (firstVC as? UINavigationController)?.popToRootViewController(animated: false)
                    }
                }
                
                if vc.presentingViewController!.isKind(of: UINavigationController.self) {
                    (vc as? UINavigationController)?.popToRootViewController(animated: false)
                }

            } else {
                if vc.isKind(of: UINavigationController.self) {
                    (vc as? UINavigationController)?.popToRootViewController(animated: false)
                }
            }
        }
    }
}


extension UIViewController {
    
    func printLog(isJump: Bool, isNavigation: Bool) {
        
        var way1: String = ""
        var way2: String = ""

        
        switch (isJump, isNavigation) {
        case (true, true):
            way1 = "push"
            way2 = "present"
        case (true, false):
            way1 = "present"
            way2 = "push"
        case (false, true):
            way1 = "pop"
            way2 = "dismiss"
        case (false, false):
            way1 = "dismiss"
            way2 = "pop"
        }
        
        print("\n\n------Error!!!------")
        print("您选择的方式是 *\(way1)* 跳转，但是执行了 *\(way2)* 跳转。")
        print("请检查并修改正\n\n")
    }
    
}

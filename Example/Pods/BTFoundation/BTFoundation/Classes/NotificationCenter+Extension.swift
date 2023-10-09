//
//  Array+Extension.swift
//  BTFoundation
//
//  Created by Mccc on 2020/4/7.
//

import Foundation
import BTNameSpace


extension Notification: NamespaceWrappable { }

extension NamespaceWrapper where T == Notification {
    
    /// 通知名的前缀, 请拼接上去，防止重复
    public static let prefixName = "BT.Notification.Name."
}


extension NamespaceWrapper where T == Notification {

    /// 登录成功
    public static let login  = NSNotification.Name(prefixName + "login")
    
    /// 重新登录
    public static let reLogin  = NSNotification.Name(prefixName +  "reLogin")
    
    /// 登录失效
    public static let loginExpiry  = NSNotification.Name(prefixName +  "loginExpiry")
    
    /// 登录退出
    public static let logout  = NSNotification.Name(prefixName + "logout")
}


extension NamespaceWrapper where T == Notification {

    /// 接收到远程推送
    public static let remotePush = Notification.Name(prefixName + "remotePush")
    /// 刷新整个APP
    public static let reloadAll  = NSNotification.Name(prefixName + "reloadAll")
}



@objc extension NotificationCenter: NamespaceWrappable { }

extension NamespaceWrapper where T: NotificationCenter {
 
      /// 发送通知
      public static func post(_ name: Notification.Name, object: Any? = nil) {
          NotificationCenter.default.post(name: name, object: object, userInfo: nil)
      }
      
      /// 监听通知
      public static func addObserver(_ observer: Any, selector: Selector, _ name: Notification.Name?, object: Any? = nil) {
          NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
      }
      
      /// 移除通知
      public static func remove(_ observer: Any, name: Notification.Name?, object: Any? = nil) {
          NotificationCenter.default.removeObserver(observer, name: name, object: object)
      }
      
      /// 移除所有通知
      public static func removeAll(_ observer: Any) {
          NotificationCenter.default.removeObserver(observer)
      }
}

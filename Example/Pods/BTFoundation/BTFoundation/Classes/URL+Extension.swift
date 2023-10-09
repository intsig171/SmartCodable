//
//  URL+Extension.swift
//  BTFoundation
//
//  Created by qxb171 on 2020/5/15.
//

import Foundation
import BTNameSpace


extension URL: NamespaceWrappable { }

extension NamespaceWrapper where T == URL {
    
    
    /// 拨打电话
    /// - Parameters:
    ///   - number: 电话号码
    ///   - completeClosure: 拨打结果，成功 or 失败
    public static func callUp(with number: String, completeClosure: ((Bool) -> Void)? = nil) {
        
        let urlStr = "tel://\(number)"
        openUrlWithString(str: urlStr, completeClosure: completeClosure)
    }
    
    
    /// 跳转外部打开网页
    /// - Parameters:
    ///   - sting: 网址
    ///   - completeClosure: 是否成功打开
    public static func openWeb(with urlStr: String, completeClosure: ((Bool) -> Void)? = nil) {
        openUrlWithString(str: urlStr, completeClosure: completeClosure)
    }
    
    
    /// 去App Store评分
    /// - Parameters:
    ///   - AppId: appId
    ///   - completeClosure: 是否成功跳转
    public static func toAPPStoreScore(withId AppId: String, completeClosure: ((Bool) -> Void)? = nil) {
        let urlStr = "itms-apps://itunes.apple.com/app/id\(AppId)?action=write-review"
        
        openUrlWithString(str: urlStr, completeClosure: completeClosure)
    }
    
    
    /// 去App Store下载最新版本
    /// - Parameters:
    ///   - AppId: appId
    ///   - completeClosure: 是否成功跳转
    public static func toAPPStoreUpdate(withId AppId: String, completeClosure: ((Bool) -> Void)? = nil) {
        
        let urlStr = "itms-apps://itunes.apple.com/app/id\(AppId)"
        openUrlWithString(str: urlStr, completeClosure: completeClosure)
    }
}






/// 内部方法
fileprivate func openUrlWithString(str: String, completeClosure: ((Bool) -> Void)? = nil) {
    if let url = URL(string: str) {
        if UIApplication.shared.canOpenURL(url) {
            
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:]) { (success) in
                    if (success) {
                        completeClosure?(true)
                        return
                    }
                }
            } else {
                let success = UIApplication.shared.openURL(url)
                if (success) {
                    completeClosure?(true)
                    return
                }
            }
        }
    }
    completeClosure?(false)
}

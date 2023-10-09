//
//  UIWindow+Extension.swift
//  BTFoundation
//
//  Created by qixin on 2022/12/13.
//

import Foundation
import BTNameSpace

extension NamespaceWrapper where T == UIWindow {
    /// 获取当前的window
    public static var current: UIWindow? {
        if #available(iOS 13.0, *) {
            if let window =  UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first{
                return window
            }else if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return nil
            }
        } else {
            if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return nil
            }
        }
    }
}

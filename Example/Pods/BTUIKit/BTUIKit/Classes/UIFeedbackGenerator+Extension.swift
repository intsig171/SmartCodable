//
//  UIFeedbackGenerator+Extension.swift
//  BTNameSpace
//
//  Created by Mccc on 2020/5/8.
//

import Foundation
import BTNameSpace


/// 创建枚举
public enum FeedbackType: Int {
    
    /// 轻轻的
    case light
    /// 中等的
    case medium
    /// 重度的
    case heavy
    /// 成功的反馈
    case success
    /// 警告的反馈
    case warning
    /// 错误的反馈
    case error
    /// 无反馈
    case none
}

@available(iOS 10.0, *)
extension UIFeedbackGenerator: NamespaceWrappable { }


@available(iOS 10.0, *)
extension NamespaceWrapper where T == UIFeedbackGenerator {
    
    /// 创建类方法，随时调用
    public static func generate(style: FeedbackType) {
        switch style {
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        default:
            break
        }
    }
}


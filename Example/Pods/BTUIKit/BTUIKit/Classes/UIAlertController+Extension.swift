//
//  UIAlertController+Extension.swift
//  MCAPI
//
//  Created by MC on 2018/11/26.
//

import Foundation
import UIKit

import BTNameSpace

    

/** 待处理
 该模块待优化，需重新考虑实现方案
 */


extension NamespaceWrapper where T == UIAlertController {

    /// 在指定控制器上展示只有一个按钮的UIAlertController
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 副标题
    ///   - viewController: 在哪个控制器上展示
    ///   - actionTitle: 按钮文案
    ///   - confirm: 按钮闭包回调
    public static func show(title: String?,
                            message: String? = nil,
                            on viewController: UIViewController,
                            actionTitle: String = "我知道了",
                            confirm: ((UIAlertAction)->Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: actionTitle, style: .cancel, handler: confirm)
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }

    /// 在指定控制器上展示有两个按钮的UIAlertController
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 副标题
    ///   - vc: 在哪个控制器上显示
    ///   - actionTitle: 按钮文字
    ///   - actionCancelTitle: 取消按钮文字
    ///   - confirm: 按钮的闭包回调
    ///   - cancel: 取消按钮的闭包回调
    public static func confirm(title: String?,
                               message: String? = nil,
                               on vc: UIViewController,
                               actionTitle: String = "我知道了",
                               actionCancelTitle: String = "取消",
                               confirm: ((UIAlertAction)->Void)?,
                               cancel: ((UIAlertAction)->Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionCancelTitle, style: .cancel, handler: cancel))
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: confirm))
        vc.present(alert, animated: true)
    }

    
    /// 弹框列表 actionSheet
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 副标题
    ///   - vc: 在哪个控制器上显示
    ///   - items: 列表内容 [String]
    ///   - confirm: 点击列表内容Item的回调
    ///   - cancel: 取消按钮的回调
    public static func actionSheet(title: String,
                                   message: String? = nil,
                                   on vc : UIViewController,
                                   items:[String],
                                   confirm: ((Int,String) -> Void)?,
                                   cancel: ((UIAlertAction)->Void)? = nil) {
        /**
         *  actionSheet  在指定控制器上显示actionSheet（AlertAction根据数组数量决定）
         */
        
        let alter = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        let cancle = UIAlertAction.init(title: "取消", style: .cancel, handler: cancel)
        var index = 0
        for item in items {
            let i = index
            let confirm = UIAlertAction.init(title: item, style: UIAlertAction.Style.default) { (b) in
                confirm?(i,item)
            }
            alter.addAction(confirm)
            index += 1
        }
        alter.addAction(cancle)
        vc.present(alter, animated: true, completion: nil)
    }
    
    
    
    
    /// actionSheet  在指定控制器上显示拍照或者相册
    /// - Parameters:
    ///   - vc: 在哪个控制器上显示
    ///   - title: 标题
    ///   - message: 副标题
    ///   - photoName: 拍照功能按钮的标题
    ///   - libraryName: 相册功能按钮的标题
    ///   - hander: 回调
    public static func chooseImage(on vc: UIViewController,
                                      title: String = "选择图片",
                                      message: String? = nil,
                                      photoName: String = "拍照",
                                      libraryName: String = "相册",
                                      hander: ((String) -> Void)?) {
        
        let alter = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        
        let cancle = UIAlertAction.init(title: "取消", style: .cancel) { (b) in
            hander?("取消")
        }
        
        let photos = UIAlertAction.init(title: photoName, style: .default) { (b) in
            hander?("拍照")
        }
        
        let libraries = UIAlertAction.init(title: libraryName, style: .default) { (b) in
            hander?("相册")
        }
        
        alter.addAction(cancle)
        alter.addAction(photos)
        alter.addAction(libraries)
        
        vc.present(alter, animated: true, completion: nil)
    }
}


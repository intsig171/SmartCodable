//
//  UITableView+Empty.swift
//  BTFoundation
//
//  Created by 满聪 on 2020/6/12.
//

import Foundation
import BTNameSpace


extension NamespaceWrapper where T == UITableView {

    public func reloadData() {
        // 调用系统的reloadData
        
        wrappedValue.reloadData()
        
        /// reloadDate会在主队列执行，而dispatch_get_main_queue会等待机会，直到主队列空闲才执行。
        DispatchQueue.main.async {
            // 确保reloadData之后执行 （同步线程）
            let sections = wrappedValue.numberOfSections
            var isHiddenEmtpy: Bool = false
            
            /* 控制占空图隐藏与否
               sections为0个时，固定展示
               sections为1个时，判断tableview模式。为plain时判断是否有cell；为grouped时则隐藏
               sections大于1个时，固定隐藏
             */
            if sections == 0 {
                isHiddenEmtpy = false
            } else if sections == 1 {
                if wrappedValue.style == .plain {
                    let rows = wrappedValue.numberOfRows(inSection: 0)
                    if rows > 0 {
                        isHiddenEmtpy = true
                        
                    }
                } else {
                    isHiddenEmtpy = true
                }
            } else {
                isHiddenEmtpy = true
            }
            wrappedValue.backgroundView?.isHidden = isHiddenEmtpy
        }
    }
        
    /// 展示背景  空数据UI展示
    public func showBackground() {
        wrappedValue.backgroundView?.isHidden = false
    }
    
    /// 隐藏背景  空数据UI隐藏
    public func hideBackground() {
        wrappedValue.backgroundView?.isHidden = true
    }
}

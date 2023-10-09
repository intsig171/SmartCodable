//
//  UICollectionView+Empty.swift
//  BTFoundation
//
//  Created by 满聪 on 2020/6/17.
//


import BTNameSpace


extension NamespaceWrapper where T == UICollectionView {
    
    public func reloadData() {
        // 调用系统的reloadData
        wrappedValue.reloadData()
        
        let sections = wrappedValue.numberOfSections
        var isHiddenEmtpy: Bool = false
        if sections == 0 {
            isHiddenEmtpy = true
        } else if sections == 1 {
            for i in 0 ..< sections {
                let rows = wrappedValue.numberOfItems(inSection: i)
                if rows > 0 {
                    isHiddenEmtpy = true
                    break
                }
            }
        } else {
            isHiddenEmtpy = true
        }
        wrappedValue.backgroundView?.isHidden = isHiddenEmtpy
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

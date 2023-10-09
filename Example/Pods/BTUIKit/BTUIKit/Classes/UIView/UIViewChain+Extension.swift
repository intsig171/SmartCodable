//
//  UIViewChain+Extension.swift
//  BTNameSpace
//
//  Created by Mccc on 2020/4/21.
//

import UIKit
import BTNameSpace


import SnapKit


extension NamespaceWrapper where T: UIView {
    
    
    /** 链式UI的优势
     * 其一是比较简洁；
     * 其二是高复用性； 如何体现高复用性？
     * 其三是高可读性；
     * 应用链式语法可以减少中间变量；
     */
    
    
    /** 使用说明
     请将添加这个代码块。
     由于函数参数中只有一个闭包参数，所以会自动省略（），导致书写格式错乱。
     
     
     // 懒加载
     lazy var <#对象名#> = <#类名#>()
         .bt.add(toSuperView: <#superView#>)
         .bt.config ({
             $0.<#属性设置#>
         })
         .bt.layout ({
             $0.<#约束#>
         })
     
     
     // 局部初始化
     let <#对象名#> = <#类名#>()
         .bt.add(toSuperView: <#superView#>)
         .bt.config ({
             $0.<#属性设置#>
         })
         .bt.layout ({
             $0.<#约束#>
         })
     */
    
    
    
    /// 添加在视图
    /// - Parameter toSuperView: 父视图
    @discardableResult
    public func add(toSuperView: UIView) -> T {
        toSuperView.addSubview(wrappedValue)
        return wrappedValue
    }
    
    
    @discardableResult
    public func config(_ config: (T) -> Void) -> T {
        config(wrappedValue)
        return wrappedValue
    }

    @discardableResult
    public func layout(_ snapKitMaker: (ConstraintMaker) -> Void) -> T {
        wrappedValue.snp.remakeConstraints { (make) in
            snapKitMaker(make)
        }
        return wrappedValue
    }
}

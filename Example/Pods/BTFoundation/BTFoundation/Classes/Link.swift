//
//  Link.swift
//  BTFoundation
//
//  Created by qxb171 on 2020/6/11.
//



/** 声明
 由于不想引入过多的三方库，并且Then就十几行代码，所以直接复制过来了。
 以防以后可能的重复引用导致的冲突，所以改名为Link。
 版权声明：https://github.com/devxoul/Then
 */



import Foundation
import CoreGraphics

public protocol Link {}

extension Link where Self: Any {
    
    
    /// 使它可以在初始化和复制值类型之后使用闭包设置属性
    public func with(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }
    
    /// 使它可用来执行闭包
    public func `do`(_ block: (Self) throws -> Void) rethrows {
        try block(self)
    }
}

extension Link where Self: AnyObject {
    
    /// 使用它，可以在初始化后使用闭包设置属性
    public func link(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
    
}

extension NSObject: Link {}

extension CGPoint: Link {}
extension CGRect: Link {}
extension CGSize: Link {}
extension CGVector: Link {}
extension Array: Link {}
extension Dictionary: Link {}
extension Set: Link {}



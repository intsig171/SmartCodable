//
//  Namespace.swift
//  BTNamespace
//
//  Created by 满聪 on 2020/4/13.
//

/**
 通常我们使用命名空间都是基于一个具体的实例进行的二次封装（大家公认的）
 而封装的载体通常是struct，
 然后对struct进行extension
 */


public protocol NamespaceWrappable {
    associatedtype BTWrapperType
    var bt: BTWrapperType { get }
    static var bt: BTWrapperType.Type { get }
}

public extension NamespaceWrappable {
    var bt: NamespaceWrapper<Self> {
        return NamespaceWrapper(value: self)
    }

    static var bt: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}

public struct NamespaceWrapper<T> {
    public let wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}

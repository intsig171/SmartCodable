//
//  Array+Extension.swift
//  BTFoundation
//
//  Created by Mccc on 2020/4/7.
//

import Foundation
import BTNameSpace


extension DispatchQueue: NamespaceWrappable {}



extension DispatchTime: ExpressibleByIntegerLiteral {
    /// 延迟
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}

extension DispatchTime: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}

extension NamespaceWrapper where T == DispatchQueue {
    /// 确保主线程安全切换（ 如果' self '是主队列，当前线程是主线程，块将被立即调用，而不是被分派）
    public func safeAsync(_ block: @escaping ()->()) {
        if wrappedValue === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            wrappedValue.async { block() }
        }
    }
}

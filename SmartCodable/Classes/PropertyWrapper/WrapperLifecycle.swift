//
//  WrapperLifecycle.swift
//  SmartCodable
//
//  Created by qixin on 2025/2/25.
//

import Foundation


/// 作用于属性包装器的标识
protocol WrapperLifecycle {
    ///  被包裹的属性解码完成的回调，一般是遵循SmartDecode协议的model
    func wrappedValueDidFinishMapping() -> Self?
}

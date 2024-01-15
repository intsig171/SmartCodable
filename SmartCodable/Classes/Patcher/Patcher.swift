//
//  ValueCumulator.swift
//  SmartCodable
//
//  Created by Mccc on 2023/8/21.
//

import Foundation



/// 兼容器
struct Patcher<T: Decodable> {
    
    
    /// 尝试修补值
    /// - Parameters:
    ///   - mode: 修补模式
    ///   - decodeError: 解码错误
    ///   - originDict: 原始数据字典
    /// - Returns: 兼容之后的值（兼容失败，返回nil）
    static func tryPatch(_ mode: Mode, decodeError: DecodingError, originValue: Any?) -> T? {
        
        if mode == .none { return nil }
        
        // 支持类型兼容 & 当前解析错误是类型匹配错误
        if mode.supportTypeMismatch, case .typeMismatch(_, _) = decodeError {
            if let value = originValue, let value = TypePatcher<T>.tryPatch(value) {
                return value
            }
        } else if mode.supportDefaultValue {
            return DefaultPatcher.defalut()
        }
        
        return nil
    }
}

extension Patcher {
    /// 兼容模式
    enum Mode {
        /// 只兼容值类型不匹配
        case onlyTypeMismatch
        /// 只兼容默认值
        case onlyDefault
        /// 两者均兼容
        case all
        /// 不进行兼容
        case none
        
        var supportTypeMismatch: Bool {
            return self == .all || self == .onlyTypeMismatch
        }
        
        var supportDefaultValue: Bool {
            return self == .all || self == .onlyDefault
        }
    }
}


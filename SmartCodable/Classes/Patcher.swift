//
//  ValueCumulator.swift
//  SmartCodable
//
//  Created by Mccc on 2023/8/21.
//

import Foundation

/// 兼容器的类型
enum PatchMode {
    /// 只兼容值类型不匹配
    case typeMismatch
    /// 只兼容默认值
    case provideDefaultValue
    /// 两者均兼容
    case all
    /// 不进行兼容
    case none
    
    func isTypeMismatch() -> Bool {
        if self == .all || self == .typeMismatch {
            return true
        }
        return false
    }
    
    func isProvideDefaultValue() -> Bool {
        if self == .all || self == .provideDefaultValue {
            return true
        }
        return false
    }
}

/// 值修补器
struct Patcher<T: Decodable> {
    
    
    /// 尝试修补值
    /// - Parameters:
    ///   - mode: 修补模式
    ///   - decodeError: 解码错误
    ///   - originDict: 原始数据字典
    /// - Returns: 兼容之后的值（兼容失败，返回nil）
    static func tryPatch(_ mode: PatchMode, decodeError: DecodingError, originDict: [String: Any]?) -> T? {
     
        if mode == .none { return nil }
        
        switch decodeError {
        case .typeMismatch(_, let context):
            if mode.isTypeMismatch() {
                if let dict = originDict, let value = TypeCumulator<T>.compatible(context: context, originDict: dict) {
                    return value
                }
            }
        default:
            break
        }
        
        if mode.isProvideDefaultValue() {
            return try? DefaultValuePatcher.makeDefaultValue()
        }
        
        return nil
    }
}



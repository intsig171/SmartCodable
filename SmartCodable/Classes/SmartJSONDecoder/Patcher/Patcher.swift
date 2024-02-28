//
//  ValueCumulator.swift
//  SmartCodable
//
//  Created by Mccc on 2023/8/21.
//

import Foundation


extension Patcher {
    static func getType(v: Any) -> String {
        return String(describing: type(of: v))
    }
}

extension Patcher {
    
    /// 提供当前类型的默认值
    static func defaultForType() -> T? {
        return DefaultPatcher<T>.defalut()
    }
    
    static func convertToType(from value: Any?) -> T? {
        return TypePatcher<T>.tryPatch(value)
    }
    
    
    static func patchWithConvertOrDefault(value: Any?) -> T? {
        guard let value = value else { return nil }
        if let v = convertToType(from: value) { return v }
        if let v = defaultForType() { return v }
        return nil
    }
}


extension Patcher {
    
    
    
    static func tryPatch<T: Decodable>(mode: Mode, type: T.Type, value: Any, codingPath: [CodingKey]) throws -> T {
        let wantType = String(describing: type.self)
        let currentType = Patcher.getType(v: value)
                
        let error = DecodingError.typeMismatch(Bool.self, DecodingError.Context.init(codingPath: codingPath, debugDescription: "Expected to decode \(wantType) but found a \(currentType) instead."))
        /// 进行类型转换兼容
        if mode.supportTypeMismatch {
            if let temp: T = Patcher.tryPatch(.onlyTypeMismatch, decodeError: error, originValue: value) {
                return temp
            }
        }
        
        if mode.supportDefaultValue {
            if let defaultValue = DefaultPatcher<T>.defalut() {
                return defaultValue
            }
        }
        
        
        
        throw error
    }
}


/// 兼容器
struct Patcher<T: Decodable> {
    
    
    /// 尝试修补值
    /// - Parameters:
    ///   - mode: 修补模式
    ///   - decodeError: 解码错误
    ///   - originDict: 原始数据字典
    /// - Returns: 兼容之后的值（兼容失败，返回nil）
    static func tryPatch<T: Decodable>(_ mode: Mode, decodeError: DecodingError, originValue: Any?) -> T? {
        
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



extension CleanJSONKeyedDecodingContainer {
    
    /// key不存在，提供默认值，并输出日志。
    func decodeIfKeyNotFound<T>(_ key: Key, codingPath: [CodingKey] = []) throws -> T where T: Decodable {
        guard let value: T = Patcher.defaultForType() else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }
        return value
    }

    /// 值为null
    func decodeIfValueNotFound<T>(_ key: Key, codingPath: [CodingKey]) throws -> T where T: Decodable, T: Defaultable {
        guard let value: T = DefaultPatcher.defalut() else {
            throw DecodingError.Keyed.valueNotFound(CleanJSONKeyedDecodingContainer<Key>.self, codingPath: codingPath)
        }
        return value
    }
    
//    /// 值类型错误
//    func decodeIfTypeMismatch<T>(_ key: Key, codingPath: [CodingKey]) throws -> T where T: Decodable, T: Defaultable {
//        let value = self.decoder.topContainer
//        guard let adaptValue = TypePatcher<T>.tryPatch(value) {
//            throw DecodingError.Keyed.typeMismatch(<#T##Any#>, codingPath: <#T##[CodingKey]#>)
//        }
//        return adaptValue
//        
//        guard let value: T = DefaultPatcher.defalut() else {
//            throw DecodingError.Keyed.keyNotFound(key, codingPath: codingPath)
//        }
//        return value
//    }

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


//
//  KeyedDecodingContainer+Decode.swift
//  SmartCodable
//
//  Created by qixin on 2023/9/4.
//

import Foundation


// MARK: - KeyedDecodingContainer decode
extension KeyedDecodingContainer {
    public func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T : Decodable {
        return try explicitDecode(type, forKey: key)
    }
    
    public func decode(_ type: String.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> String {
        return try explicitDecode(type, forKey: key)
    }
    
    public func decode(_ type: Bool.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Bool {
        return try explicitDecode(type, forKey: key)
    }

    public func decode(_ type: Double.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Double {
        return try explicitDecode(type, forKey: key)
    }


    public func decode(_ type: Float.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Float {
        return try explicitDecode(type, forKey: key)
    }

    public func decode(_ type: Int.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int {
        return try explicitDecode(type, forKey: key)
    }


    public func decode(_ type: Int8.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int8 {
        return try explicitDecode(type, forKey: key)
    }


    public func decode(_ type: Int16.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int16 {
        return try explicitDecode(type, forKey: key)
    }


    public func decode(_ type: Int32.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int32 {
        return try explicitDecode(type, forKey: key)
    }


    public func decode(_ type: Int64.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int64 {
        return try explicitDecode(type, forKey: key)
    }
    
    public func decode(_ type: UInt.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt {
        return try explicitDecode(type, forKey: key)
    }

    public func decode(_ type: UInt8.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt8 {
        return try explicitDecode(type, forKey: key)
    }


    public func decode(_ type: UInt16.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt16 {
        return try explicitDecode(type, forKey: key)
    }


    public func decode(_ type: UInt32.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt32 {
        return try explicitDecode(type, forKey: key)
    }


    public func decode(_ type: UInt64.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt64 {
        return try explicitDecode(type, forKey: key)
    }
}



// MARK: - KeyedDecodingContainer decodeIfPresent
extension KeyedDecodingContainer {
    // 会导致循环引用
//    public func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable {
//        try smartDecode(type, forKey: key)
//    }
    
    
    public func decodeIfPresent<T>(_ type: [String: T].Type, forKey key: K) throws -> [String: T]? where T : Decodable {
        return optionalDecode(type, forKey: key)
    }
    
    public func decodeIfPresent<T>(_ type: [T].Type, forKey key: K) throws -> [T]? where T : Decodable {
        return optionalDecode(type, forKey: key)
    }
    
    public func decodeIfPresent(_ type: Date.Type, forKey key: K) throws -> Date? {
        return optionalDecode(type, forKey: key)
    }
    
    public func decodeIfPresent(_ type: Data.Type, forKey key: K) throws -> Data? {
        return optionalDecode(type, forKey: key)
    }
    
    public func decodeIfPresent(_ type: CGFloat.Type, forKey key: K) throws -> CGFloat? {
        return optionalDecode(type, forKey: key)
    }
    
    public func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        return optionalDecode(type, forKey: key)
    }

    public func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        return optionalDecode(type, forKey: key)
    }

    public func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? {
        return optionalDecode(type, forKey: key)
    }

    public func decodeIfPresent(_ type: Float.Type, forKey key: K) throws -> Float? {
        return optionalDecode(type, forKey: key)
    }

    public func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        return optionalDecode(type, forKey: key)
    }

    public func decodeIfPresent(_ type: Int8.Type, forKey key: K) throws -> Int8? {
        return optionalDecode(type, forKey: key)
    }

    public func decodeIfPresent(_ type: Int16.Type, forKey key: K) throws -> Int16? {
        return optionalDecode(type, forKey: key)
    }

    public func decodeIfPresent(_ type: Int32.Type, forKey key: K) throws -> Int32? {
        return optionalDecode(type, forKey: key)
    }

    public func decodeIfPresent(_ type: Int64.Type, forKey key: K) throws -> Int64? {
        return optionalDecode(type, forKey: key)
    }

    public func decodeIfPresent(_ type: UInt.Type, forKey key: K) throws -> UInt? {
        return optionalDecode(type, forKey: key)
    }

    public func decodeIfPresent(_ type: UInt8.Type, forKey key: K) throws -> UInt8? {
        return optionalDecode(type, forKey: key)
    }

    public func decodeIfPresent(_ type: UInt16.Type, forKey key: K) throws -> UInt16? {
        return optionalDecode(type, forKey: key)
    }

    public func decodeIfPresent(_ type: UInt32.Type, forKey key: K) throws -> UInt32? {
        return optionalDecode(type, forKey: key)
    }

    public func decodeIfPresent(_ type: UInt64.Type, forKey key: K) throws -> UInt64? {
        return optionalDecode(type, forKey: key)
    }
}



// MARK: - KeyedDecodingContainer 兼容
extension KeyedDecodingContainer {
    
    /// 可选解码的兼容处理
    /// 尝试兼容类型不匹配的情况。如果兼容失败，直接返回nil。
    func optionalDecode<T: Decodable>(_ type: T.Type, forKey key: Key) -> T? {
        do {
            let value = try smartDecode(type, forKey: key)
            return didFinishMapping(decodeValue: value)
        } catch let error as DecodingError {
            // 尝试进行类型兼容
            if let jsonValue = JSONValueFinder.findValue(decoder: try? superDecoder(), key: key) {
                if let value: T = Patcher.tryPatch(.onlyTypeMismatch, decodeError: error, originValue: jsonValue) {
                    return didFinishMapping(decodeValue: value)
                }
            }
            return nil
        } catch {
            return nil
        }
    }
    
    /// 完全的的兼容处理
    /// 尝试兼容类型不匹配的情况。如果兼容失败，尝试使用默认值填充，如果填充失败，抛出异常。
    fileprivate func explicitDecode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        // 无法解析的时候，尝试提供默认值，不得已再抛出异常（理论上不应该会抛出异常）
        do {
            let value = try smartDecode(type, forKey: key)
            return didFinishMapping(decodeValue: value)
        } catch let error as DecodingError {
            // 尝试进行类型兼容
            if let jsonValue = JSONValueFinder.findValue(decoder: try? superDecoder(), key: key) {
                if let value: T = Patcher.tryPatch(.all, decodeError: error, originValue: jsonValue) {
                    return didFinishMapping(decodeValue: value)
                }
            }
            
            // 尝试进行默认值兼容
            if let value: T = DefaultPatcher.defalut()  {
                return didFinishMapping(decodeValue: value)
            }
            
            // 抛出异常，不做处理。理论上不会出现这样的情况。
            throw error
        } catch {  // 非 DecodingError 类型的错误，如：Foundation.JSONError
            // 尝试进行默认值兼容
            if let value: T = DefaultPatcher.defalut()  {
                return didFinishMapping(decodeValue: value)
            }
            throw error
        }
    }
}



// MARK: - KeyedDecodingContainer support
extension KeyedDecodingContainer {
    
    // 底层的解码方法，核心功能是：拦截抛出的异常，抛给调用放处理。
    private func smartDecode<T: Decodable>(_ type: T.Type, forKey key: Key, isOptional: Bool = false) throws -> T {
        
        /** 解码兼容逻辑
         * 1. try decodeNil(forKey: key)
         *   - 抛出异常说明无此字段
         *   - 如果为true，说明是null
         *   - 如果为false，说明有值，但有可能是类型结果不一致的情况。
         * 2. try decodeIfPresent(type, forKey: key)
         *   - 抛出异常说明类型不匹配
         *   - nil的情况应该不存在。
         * 3. 汇总所有的异常，将error抛出，交给下级处理。
         *   - 如果是可选类型，只尝试类型转换的兼容，如果失败，就可以返回nil了。
         *   - 如果是非可以类型，先尝试类型转换兼容，再尝试填充该类型的默认值，如果失败抛出异常（理论上抛出异常的情况不存在，除非还有没兼容到的情况）。
         */
        do {
            let isNil = try decodeNil(forKey: key)
            if isNil { // 只有是null的时候会进来，类型错误的值，会返回false
                var paths = codingPath
                paths.append(key)
                let context = DecodingError.Context.init(codingPath: paths, debugDescription: " \(key.stringValue) 在json中对应的值是null")
                let error = DecodingError.valueNotFound(type, context)
                throw error
            } else {
                do {
                    if let v = try decodeIfPresent(type, forKey: key) {
                        return v
                    } else {
                        let error = DecodingError.valueNotFound(type, .init(codingPath: [key], debugDescription: "未找到有效值"))
                        throw error
                    }
                } catch {
                    throw error
                }
            }
        } catch let error as DecodingError {
            SmartLog.logError(error, className: getModelName())
            throw error
        } catch {
            throw error
        }
    }
    
    
    /// 当完成decode的时候，接纳didFinishMapping方法内的改变。
    fileprivate func didFinishMapping<T: Decodable>(decodeValue: T) -> T {
        if var value = decodeValue as? SmartDecodable {
            value.didFinishMapping()
            if let temp = value as? T {
                return temp
            }
        }
        
        // 如果使用了SmartOptional修饰，获取被修饰的属性。
        if var v = PropertyWrapperValue.getSmartObject(decodeValue: decodeValue) {
            v.didFinishMapping()
        }
        
        return decodeValue
    }
    

    /// 获取当前模型的名称
    fileprivate func getModelName() -> String? {
        if let superDe = try? superDecoder(), let key = CodingUserInfoKey.typeName, let info = superDe.userInfo[key] {
            return "\(info)"
        }
        return nil
    }
}


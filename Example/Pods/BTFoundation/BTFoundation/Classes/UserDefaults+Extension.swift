
//
//  UserDefaults+Extension.swift
//  BTFoundation
//
//  Created by Mccc on 2020/4/7.
//


import Foundation
import BTNameSpace



/** 使用说明
 * 可以在使用的地方继续添加扩展。
 * UserDefaults.Version.bt_set(value: "1", forKey: .version)
 * let _ = UserDefaults.Version.bt.getString(forKey: .version)
 */

public extension UserDefaults {
    
    /// 版本信息
    struct Version: UserDefaultsSettable {
        public enum defaultKeys: String {
            case version
            case build
        }
    }
}

public extension UserDefaults {
    /// 地理位置信息
    struct LocationInfo: UserDefaultsSettable {
        public enum defaultKeys: String {
            case latitude
            case longitude
            case country
            case province
            case city
            case area
            /// 详细地址
            case detail
            /// 全路径地址
            case address
        }
    }
}




public protocol UserDefaultsSettable {
    associatedtype defaultKeys: RawRepresentable
}

extension UserDefaultsSettable where defaultKeys.RawValue == String {
    
    
    static func getKey(key: defaultKeys) -> String {
        // 拼接上命名空间，防止key重复。
        let space = "\(self)"
        let aKey = key.rawValue
        return space + "." + aKey
    }
    
    
    /// 存储方法
    /// - Parameters:
    ///   - value: value值
    ///   - key: key值
    static public func set(value: Any?, forKey key: defaultKeys) {
        
        let aKey = getKey(key: key)
        UserDefaults.standard.set(value, forKey: aKey)
    }
    
    
    /// 取值方法
    /// - Parameter key: key值
    static public func getString(forKey key: defaultKeys) -> String? {
        let aKey = getKey(key: key)
        let value = UserDefaults.standard.string(forKey: aKey)
        return value
    }
    
    /// 取值方法
    /// - Parameter key: key值
    static public func getArray(forKey key: defaultKeys) -> [Any]? {
        let aKey = getKey(key: key)
        let value = UserDefaults.standard.array(forKey: aKey)
        return value
    }
    
    /// 取值方法
    /// - Parameter key: key值
    static public func getDictionary(forKey key: defaultKeys) -> [String: Any]? {
        let aKey = getKey(key: key)
        let value = UserDefaults.standard.dictionary(forKey: aKey)
        return value
    }
    
    /// 取值方法
    /// - Parameter key: key值
    static public func getBool(forKey key: defaultKeys) -> Bool? {
        let aKey = getKey(key: key)
        let value = UserDefaults.standard.bool(forKey: aKey)
        return value
    }

    
    /// 取值方法
    /// - Parameter key: key值
    static public func getData(forKey key: defaultKeys) -> Data? {
        let aKey = getKey(key: key)
        let value = UserDefaults.standard.data(forKey: aKey)
        return value
    }

    
    /// 取值方法
    /// - Parameter key: key值
    static public func getDouble(forKey key: defaultKeys) -> Double? {
        let aKey = getKey(key: key)
        let value = UserDefaults.standard.double(forKey: aKey)
        return value
    }

    
    /// 取值方法
    /// - Parameter key: key值
    static public func getInteger(forKey key: defaultKeys) -> Int? {
        let aKey = getKey(key: key)
        let value = UserDefaults.standard.integer(forKey: aKey)
        return value
    }

}


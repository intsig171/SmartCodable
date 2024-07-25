//
//  SmartUpdater.swift
//  SmartCodable
//
//  Created by qixin on 2024/5/30.
//

import Foundation


/** 关于upate的实现【临时的实现方案】
 1. 没有找到有效的泛型方法，主要是因为WritableKeyPath<T, K>的判断问题。WritableKeyPath<T, Int> 和 WritableKeyPath<T, Any> 并不是一个类型。
 2. 尝试了AnyKeyPath, 在使用AnyKeyPath.valueType(typeOf获取类型)，因为WritableKeyPath无法使用运行时类型，失败了。
 3. 尝试了泛型，反射等，都失败。
 4. 欢迎提供好的思路。
 */

public struct SmartUpdater<T: SmartCodable> {
    public static func update(_ src: inout T, from dict: [String: Any]?, designatedPath: String? = nil,  options: Set<SmartDecodingOption>? = nil) {
        
        guard let _dict = dict else {
            SmartLog.logVerbose("Expected to decode Dictionary but found nil instead.", in: "\(self)")
            return
        }
        
        guard let _data = getInnerData(inside: _dict, by: designatedPath) else {
            SmartLog.logVerbose("Expected to decode Dictionary but is cannot be data.", in: "\(self)")
            return
        }
        
        let srcDict = src.toDictionary()
        
        if let model = try? _data._deserializeDict(type: T.self, options: options, src:  srcDict) {
            src = model
        }
    }
    
    public static func update(_ src: inout T, from json: String?, designatedPath: String? = nil,  options: Set<SmartDecodingOption>? = nil) {
        
        guard let _json = json else {
            SmartLog.logVerbose("Expected to decode Dictionary but found nil instead.", in: "\(self)")
            return
        }
    
        guard let _data = getInnerData(inside: _json, by: designatedPath) else {
            SmartLog.logVerbose("Expected to decode Dictionary but is cannot be data.", in: "\(self)")
            return
        }
        
        let srcDict = src.toDictionary()
        
        if let model = try? _data._deserializeDict(type: T.self, options: options, src:  srcDict) {
            src = model
        }
    }
    
    public static func update(_ src: inout T, from data: Data?, designatedPath: String? = nil,  options: Set<SmartDecodingOption>? = nil) {
        
        guard let data = data else {
            SmartLog.logVerbose("Expected to decode Dictionary but found nil instead.", in: "\(self)")
            return
        }
        
        guard let _data = getInnerData(inside: data, by: designatedPath) else {
            SmartLog.logVerbose("Expected to decode Dictionary but is cannot be data.", in: "\(self)")
            return
        }
        
        let srcDict = src.toDictionary()
        
        if let model = try? _data._deserializeDict(type: T.self, options: options, src:  srcDict) {
            src = model
        }
    }
}

//public struct SmartUpdater<T> {
//    
//    public static func update<K1>(_ dest: inout T, from src: T, keyPath: Path<K1>) {
//        
//        dest[keyPath: keyPath] = src[keyPath: keyPath]
//    }
//    
//    public static func update<K1, K2>(_ dest: inout T, from src: T, keyPaths: Path2<K1, K2>) {
//        dest[keyPath: keyPaths.0] = src[keyPath: keyPaths.0]
//        dest[keyPath: keyPaths.1] = src[keyPath: keyPaths.1]
//    }
//    
//    public static func update<K1, K2, K3>(_ dest: inout T, from src: T, keyPaths: Path3<K1, K2, K3>) {
//        dest[keyPath: keyPaths.0] = src[keyPath: keyPaths.0]
//        dest[keyPath: keyPaths.1] = src[keyPath: keyPaths.1]
//        dest[keyPath: keyPaths.2] = src[keyPath: keyPaths.2]
//    }
//    
//    public static func update<K1, K2, K3, K4>(_ dest: inout T, from src: T, keyPaths: Path4<K1, K2, K3, K4>) {
//        dest[keyPath: keyPaths.0] = src[keyPath: keyPaths.0]
//        dest[keyPath: keyPaths.1] = src[keyPath: keyPaths.1]
//        dest[keyPath: keyPaths.2] = src[keyPath: keyPaths.2]
//        dest[keyPath: keyPaths.3] = src[keyPath: keyPaths.3]
//    }
//    
//    public static func update<K1, K2, K3, K4, K5>(_ dest: inout T, from src: T, keyPaths: Path5<K1, K2, K3, K4, K5>) {
//        dest[keyPath: keyPaths.0] = src[keyPath: keyPaths.0]
//        dest[keyPath: keyPaths.1] = src[keyPath: keyPaths.1]
//        dest[keyPath: keyPaths.2] = src[keyPath: keyPaths.2]
//        dest[keyPath: keyPaths.3] = src[keyPath: keyPaths.3]
//        dest[keyPath: keyPaths.4] = src[keyPath: keyPaths.4]
//    }
//    
//    public static func update<K1, K2, K3, K4, K5, K6>(_ dest: inout T, from src: T, keyPaths: Path6<K1, K2, K3, K4, K5, K6>) {
//        dest[keyPath: keyPaths.0] = src[keyPath: keyPaths.0]
//        dest[keyPath: keyPaths.1] = src[keyPath: keyPaths.1]
//        dest[keyPath: keyPaths.2] = src[keyPath: keyPaths.2]
//        dest[keyPath: keyPaths.3] = src[keyPath: keyPaths.3]
//        dest[keyPath: keyPaths.4] = src[keyPath: keyPaths.4]
//        dest[keyPath: keyPaths.5] = src[keyPath: keyPaths.5]
//    }
//    
//    public static func update<K1, K2, K3, K4, K5, K6, K7>(_ dest: inout T, from src: T, keyPaths: Path7<K1, K2, K3, K4, K5, K6, K7>) {
//        dest[keyPath: keyPaths.0] = src[keyPath: keyPaths.0]
//        dest[keyPath: keyPaths.1] = src[keyPath: keyPaths.1]
//        dest[keyPath: keyPaths.2] = src[keyPath: keyPaths.2]
//        dest[keyPath: keyPaths.3] = src[keyPath: keyPaths.3]
//        dest[keyPath: keyPaths.4] = src[keyPath: keyPaths.4]
//        dest[keyPath: keyPaths.5] = src[keyPath: keyPaths.5]
//        dest[keyPath: keyPaths.6] = src[keyPath: keyPaths.6]
//    }
//}
//
//extension SmartUpdater {
//    public typealias Path<K> = WritableKeyPath<T, K>
//    public typealias Path2<K1, K2> 
//    = (Path<K1>, Path<K2>)
//    public typealias Path3<K1, K2, K3>
//    = (Path<K1>, Path<K2>, Path<K3>)
//    public typealias Path4<K1, K2, K3, K4>
//    = (Path<K1>, Path<K2>, Path<K3>, Path<K4>)
//    public typealias Path5<K1, K2, K3, K4, K5>
//    = (Path<K1>, Path<K2>, Path<K3>, Path<K4>, Path<K5>)
//    public typealias Path6<K1, K2, K3, K4, K5, K6>
//    = (Path<K1>, Path<K2>, Path<K3>, Path<K4>, Path<K5>, Path<K6>)
//    public typealias Path7<K1, K2, K3, K4, K5, K6, K7>
//    = (Path<K1>, Path<K2>, Path<K3>, Path<K4>, Path<K5>, Path<K6>, Path<K7>)
//    
//}



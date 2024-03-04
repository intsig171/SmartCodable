//
//  DecodingProcessCoordinator.swift
//  SmartCodable
//
//  Created by qixin on 2024/3/4.
//

import Foundation


struct DecodingProcessCoordinator {
    static func didFinishMapping<T: Decodable>(_ decodeValue: T) -> T {
        if var value = decodeValue as? SmartDecodable {
            value.didFinishMapping()
            if let temp = value as? T {
                return temp
            }
        }

        // 如果使用了SmartOptional修饰，获取被修饰的属性。
//        if var v = PropertyWrapperValue.getSmartObject(decodeValue: decodeValue) {
//            v.didFinishMapping()
//        }

        return decodeValue
    }

}

//
//  FieldNameMapViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2023/8/8.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


/** 演示字段映射
 * 1. 单个字段映射成模型字段。
 * 2. 多个字段映射成模型字段。
 * 3. 多个字段在数据中有存在时，使用第一个字段。
 * 4. 兼容映射失败的情况。
 
 */

class FieldNameMapViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 1. 单字段映射
        guard let xiaoMing = FieldNameMapSingle.deserialize(dict: getFieldNameMapSingle()) else { return }
        print("xiaoMing.name = \(xiaoMing.name)")
        print("xiaoMing.className = \(xiaoMing.className)")
        
        // 2. 多字段映射
        guard let daHuang1 = FieldNameMapDouble.deserialize(dict: getFieldNameMapDouble()) else { return }
        print("daHuang1.name = \(daHuang1.name)")
        print("daHuang1.className = \(daHuang1.className)")
    }
}


extension FieldNameMapViewController {
    func getFieldNameMapSingle() -> [String: Any] {
        let dict = [
            "name": "xiaoming",
            "class_name": "35班"
        ] as [String : Any]
        
        return dict
    }
    
    // 1. 单个字段映射成模型字段。
    struct FieldNameMapSingle: SmartCodable {
        
        var name: String = ""
        var className: String = ""
        
        /// 字段映射
        static func mapping() -> JSONDecoder.KeyDecodingStrategy? {
            .mapper([
                "class_name": "className",
            ])
        }
    }
}




extension FieldNameMapViewController {
    func getFieldNameMapDouble() -> [String: Any] {
        let dict = [
            "personName": "大黄",
            "className": "1班"
        ] as [String : Any]
        
        return dict
    }
    
    struct FieldNameMapDouble: SmartCodable {
        
        var name: String = ""
        var className: String = ""
        
        /// 字段映射
        static func mapping() -> JSONDecoder.KeyDecodingStrategy? {
            // 支持多余值的兼容，相同值的兼容
            // 数据中有 两个 映射字段到同一个属性值，由于是解析的字典（无序），所以具体使用哪个值。
            .mapper([
                ["class_name", "other1", "other1", "className"]: "className",
                ["personName"]: "name"
            ])
        }
    }
    
}







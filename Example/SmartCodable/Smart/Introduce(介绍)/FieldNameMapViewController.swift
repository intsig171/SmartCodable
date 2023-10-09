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
        
        
        // 1. 单个字段映射成模型字段。
        guard let xiaoMing = FieldNameMapOne.deserialize(dict: getFieldNameMapOne()) else { return }
        print("xiaoMing.name = \(xiaoMing.name)")
        print("xiaoMing.className = \(xiaoMing.className)")
        
        
        guard let daHuang1 = FieldNameMapTwo.deserialize(dict: getFieldNameMapTwo()) else { return }
        print("daHuang1.name = \(daHuang1.name)")
        print("daHuang1.className = \(daHuang1.className)")
        
        
        // 验证两个都存在的字段
        guard let xiaoNiu = FieldNameMapThree.deserialize(dict: getFieldNameMapThree()) else { return }
        print("xiaoNiu.name = \(xiaoNiu.name)")
        print("xiaoNiu.className = \(xiaoNiu.className)")
    }
}


extension FieldNameMapViewController {
    func getFieldNameMapOne() -> [String: Any] {
        let dict = [
            "name": "xiaoming",
            "class_name": "35班"
        ] as [String : Any]
        
        return dict
    }
    
    // 1. 单个字段映射成模型字段。
    struct FieldNameMapOne: SmartCodable {
        
        var name: String = ""
        var className: String = ""
        
        /// 字段映射
        static func mapping() -> JSONDecoder.KeyDecodingStrategy? {
            .mapper([
                ["class_name"]: "className",
                
                // 如果映射失败 或 无映射值，就使用原始key。
                []: "name"
            ])
        }
    }
}




extension FieldNameMapViewController {
    func getFieldNameMapTwo() -> [String: Any] {
        let dict = [
            "personName": "大黄",
            "className": "1班"
        ] as [String : Any]
        
        return dict
    }
    
    struct FieldNameMapTwo: SmartCodable {
        
        var name: String = ""
        var className: String = ""
        
        /// 字段映射
        static func mapping() -> JSONDecoder.KeyDecodingStrategy? {
            // 支持多余值的兼容，相同值的兼容
            .mapper([
                ["class_name", "other1", "other1", "className"]: "className",
                ["personName"]: "name"
            ])
        }
    }
    
}



extension FieldNameMapViewController {
    func getFieldNameMapThree() -> [String: Any] {
        let dict = [
            "name2": "小牛",
            "name1": "大牛",
            "className": "35"
        ] as [String : Any]
        
        return dict
    }
    
    struct FieldNameMapThree: SmartCodable {
        
        var name: String = ""
        var className: String = ""
        
        /// 字段映射
        static func mapping() -> JSONDecoder.KeyDecodingStrategy? {
            .mapper([
                // 支持多余值的兼容，相同值的兼容
                // 返回中有 两个 映射到同一个值。由于是解析的字典（无序），所以具体使用哪个值，不能确定。
                ["personName", "first_name"]: "name",
                ["name1", "name2"]: "name"
            ])
        }
    }
}







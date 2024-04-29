//
//  TestViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/9/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SmartCodable
import HandyJSON
import CleanJSON
import BTPrint


/** todo
 1. 【done】issue，数组model属性（或非model的数组），遇到json str。
 2. 【done】其他类型新增解析策略
 3. 【done】验证解析失败使用初始值的场景。并看看value的自定义解析策略。
 4. 【done】SmartAny的解析失败的验证。
 5. 关联值的解析支持。
 
 */


class TestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode = .debug
        let dict: [String: Any] = [
            "age": "Mccc",
            "address": "aHR0cHM6Ly93d3cucWl4aW4uY29t"
        ]
        guard let model = Family.deserialize(from: dict) else { return }
        print(model)
        
        if let data = model.location, let dataStr = String(data: data, encoding: .utf8) {
            print(dataStr)
            // https://www.qixin.com
        }

    }
}
extension TestViewController {
    struct Family: SmartCodable {
        var name: String = "我的家"
        var location: Data?

        static func mappingForKey() -> [SmartKeyTransformer]? {
            [
                CodingKeys.name <--- "age",
                CodingKeys.location <--- "address",
            ]
        }
        
        static func mappingForValue() -> [SmartValueTransformer]? {
            [
                CodingKeys.location <--- SmartDataTransformer()
            ]
        }
    }

    
}

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
        
        let dict: [String: Any] = [
            "age": 10,
            "name": "Mccc",
            "area": "su zhou"
        ]
        
        if let model = Home.deserialize(from: dict) {
            print(model)
            let dict = model.toDictionary() ?? [:]
            print(dict)
        }
    }
}
struct Home: SmartCodable {
    var name: String = ""
    @Ignored
    var age: Any?
    @Ignored
    var area: String = "area"
}

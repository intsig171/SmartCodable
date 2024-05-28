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

import SmartCodable

class TestViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 浮点数的异常数据（Nan & inf）处理，不再提供demo。
        /// 底层将这两个值当成了字符串处理，遇到了就提供默认值。

        
        let dict: [String: Any] = [
//            "name": "Mccc",
            "age": "10",
//            "love": "{\"age\":15}",
//            "loves": "[{\"selfAge\": 20},{\"selfAge\": 20}]"
        ]
        
        if let model = JSONStringModel.deserialize(from: dict) {
            print(model)
        }
    }
    
    struct JSONStringModel: SmartCodable {
//        var name: String = ""
        var age: Int = 0
//        var love: Love = Love()
//        var loves: [Love] = []
        
//        static func mappingForKey() -> [SmartKeyTransformer]? {
//            [
//                CodingKeys.age <--- "selfAge"
//            ]
//        }
//        
//        func didFinishMapping() {
//            print("JSONStringModel中的age值为", age)
//        }
    }
    
    struct Love: SmartCodable {
        var age: Int = 0
        
        static func mappingForKey() -> [SmartKeyTransformer]? {
            [
                CodingKeys.age <--- "selfAge"
            ]
        }
        
//        func didFinishMapping() {
//            print("Love中的age值为", age)
//        }
    }
}

//
//  CaseThree_ArrViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable

class CaseThree_ArrViewController: BaseCompatibilityViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 浮点数的异常数据（Nan & inf）处理，不再提供demo。
        /// 底层将这两个值当成了字符串处理，遇到了就提供默认值。

        
        let dict: [String: Any] = [
            "a": "0",
            "b": "Mccc",
            "c": [:],
            "d": NSNull(),
            "e": [1, 2, 3, 4],
            "f": [1, 2, 3, 4, "好的"]
        ]

        
        
        if let model = ArrayModel.deserialize(from: dict) {
            print(model)
            print(model.f.peel)
        }
    }
    
    struct ArrayModel: SmartCodable {
        var a: [SmartAny]?
        var b: [SmartAny]?
        var c: [SmartAny]?
        var d: [SmartAny]?
        var e: [SmartAny]?
        var f: [SmartAny] = []
    }
}

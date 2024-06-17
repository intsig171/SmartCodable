//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import HandyJSON


import SmartCodable

class Test2ViewController: BaseViewController {


    override func viewDidLoad() {
            super.viewDidLoad()
                    
            let dict: [String: Any] = [
                "code": [1, 200, "300"],
                "data": [
                    "name": "mccc",
                    "height": NSNull(),
                    "id": 1802527796438790146,
                    "icon": "1231231122",
                    "r1": 0,
                    "dis": 321123,
                ],
                "msg": "success"
            ]
            
            if let model = demo.deserialize(from: dict) {
                print(model.code as Any)
                print(model.msg as Any)
                print(model.data as Any)
            }
            
            
        }
            
        struct demo: SmartCodable {
            @SmartAny
            public var code: [Any]?
            @SmartAny
            public var msg: Any?
            @SmartAny
            public var data: [String: Any]?
        }
}


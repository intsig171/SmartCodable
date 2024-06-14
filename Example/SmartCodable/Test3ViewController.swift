//
//  Test3ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/18.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import HandyJSON



class Test3ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: [String: Any] = [
            "name": true,
//            "dict": NSNull(),
//            "dict": [
//                "name": "mccc"
//            ],
            "arr": [1, 2, 3]
        ]
        
        if let model = Model.deserialize(from: dict) {
            print(model.toJSONString(prettyPrint: true) ?? "")
        }
    }
    
    struct Model: SmartCodable {
//        @SmartAny
//        var name: Any?
        @IgnoredKey
        var dict: [String: Any] = ["name": "Mccc"]
//        @SmartAny
//        var arr: [Any] = []
    }
}



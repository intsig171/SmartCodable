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





class Test2ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var src = Model(name: "麒麟", age: 3, sub: [SubModel(name: "小麒麟", age: 6)])
        let dict: [String: Any] = [
            "name": "更新值",
            "sub": [
                [
                    "name": "sub更新值",
//                    "age": 100
                ]
            ]
        ]
        
        SmartUpdater.update(&src, from: dict)
        smartPrint(value: src)
    }
    
    struct Model: SmartCodable {
        var name: String = "init"
        var age: CGFloat = 1
        var sub: [SubModel] = []
    }
    
    struct SubModel: SmartCodable {
        var name: String = "subinit"
        var age: CGFloat = 1
    }
}

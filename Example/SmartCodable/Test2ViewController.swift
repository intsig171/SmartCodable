//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SmartCodable
import BTPrint

class Test2ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dict: [String: Any] = [
            "subs": [
                [
                    "name": "Mccc"
                ],
                [
                    "name": "Mccc1"
                ]
            ],
            "name": "qilin",
        ]
        if let model = Model.deserialize(from: dict) { }
    }
}

struct Model: SmartCodable {
    var subs: [SubModel]?
    var name: String = "init"
    func didFinishMapping() {
        print("执行了Model的 方法")
    }
}

struct SubModel: SmartCodable {
    var name: String = "init"
    func didFinishMapping() {
        print("执行了SubModel的 方法")
    }
}

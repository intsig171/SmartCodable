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
import BTPrint




class Test2ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dic: [String : Any] = [
            "a1": "1111",
            "a2": 11111,
            "a3": [
                "b1": "2222",
                "b2": 2222,
                "b3": [1, 2, 3]
            ]
        ]
        let dic2: [String : Any] = [
            "a2": 2222,
            "a3": [
                "b3": [100, 200, 300]
            ]
        ]
        
        guard var model = Model.deserialize(from: dic) else { return }
        
        
        let json2 = dic2.bt_toJSONString()
        
        SmartUpdater.update(&model, from: json2)
        smartPrint(value: model)
    }
    struct Model: SmartCodable {
        var a1: String = ""
        var a2: Int = 0
        var a3: SubModel = SubModel()
    }
    
    struct SubModel: SmartCodable {
        var b1: String = ""
        var b2: Int = 0
        var b3: [Int] = []
    }
}

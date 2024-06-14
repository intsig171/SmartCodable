//
//  Container_DictViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/5/20.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation



import SmartCodable

/// 兼容Int类型，只兼容String类型的int值。
class Container_DictViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        let dict: [String: Any] = [
            
            "dict2": NSNull(),
            "dict3": [
                "key1": 123,
                "key2": "123",
                "key3": [1, 2, 3]
            ],
            
            "dict5": NSNull(),
            "dict6": [
                "name": "Mccc"
            ],
            
            
            "sub2": NSNull(),
            "sub3": [
                "name": "Mccc"
            ],
            
            "sub5": NSNull(),
            "sub6": [
                "name": "Mccc"
            ]
        ]
        
        guard let feed = Model.deserialize(from: dict) else { return }
        smartPrint(value: feed)
    }

}
extension Container_DictViewController {
    struct Model: SmartCodable {
        
        var dict1: [String: String] = [:]
        var dict2: [String: String] = [:]
        @SmartAny
        var dict3: [String: Any] = [:]
        
        
        var dict4: [String: String]?
        var dict5: [String: String]?
        var dict6: [String: String]?
        
        var sub1 = SubModel()
        var sub2 = SubModel()
        var sub3 = SubModel()
        
        var sub4: SubModel?
        var sub5: SubModel?
        var sub6: SubModel?
//
    }
    
    struct SubModel: SmartCodable {
        var name: String = ""
    }
}




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
            "sub2": NSNull(),
            "sub3": "123.1",
            
            "dict2": NSNull(),
            "dict3": [:]
        ]
        
        guard let feed = Model.deserialize(from: dict) else { return }
        print(feed)
    }

}
extension Container_DictViewController {
    struct Model: SmartCodable {
        
        var dict1: [String: String] = [:]
//        var dict2: [String: String] = [:]
//        var dict3: [String: String] = [:]
        
//        var sub1 = SubModel()
//        var sub2 = SubModel()
//        var sub3 = SubModel()
//        
    }
    
    struct SubModel: SmartCodable {
        var name: String = ""
    }
}




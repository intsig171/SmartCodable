//
//  CaseOne_DictViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/5/20.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation



import SmartCodable

/// 兼容Int类型，只兼容String类型的int值。
class CaseOne_DictViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        let dict: [String: Any] = [
            "sub2": NSNull(),
            "sub3": "123.1",
            
            "arr2": NSNull(),
            "arr3": []
        ]
        
        guard let feed = Model.deserialize(from: dict) else { return }
        print(feed)
    }

}
extension CaseOne_DictViewController {
    struct Model: SmartCodable {
        var sub1 = SubModel()
        var sub2 = SubModel()
        var sub3 = SubModel()
        
        var arr1: [SubModel] = []
        var arr2: [SubModel] = []
        var arr3: [SubModel] = []
    }
    
    struct SubModel: SmartCodable {
        var name: String = ""
    }
}




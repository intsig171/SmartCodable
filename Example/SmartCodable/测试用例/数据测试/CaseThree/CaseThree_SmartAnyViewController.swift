//
//  CaseThree_DictViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable

class CaseThree_SmartAnyViewController: BaseCompatibilityViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: [String: Any] = [
            "a": NSNull(),
            "b": "Mccc",
            "c": [],
            "d": NSNull(),
            "e": [:],
            "f": [
                "key": "value123"
            ],
            
            
            "arr1": "0",
            "arr2": "Mccc",
            "arr3": [:],
            "arr4": NSNull(),
            "arr5": [1, 2, 3, 4],
            "arr6": [1, 2, 3, 4, "好的"]
        ]
  
//        if let model = dict.decode(type: DictModel.self) {
//            print(model)
//        }
        
        if let model = DictModel.deserialize(from: dict) {
            print(model)
            print(model.f.peel)
        }
    }
}


extension CaseThree_SmartAnyViewController {
    struct DictModel: SmartCodable {
        var a: Bool?
        var b: [String: SmartAny]?
        var c: [String: SmartAny]?
        var d: [String: SmartAny]?
        var e: [String: SmartAny]?
        var f: [String: SmartAny] = [:]
        
        var arr1: [SmartAny]?
        var arr2: [SmartAny]?
        var arr3: [SmartAny]?
        var arr4: [SmartAny]?
        var arr5: [SmartAny]?
        var arr6: [SmartAny] = []
    }
}

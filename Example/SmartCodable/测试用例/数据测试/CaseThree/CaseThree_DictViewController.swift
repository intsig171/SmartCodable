//
//  CaseThree_DictViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable

class CaseThree_DictViewController: BaseCompatibilityViewController {

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
            ]
        ]
  
//        if let model = dict.decode(type: DictModel.self) {
//            print(model)
//        }
        
        if let model = DictModel.deserialize(dict: dict) {
            print(model)
            print(model.f.peel)
        }
    }
}


extension CaseThree_DictViewController {
    struct DictModel: SmartCodable {
        var a: Bool?
        var b: [String: SmartAny]?
        var c: [String: SmartAny]?
        var d: [String: SmartAny]?
        var e: [String: SmartAny]?
        var f: [String: SmartAny] = [:]
    }
}

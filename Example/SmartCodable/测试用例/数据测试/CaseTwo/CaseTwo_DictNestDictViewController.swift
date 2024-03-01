//
//  CaseTwo_DictNestDictViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import SmartCodable

class CaseTwo_DictNestDictViewController: BaseCompatibilityViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let dict: [String: Any] = [
            "name": "father",
            "age": 30,
            "love": [
                "name": "basketball",
                "time": 10
            ],
            "son": [
                "name": "son",
                "age": 4,
                "love": [
                    "name": "sleep",
                    "time": 4
                ],
            ]
        ]

       
        if let model = FatherModel.deserialize(dict: dict) {
            print(model)
        }
    }

}


extension CaseTwo_DictNestDictViewController {
    struct FatherModel: SmartCodable {
        var name: String = ""
        var age: Int = 0
        var love: Love = Love()
        var son: SonModel = SonModel()
    }
    
    struct SonModel: SmartCodable {
        var name: String?
        var age: Int?
        var love: Love?
    }
    
    struct Love: SmartCodable {
        var name: String = ""
        var time: CGFloat = 0.0
    }
}

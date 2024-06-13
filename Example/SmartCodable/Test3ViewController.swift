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
            "name": "Mccc",
            "sub": [
                "selfAge": 10
            ]
        ]
        
        if let model = Model.deserialize(from: dict) {
            print("执行了")
            print(model)
        }
    }
    
    struct Model: SmartCodable {
        var nickName: String = ""
        var sub: SubModel = SubModel()

        
        static func mappingForKey() -> [SmartKeyTransformer]? {
            [
                CodingKeys.nickName <--- "name"
            ]
        }
    }
    
    struct SubModel: SmartCodable {
        var age: Int = 0
        static func mappingForKey() -> [SmartKeyTransformer]? {
            [
                CodingKeys.age <--- "selfAge"
            ]
        }
    }
    
    
}



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
//            "name": "Mccc",
//            "age": NSNull(),
            "sex": 123
        ]
        
        if let model = Model.deserialize(from: dict) {
            print(model)
        }
    }
    
    struct Model: SmartCodable {
//        var name: String = ""
//        var age: String = "Mccc"
        var sex: Bool?
    }
    
    
}



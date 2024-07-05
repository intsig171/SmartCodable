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
import CleanJSON




class Test3ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode = .none
        
        let dict: [String: Any] = [
            "key": 5.1,
            "key1":5.2,
            "key2": 1.99,
            "key3": 4.99,
            "key4": 99.99,
        ]
        if let model = Model.deserialize(from: dict) {
            smartPrint(value: model)
        }
    }
    
    struct Model: SmartCodable {
        var key: String = ""
        var key1: String = ""
        var key2: String = ""
        var key3: String = ""
        var key4: String = ""
    }
}





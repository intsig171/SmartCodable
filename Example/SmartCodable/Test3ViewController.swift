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
            "int": "11",
            "int8": "12",
            "uInt": "13",
            "uInt8": "14",
        ]

        
        if let model = IntModel.deserialize(from: dict) {
            print(model)
        }
    }
    
    
    struct IntModel: SmartCodable {
        var int: Int = 0
        var int8: Int8 = 0
        var uInt: UInt = 0
        var uInt8: UInt8 = 0
    }
}


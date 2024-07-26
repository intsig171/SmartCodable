//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import HandyJSON





class Test2ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dic: [String : Any] = [
            "timestamp": "1721721316"
        ]
        
        let model = Model.deserialize(from: dic)
        smartPrint(value: model)
        
        
        
    }
    struct Model: SmartCodable {
        var timestamp: UInt32?
    }
}

//
//  TestViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/9/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SmartCodable
import HandyJSON
import CleanJSON
import BTPrint

import SmartCodable

class TestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let dict: [String: Any] = [
            "data": NSNull(),
//            "data": 1802527796438790146,
        ]
        
        if let model = Model.deserialize(from: dict) {
            print(model.data)
        }
    }
    
    struct Model: SmartCodable {
        @SmartAny
        var data: Any?
    }
}


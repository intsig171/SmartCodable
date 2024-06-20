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


/** todo
 1. 验证plat的准确性
 2. 验证解析容器/容器模型的准确性。 
 */


class TestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let dict: [String: Any] = [
            "name": [
                1, 2, 3
            ]
        ]
        
        if let model = Model.deserialize(from: dict) {
            print(model)
            print("\n")
            print(model.toDictionary())


        }
    }
    
    struct Model: SmartCodable {
        var name: [String] = []
    }
}


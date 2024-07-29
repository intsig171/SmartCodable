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
import BTPrint




class Test2ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dic1: [String : Any] = [
            "name": "mccc",
            "age": 10
        ]
        let dic2: [String : Any] = [
            "age": 200
        ]
        
        guard var model = Model.deserialize(from: dic1) else { return }
        SmartUpdater.update(&model, from: dic2)
    }
    struct Model: SmartCodable {
        var name: String = ""
        var age: Int = 0
    }
}


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
        
        let dict: [String: Any] = [
            "subModel": [
                "name": NSNull()
            ]
        ]
        if let model = Model.deserialize(from: dict) {
            smartPrint(value: model)
        }
    }
    
    struct Model: SmartCodable {
        var subModel: SubModel?
    }

    struct SubModel: SmartCodable {
        var name: String?
    }
}





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
            "name": "Mccc",
//            "sex": 1,
//            "dict": [
//                "name": "😊xiao ming"
//            ]
        ]
        
        if let model = decode(Model.self, element: dict) {
            print(model.name)
//            print(model.dict)
        }
        
        
    
    }
    
    struct Model: SmartCodable {
//        var sex: Any = 0
        @SmartAny
        var name: Any?
        
//        @SmartAny
//        var dict: [String: Any] = [:]
    }
    
    func decode<T: SmartCodable>(_ type: T.Type, element: Any) -> T? {
        
        if let dict = element as? [String: Any] {
            let model = T.deserialize(from: dict)
            return model
        }
        return nil
    }
}


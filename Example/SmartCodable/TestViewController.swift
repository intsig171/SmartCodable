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
    
        // 1802527796438790100
        // 1802527796438790100
        // 1802527796438790146.1
        let dict: [String: Any] = [
            "sub": [
                "name": "mccc"
            ]
        ]
        
        if let model = Model.deserialize(from: dict) {
            print(model)
            print("\n")
            print(model.toDictionary())


        }
    }
    
    struct Model: SmartCodable {
        var name: String = ""
        
        static func mappingForKey() -> [SmartKeyTransformer]? {
            [
                CodingKeys.name <--- "sub.name"
            ]
        }
    }
    

}


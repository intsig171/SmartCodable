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
                  
            "de": 1802527796438790146.1,
            "data": [
                "int": -9223372036854775808,

                "int2": 18035768958676993,
                "int3": 1802527796438790146,
            ],
            "float": [
                "float": 1.1,
                "float2": 1.12,
                "float3": 1.123
            ]
        ]
        
        if let model = Model.deserialize(from: dict) {
            print(model)
//            print("smartCodable = \(model.data)")
            print("\n")
//            print("smartCodable = \(model.float)")


        }
    }
    
    struct Model: SmartCodable {
        @SmartAny
        var de: Any?
        
//        @SmartAny
//        var data: Any?
//        
//        @SmartAny
//        var float: Any?
    }
    
    struct ModelHandy: HandyJSON {
        var data: Any?
        var float: Any?
    }
}


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
            "sex": 1,
            "selfAge": 0,
            "sub": [
                "name": "xiao li"
            ]
        ]
        

        if let model = Model.deserialize(from: dict) {
            print(model)
            
            if let dict = model.toDictionary() {
                print(dict)
            }
        }
    }
    
    struct Model: SmartCodable {
        var age: Int = 1
        var sex: Bool = true
        var name: String = "Mccc"
        var date: Date?
        var sub: SubModel?
        
        static func mappingForKey() -> [SmartKeyTransformer]? {
            [
                CodingKeys.age <--- "selfAge"
            ]
        }
        
       
    }
    
    struct SubModel: SmartCodable {
        var name: String = ""
    }
}



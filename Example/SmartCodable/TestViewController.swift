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


class TestViewController : BaseViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let dict: [String: Any] = [
            "age": NSNull(),
        ]

    
//        if let model = dict.decode(type: Model.self) {
//            print(model)
//        }
        
        
        if let model = Model.deserialize(dict: dict) {
            print("model = \(model)")
        }
    }
    
    struct Model: SmartCodable {
        

//        var name: String = "abc"
        var age: Int = 10
        
//        var sub = SubModel()
    }
    
    struct SubModel: SmartCodable {
        var name11: String = "xiaoming"
    }
}



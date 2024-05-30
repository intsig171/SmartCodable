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
            "age": 200,
        ]
        
        var model = Model.init(age: 10)
        
        abc(&model)
        
        
        
        
//        let updateDict: [String: Any] = [
//            "age": "20",
//        ]
//        
//        guard var model = Model.deserialize(from: dict) else { return }
//        JSONDeserializer.update(object: &model, from: updateDict)
//        print(model)
    }
    
    struct Model: HandyJSON {
        var age: Int = 0
    }
    
    func abc<T>(_ model: inout T) {
        
        let name: Int = 10
        
        
        
        
        let mirr = Mirror(reflecting: model)
        for item in mirr.children {
            print(item.label)
            print(item.value)
        }
    }
}

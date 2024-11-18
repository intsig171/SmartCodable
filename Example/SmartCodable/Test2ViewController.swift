//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SmartCodable
import BTPrint

class Test2ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let dict: [String: Any] = [
            "sub": [
                "name": "Mccc"
            ],
            "sub1": [
                "name": "Mccc1111"
            ],
            
            "subs": [
                [
                    "name": "Mccc"
                ]
            ],
            
            "subs1": [
                [
                    "name": "Mccc111"
                ]            ],
            
            "name": "qilin",
            "name1": "qilin1111",
            
        ]
        
        let modelClass = Model()

        if let model = Model.deserialize(from: dict) {
            
            print("\n")

            print("name = \(model.name)")
            print("name1 = \(model.name1)")
            print("\n")
            
            print("sub = \(model.sub)")
            print("sub1 = \(model.sub1)")
            print("\n")
            
            print("subs = \(model.subs)")
            print("subs1 = \(model.subs1)")
            print("\n")
        }
        
        
    }
}

struct Model: SmartCodable {
    
    @SmartAny
    var subs: [SubModel]?
    
    @SmartAny
    var subs1: [SubModel] = []
    
    @SmartAny
    var sub: SubModel?
    
    @SmartAny
    var sub1: SubModel = SubModel()
    
    @SmartAny
    var name: String?
    
    @SmartAny
    var name1: String = "init"
}

struct SubModel: SmartCodable {
    var name: String = "init"
}

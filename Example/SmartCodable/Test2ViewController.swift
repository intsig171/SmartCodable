//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SmartCodable
import BTPrint
import Combine

class Test2ViewController: BaseViewController {
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode = .none
        
        let dict: [String: Any] = [
            "age": 30,
            "name": "Mccc",
            "newName": "newMccc",
            "info": [
                "name": "mccc111"
            ],
        ]
        let model = Model.deserialize(from: dict)
        BTPrint.print(model)
    }
}

struct Model: SmartCodable {
    var name: String = ""
    var age: Int = 0
    
    
    static func mappingForKey() -> [SmartKeyTransformer]? {
        [
            CodingKeys.name <--- ["info.name", "newName", "name", ]
        ]
    }
}

struct SubModel: SmartCodable {
    var subname: String = ""
    var subage: Int = 0
    
    static func mappingForKey() -> [SmartKeyTransformer]? {
        [
            CodingKeys.subname <--- "info.name"
        ]
    }
}

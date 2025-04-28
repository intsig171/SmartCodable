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
            "name": "Mccc",
            "age": "20"
        ]
        
        let model = StudentModel.deserialize(from: dict)
        print(model?.name)
        print(model?.age)
        
    }
    
    class BaseModel: SmartCodable {
        var name: String = ""
        
        required init() { }
    }
    
    @InheritedSmartCodable
    class StudentModel: BaseModel {
        var age: Int = 0
    }
}


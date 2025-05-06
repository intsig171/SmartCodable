//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SmartCodable
import BTPrint
import CodableWrapper

class Test2ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()


        let dict: [String: Any] = [
            "name": "Mccc",
            "studentAge": "20",
            "age": []

        ]
        
        let model = StudentModel.deserialize(from: dict)
        print(model?.name)
        print(model?.age)
        
    }
    
    class BaseModel: SmartCodable {
        var name: String = "123"
        required init() { }
    }
    
    @SmartSubclass
    public class StudentModel: BaseModel {
        var age: Int?
        
        var location: String = ""
        

    }
}

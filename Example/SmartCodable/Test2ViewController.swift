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
            "studentName": NSNull(),
//            "studentAge": "20"
            "age": []

        ]
        
        let model = StudentModel.deserialize(from: dict)
        print(model?.name)
        print(model?.age)
        
    }
    
    class BaseModel: SmartCodable {
        @SmartAny
        var name: String = "123"
        
        class func mappingForKey() -> [SmartKeyTransformer]? {
            return [
                CodingKeys.name <--- "studentName"
            ]
        }
        
        required init() { }
    }
    
    @SmartSubclass
    class StudentModel: BaseModel {
        var age: Int = 0
    }
}

/**
 @SmartSubclass
 @SmartMember
 @SmartInherit
 @SmartInherited
 @SmartChild
 */

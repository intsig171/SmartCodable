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
        
//        let model = StudentModel.deserialize(from: dict)
//        print(model?.name)
//        print(model?.age)
        
    }
    
    class BaseModel: SmartCodable {
        var name: String = ""
        required init() { }
        
        class func mappingForKey() -> [SmartKeyTransformer]? {
            [
                CodingKeys.name <--- "stu_name"
            ]
        }
    }
    
//    @SmartSubclass
//    class StudentModel: BaseModel {
//        var age: Int?
//        
//        override static func mappingForKey() -> [SmartKeyTransformer]? {
//            let trans = [ CodingKeys.age <--- "stu_age" ]
//            
//            if let superTrans = super.mappingForKey() {
//                return trans + superTrans
//            } else {
//                return trans
//            }
//        }
//    }
}





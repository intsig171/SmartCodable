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
//import HandyJSON
import CleanJSON

class TestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict = [
            "nickName": "小花",
            "realName": "小明",
            "person_age": 10
        ] as [String : Any]

        guard let model = Model.deserialize(dict: dict) else { return }
        print(model.age)
        print(model.name)


//        let dict1 = [
//            "nickName": NSNull(),
//            "realName": "小花",
//            "age": 10,
//            "person_age": 20,
//        ] as [String : Any]
//
//        guard let model = Model.deserialize(dict: dict1) else { return }


    }
}


extension TestViewController {

}



struct Model: SmartCodable {
    var name: String = ""
    var age: Int = 0
    var ignoreKey: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "todo"
        case age
    }
    
    static func mapping() -> [MappingRelationship]? {
        [
            CodingKeys.name <--- ["realName", "nickName"],
            CodingKeys.age <--- "person_age"
        ]
    }
}

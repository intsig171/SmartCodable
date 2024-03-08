//
//  CaseThreeViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/11/22.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


class CaseThreeViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let dict = [
            "name": "小明",
            "age": "10"
        ]
        
        

        guard let model = CaseThreeModel.deserialize(dict: dict) else { return }
        print(model)


        let dict1 = [
            "nickName": "小丽",
            "age1": "20"

        ]
        guard let model1 = CaseThreeModel.deserialize(dict: dict1) else { return }
        print(model1)


        let dict2 = [
            "realName": "小黄",
            "age2": "30"

        ]
        guard let model2 = CaseThreeModel.deserialize(dict: dict2) else { return }
        print(model2)
    }
}

struct CaseThreeModel: SmartCodable {
    
    var name: String = ""
    var age: String = ""
    
    static func mapping() -> [MappingRelationship]? {
        [
            CodingKeys.name <-- ["nickName", "realName"],
            CodingKeys.age <-- ["age", "age1", "age2"]
        ]
    }
}

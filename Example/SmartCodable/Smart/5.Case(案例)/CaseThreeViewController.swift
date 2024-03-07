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
//        let option1 = SmartDecodingOption.keyStrategy(.globalMatch(["nickName": "name", "age1": "age"]))
//        guard let model1 = CaseThreeModel.deserialize(dict: dict1, options: [option1]) else { return }
//        print(model1)
//
//
//        let dict2 = [
//            "realName": "小黄",
//            "age2": "30"
//
//        ]
//        let option2 = SmartDecodingOption.keyStrategy(.globalMatch(["realName": "name", "age2": "age"]))
//        guard let model2 = CaseThreeModel.deserialize(dict: dict2, options: [option2]) else { return }
//        print(model2)
    }
}

struct CaseThreeModel: SmartCodable {
    init() { }
    
    var name: String = ""
    var age: String = ""
}

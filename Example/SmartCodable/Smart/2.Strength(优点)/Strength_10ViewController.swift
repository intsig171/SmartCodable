//
//  Strength_10ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/28.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable

class Strength_10ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dict: [String : Any] = [
            "real_name": "张小华",
            "nick_name": "小花",

            "selfAge": 10,
            "sexInfo": [
                "sex": 1
            ],
            
            "son": [
                "real_name": "张小小小华",
                "nick_name": "小小",
            ]
        ]


        let option: SmartDecodingOption = .key(.fromSnakeCase)
        guard let model = Model.deserialize(from: dict, options: [option]) else { return }
        print(model)
    }
}

extension Strength_10ViewController {
    
    enum Sex: Int, SmartCaseDefaultable {
        static var defaultCase: Sex = .man
        case women = 0
        case man = 1
    }
    
    struct Model: SmartCodable {
        var realName: String = ""
        var nickName: String = ""

        var age: Int?
        var sex: Sex?
        
        var son: SubModel?
        static func mapping() -> [MappingRelationship]? {
            [
                CodingKeys.age <--- "selfAge",
                CodingKeys.sex <--- "sexInfo.sex",
            ]
        }
    }
    
    struct SubModel: SmartCodable {
        var realName: String = ""
        var nickName: String = ""
    }
}


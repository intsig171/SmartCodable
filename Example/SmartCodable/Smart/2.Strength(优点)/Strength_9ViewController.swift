//
//  Strength_9ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/28.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
/** Key的映射关系
 * 1. 多个有效字段映射到同一个属性上，优先使用第一个。
 */
class Strength_9ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dict = [
            "nickName": "小花",
            "person_age": 10
        ] as [String : Any]


        guard let model = Model.deserialize(from: dict) else { return }
        print(model)

        
        
        let dict1 = [
            "nickName": NSNull(),
            "realName": "小花",
            "age": 10,
            "person_age": 20,
        ] as [String : Any]

        
        guard let model = Model.deserialize(from: dict1) else { return }
        print(model)
    }
}



extension Strength_9ViewController {
    
    struct Model: SmartCodable {
        var name: String = ""
        var age: Int?
        static func mapping() -> [KeyTransformer]? {
            [
                CodingKeys.name <--- ["nickName", "realName"],
                CodingKeys.age <--- "person_age"
            ]
        }
    }
}

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
import HandyJSON



class TestViewController : BaseViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        

        let dict: [String: Any] = [
            "nickname": "Mccc",
            "age": [
                "ageHH": 10
            ]
        ]

        if let model = Model.deserialize(dict: dict) {
            print(model)
        }
        
//        if let model = HandyModel.deserialize(from: dict) {
//            print(model)
//        }
    }
}


extension TestViewController {
    struct Model: SmartCodable {
        var name: String = ""
        var sub: SubModel = SubModel()
        
        
        static func mapping() -> [SmartMapping]? {
            return [
                ("nickname", CodingKeys.name),
                ("age", CodingKeys.sub)

            ]
            
            /** 期望是这样的格式
             * "nickname" -> CodingKeys.name
             * ["nickname", "nickName"] -> CodingKeys.name
             */
        }
        
        struct SubModel: SmartCodable {
            var age: Int = 0
            
            static func mapping() -> [SmartMapping]? {
                return [
                    ("ageHH", CodingKeys.age)
                ]
            }
        }
    }
    
    struct HandyModel: HandyJSON {
        var name: String = ""

        mutating func mapping(mapper: HelpingMapper) {
            mapper <<<
                self.name <-- "nickname"
        }
    }
}



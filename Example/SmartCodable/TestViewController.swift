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
import CleanJSON
import BTPrint



class TestViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        SmartConfig.debugMode = .none

        let dict: [String: Any] = [
            "name": "满聪的家",
//            "type": "old",
            "father": [
                "name": "满聪",
                "age": 33,
                "sex": "man"
            ],
            "mother": [
                "name": "刘文巧",
                "age": 32,
                "sex": "women",
                "birth": "2034-12-01 18:00:00"
            ],
            "sons": [
                [
                   "name": "qiqi",
                   "age": 3,
                   "sex": "man",
                   "birth": "2021-02-06"
               ],
                [
                   "name": "lili",
                   "age": 3,
                   "sex": "man",
                   "birth": "2021-02-06"
               ]
            ]
        ]
        
        guard let model = Family.deserialize(from: dict) else { return }
        smartPrint(value: model)
    }
}


enum Sex: String, SmartCaseDefaultable {
    static var defaultCase: Sex = .man
    
    case man
    case women
}

enum FamilyType: String, SmartCaseDefaultable {
    static var defaultCase: FamilyType = .new
    
    case new
    case old
}


struct Family: SmartCodable {
    var name: String = "我的家"
    var father = FatherModel()
    var mother = MotherModel()
    var sons: [SonModel] = []
    var type: FamilyType = .new

}

struct FatherModel: SmartCodable {
    var name: String = "Mccc"
    var age: Int = 30
    var sex: Sex = .man
}

struct MotherModel: SmartCodable {
    var name: String = "LWQ"
    var age: Int = 20
    var sex: Sex = .women
    var birth: Date?
    
    static func mappingForValue() -> [SmartValueTransformer]? {
        let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return [
            CodingKeys.birth <--- SmartDateFormatTransformer(dateFormatter)
        ]
    }
}

struct SonModel: SmartCodable {
    var name: String = ""
    var age: Int = 3
    var sex: Sex = .man
    var birth: Date?
    
    static func mappingForValue() -> [SmartValueTransformer]? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return [
            CodingKeys.birth <--- SmartDateFormatTransformer(df)
        ]
    }
}

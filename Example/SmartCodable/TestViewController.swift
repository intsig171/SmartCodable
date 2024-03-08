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

class TestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 这三个模型都有共同的字段（name 和 age）
        let dict: [String: Any] = [
            "name": false,
//            "age": 20,
//            "hobby": "sleep",
//            "sub": [
//                "name": "Mcc1111c",
//                "age": 20,
//            ]
//            "firstSon": [
//                "hobby": "sleep",
//                "name": "QiQi",
//                "age": 3,
//            ],
//            "secondSon": [
//                "height": 95.3,
//                "name": "LinLin",
//                "age": 3,
//            ]
        ]

        guard let model = BigModel.deserialize(dict: dict) else { return }
        print("hobby = \(model.name)")
//        print(model.sub?.name)
//        print("name = \(model.name)")
//        print("age = \(model.age)")

        
//        print("\n")
//
//        print(model.firstSon?.name ?? "")
//        print(model.firstSon?.age ?? 0)
//        print(model.firstSon?.hobby ?? "")
//
//        print("\n")
//
//        print(model.secondSon?.name ?? "")
//        print(model.secondSon?.age ?? 0)
//        print(model.secondSon?.height ?? 0)
//
//        print("\n")
    }
}

extension TestViewController {
    
    class BaseModel: SmartCodable {
        var name: String = ""
        var age: Int = 0
        required init() { }
    }
    
    class BigModel: SmartCodable {
        var name: String = ""
        
//        var sub: SubModel?
        
        required init() { }
    }
    
    
//    class SubModel: BaseModel {
//        var hobby: String = ""
//    }
}


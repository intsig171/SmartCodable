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
            "name": "Mccc",
            "age": 20,
            "firstSon": [
                "hobby": "sleep",
                "name": "QiQi",
                "age": 3,
            ],
            "secondSon": [
                "height": 95.3,
                "name": "LinLin",
                "age": 3,
            ]
        ]

        guard let model = BigModel.deserialize(from: dict) else { return }
        print(model.name)
        print(model.age)
        
        print("\n")
        
        print(model.firstSon?.name ?? "")
        print(model.firstSon?.age ?? 0)
        print(model.firstSon?.hobby ?? "")
        
        print("\n")
        
        print(model.secondSon?.name ?? "")
        print(model.secondSon?.age ?? 0)
        print(model.secondSon?.height ?? 0)
        
        print("\n")
    }
}

extension TestViewController {
    class BaseModel: HandyJSON {
        var name: String = ""
        var age: Int = 0
        
        
        
        required init() { }
    }
    
    class BigModel: BaseModel {
        var firstSon: FirstModel?
        var secondSon: SecondModel?
        
        
        required init() {
        }
    }
    
    class FirstModel: BaseModel {
        var hobby: String = ""
       
        
    }
    
    class SecondModel: BaseModel {
        var height: Double = 0
    }
}


//
//  Test_1_1ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/2/29.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import BTPrint

class Test_1_1ViewController: BaseViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        异常数据的验证()
//        嵌套字典的验证()
    }
}


//MARK : - 简单的字典
extension Test_1_1ViewController {
    func 异常数据的验证() {
        
        let dict1: [String: Any] = [ : ]
        
        let dict2: [String: Any] = [
            "name": NSNull(),
            "age": NSNull()
        ]
        
        let dict3: [String: Any] = [
            "name": [],
            "age": "age"
        ]
        
        let dict4: [String: Any] = [
            "name": "Mccc",
            "age": ["a": 1]
        ]
        
        
        
//        if let model = Test1_1DictModel.deserialize(dict: dict1)  { print( model) }
        // Test1_1DictModel(name: "", age: nil)
        
//        if let model = Test1_1DictModel.deserialize(dict: dict2)  { print( model) }
        // Test1_1DictModel(name: "", age: nil)

        if let model = Test1_1DictModel.deserialize(dict: dict3)  { print( model) }
        // Test1_1DictModel(name: "", age: Optional(20))
        
//        if let model = Test1_1DictModel.deserialize(dict: dict4)  { print( model) }
        // Test1_1DictModel(name: "Mccc", age: Optional(10))
    }
    
    struct Test1_1DictModel: SmartCodable {
//        var name: String = ""
        var age: Int?
    }
}


//MARK : - 简单的数组
extension Test_1_1ViewController {
    func 嵌套字典的验证() {
        
        let dict1: [String: Any] = [
            "name": "Mccc",
            "age": ["a": 1],
            "subOne": [
                "name": "Mccc",
                "age": 20,
            ],
            "subTwo": 123,
            "list": [
                [
                    "name": 123,
                    "age": "20",
                ],
                [
                    "name": NSNull(),
                    "age": ["a": 1]
                ]
            ],
            "listTwo": []
        ]
        
        if let model = FatherModel.deserialize(dict: dict1) {
            BTPrint.print(model)
        }
        
    }
    
    struct FatherModel: SmartCodable {
        var name: String = ""
        var age: Int?
        
        var subOne = SubOneModel()
        
        var subTwo: SubTwoModel?
        
        var list: [SubOneModel] = []
        
        var listTwo: [SubOneModel]?
    }
    
    struct SubOneModel: SmartCodable {
        var name: String = ""
        var age: Int?
    }
    
    struct SubTwoModel: SmartCodable {
        var name: String = ""
        var age: Int?
    }
}

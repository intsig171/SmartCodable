//
//  TestViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2023/9/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SmartCodable
import HandyJSON
import CleanJSON
import BTPrint


/** 字典的值情况
 1. @Published 修饰的属性的解析。
 2. 继承关系！！！！
 *
 */


/**
 V4.1.12 发布公告
 1. 【新功能】支持Combine，允许@Published修饰的属性解析。
 2. 【新功能】支持@igonreKey修饰的属性在encode时，不出现在json中（屏蔽这个属性key）
 3. 【新功能】支持encode时候的options，同decode的options使用。
 4. 【优化】Data类型在decode和encode时，只能使用base64解析.
 */


class TestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let arr: [String: Any] = [
            "out_array": [
                [
                    "person_name": "jack",
                    "person_age": 11,
                    "person_array": [
                        [
                            "person_sub_name": "tom",
                            "person_sub_age": 2
                        ],
                        [
                            "person_sub_name": "jb",
                            "person_sub_age": 3
                        ]
                    ]
                ]
            ],
            "out_mapping": [
                "1": 1,
                "2": 2
            ],
            "out_dict": [
                "person_name": "jim",
                "person_age": 1111,
                "person_array": [
                    [
                        "person_sub_name": "小明",
                        "person_sub_age": 2
                    ],
                    [
                        "person_sub_name": "小李",
                        "person_sub_age": 3
                    ]
                ]
            ]
        ]
        
        if let model = OutModel.deserialize(from: arr) {
            smartPrint(value: model)
            print(model.toDictionary(useMappedKeys: true))
        }
        
    }
    
    class OutModel: SmartCodable {
        var dict: PersonModel = PersonModel()
        var mapping: [String: Int] = [:]
        var array: [PersonModel] = []
        
        static func mappingForKey() -> [SmartKeyTransformer]? {
            return [
                CodingKeys.array <--- "out_array",
                CodingKeys.mapping <--- "out_mapping",
                CodingKeys.dict <--- "out_dict"
            ]
        }
        
        required init() {
        }
    }
    
    class PersonModel: SmartCodable {
        var name: String = ""
        var age: Int = 0
        var array: [PersonSubModel] = []
        
        static func mappingForKey() -> [SmartKeyTransformer]? {
            return [
                CodingKeys.name <--- "person_name",
                CodingKeys.age <--- "person_age",
                CodingKeys.array <--- "person_array"
            ]
        }
        
        required init() {
        }
    }
    
    class PersonSubModel: SmartCodable {
        var name = ""
        var age = 0
        
        static func mappingForKey() -> [SmartKeyTransformer]? {
            [
                CodingKeys.name <--- "person_sub_name",
                CodingKeys.age <--- "person_sub_age"
            ]
        }
        
        required init() {
        }
    }
}

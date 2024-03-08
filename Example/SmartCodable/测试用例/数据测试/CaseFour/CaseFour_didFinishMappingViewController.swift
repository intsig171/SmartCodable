//
//  CaseFour_didFinishMappingViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import SmartCodable

class CaseFour_didFinishMappingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     

        单层字典的测试()
//        多层字典的测试()
//        字典中嵌套数组的测试()
//        数组嵌套字典的测试()
    }
    
    
    /** didFinishMapping的测试
     *
     */
    
    func 单层字典的测试() {
        
        let dict = [
            "name": "睡觉"
        ]
        
        if let model = HobbyModel.deserialize(dict: dict) {
            smartPrint(value: model)
        }
        
        if let model = HobbyClassModel.deserialize(dict: dict) {
            smartPrint(value: model)
        }
    }
    
    func 多层字典的测试() {
        let dict: [String: Any] = [
            "name": "Mccc",
            "hobby": [
                "name": "睡觉"
            ],
            "optionalHobby": [
                "name": "打游戏"
            ]
        ]
        
        if let model = PersonModel.deserialize(dict: dict) {
            smartPrint(value: model)
        }
        
        if let model = PersonClassModel.deserialize(dict: dict) {
            smartPrint(value: model)
        }
    }
    
    func 字典中嵌套数组的测试() {
        let dict: [String: Any] = [
            "hobbys": [
                [
                    "name": "睡觉1"
                ]
            ],
            "optionalHobbys": [
                [
                    "name": "睡觉1"
                ],
                [
                    "name": "睡觉2"
                ]
            ]
        ]
        
        if let model = HobbysModel.deserialize(dict: dict) {
            smartPrint(value: model)
        }
        
//        if let model = HobbysClassModel.deserialize(dict: dict) {
//            smartPrint(value: model)
//        }
    }
    
    func 数组嵌套字典的测试() {
        let arr = [
            [
                "hobbys": [
                    [
                        "name": "睡觉1",
                    ],
                    [
                        "name": "睡觉2",
                    ]
                ],
            ]
        ]
        
        guard let models = [HobbysModel].deserialize(array: arr) as? [HobbysModel] else { return }
        smartPrint(value: models)
    }
}


extension CaseFour_didFinishMappingViewController {
    struct HobbysModel: SmartCodable {
        var hobbys: [HobbyModel] = []
        var optionalHobbys: [HobbyModel]?
    }
    
    class HobbysClassModel: SmartCodable {
        var hobbys: [HobbyClassModel] = []
        var optionalHobbys: [HobbyClassModel]?

        required init() { }


    }
}

extension CaseFour_didFinishMappingViewController {
    struct PersonModel: SmartCodable {
        var name: String = ""
        var hobby = HobbyModel()
        var optionalHobby: HobbyModel?


        mutating func didFinishMapping() {
            name = "我是" + name
        }
    }
    
    class PersonClassModel: SmartCodable {
        var name: String?
        var hobby = HobbyModel()
        var optionalHobby: HobbyClassModel?

        func didFinishMapping() {
            name = "我是" + (name ?? "无名者")
        }
        
        required init() { }
    }
}

extension CaseFour_didFinishMappingViewController {
    struct HobbyModel: SmartCodable {
        var name: String = ""

        mutating func didFinishMapping() {
            name = "我的爱好是" + name
        }
    }
    
    class HobbyClassModel: SmartCodable {
        var name: String = ""
        
        required init() { }
        
        
        func didFinishMapping() {
            name = "我的爱好是" + name
        }
    }
}

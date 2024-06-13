//
//  Introduce_1ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/9/8.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable

/// 不同的数据类型转Model/Models
class Introduce_1ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 字典结构数据
        let dict: [String: Any] = ["name": "xiaoming", "two": ["name": "xiaoli"]]
        let json = dict.bt_toJSONString() ?? ""
        let data = json.data(using: .utf8)!
        
        guard let model1 = Model.deserialize(from: dict) else { return }
        smartPrint(value: model1)

        guard let model2 = Model.deserialize(from: json) else { return }
        smartPrint(value: model2)
        
        guard let model3 = Model.deserialize(from: data) else { return }
        smartPrint(value: model3)
        
        print("\n")
        

        /// 数组结构的数据
        let arr = [dict, dict]
        let arrJson = arr.bt_toJSONString() ?? ""
        let arrData = arrJson.data(using: .utf8)!
        guard let models1 = [Model].deserialize(from: arr) else { return }
        smartPrint(value: model1)
        
        guard let models2 = [Model].deserialize(from: arrJson) else { return }
        smartPrint(value: model2)
        
        guard let models3 = [Model].deserialize(from: arrData) else { return }
        smartPrint(value: model3)
    }
}


extension Introduce_1ViewController {
    struct Model: SmartCodable {
        var name: String = ""
        var two = SubModel()
    }
    struct SubModel: SmartCodable {
        var name: String = ""
    }
}



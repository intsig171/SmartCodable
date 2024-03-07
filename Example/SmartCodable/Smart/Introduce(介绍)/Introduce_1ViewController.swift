//
//  Introduce_1ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/9/8.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


class Introduce_1ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 字典结构数据
        let dict: [String: Any] = ["name": "xiaoming", "two": ["name": "xiaoli"]]
        let json = dict.bt_toJSONString() ?? ""
        let data = json.data(using: .utf8)!
        
        guard let model1 = Model.deserialize(dict: dict) else { return }
        print("model1 = \(model1)")

        guard let model2 = Model.deserialize(json: json) else { return }
        print("model2 = \(model2)")
        
        guard let model3 = Model.deserialize(data: data) else { return }
        print("model3 = \(model3)")
        
        print("\n\n")
        

        /// 数组结构的数据
        let arr = [dict, dict]
        let arrJson = arr.bt_toJSONString() ?? ""
        let arrData = arrJson.data(using: .utf8)!
        guard let models1 = [Model].deserialize(array: arr) else { return }
        print("models1 = \(models1)")
        
        guard let models2 = [Model].deserialize(json: arrJson) else { return }
        print("models2 = \(models2)")
        
        guard let models3 = [Model].deserialize(data: arrData) else { return }
        print("models3 = \(models3)")
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



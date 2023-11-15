//
//  SimpleSmartCodableViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/9/8.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


class SimpleSmartCodableViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: [String: Any] = ["name": "xiaoming", "two": ["name": "xiaoli"]]
        let json = dict.bt_toJSONString() ?? ""
        let data = json.data(using: .utf8)!
        
        guard let model1 = ModelABC.deserialize(dict: dict) else { return }
        print("model1 = \(model1)")

        
        guard let model2 = ModelABC.deserialize(json: json) else { return }
        print("model2 = \(model2)")
        
        guard let model3 = ModelABC.deserialize(data: data) else { return }
        print("model3 = \(model3)")
        
        print("\n\n")
        

        let arr = [dict, dict]
        let arrJson = arr.bt_toJSONString() ?? ""
        let arrData = arrJson.data(using: .utf8)!
        guard let models1 = [ModelABC].deserialize(array: arr) as? [ModelABC] else { return }
        print("models1 = \(models1)")
        
        guard let models2 = [ModelABC].deserialize(json: arrJson) as? [ModelABC] else { return }
        print("models2 = \(models2)")
        
        guard let models3 = [ModelABC].deserialize(data: arrData) as? [ModelABC] else { return }
        print("models3 = \(models3)")
    }
}


extension SimpleSmartCodableViewController {
    struct ModelABC: SmartCodable {
        var name: String = ""
        var two = ModelABCTwo()
    }
    struct ModelABCTwo: SmartCodable {
        var name: String = ""
    }
}



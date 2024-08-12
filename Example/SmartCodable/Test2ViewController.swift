//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SmartCodable
import BTPrint

class Test2ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let dict: [String: Any] = [
            "nick_name": "Mccc"
        ]
        
        let option = SmartDecodingOption.key(.fromSnakeCase)
        guard let model = Model.deserialize(from: dict, options: [option]) else { return }
        
        smartPrint(value: model)
        
        let string = model.toJSONString(useMappedKeys: false)
        print(string)
    }
    

    struct Model: SmartCodable {
        var nickName: String = ""
        
        
    }
}

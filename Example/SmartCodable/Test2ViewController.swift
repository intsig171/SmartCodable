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
            "error": "200",
            "code": 400,
            "data": [
                "code": "abc",
                "lyricType": "9999999",
                "expriryTime": "NaN"
            ]
        ]
        
        guard let model = Model.deserialize(from: dict) else { return }
        print(model)
    }
    
    struct Model: SmartCodable {
        var error: Int?
        var code: Int?
        var data: SubModel?
    }
    
    struct SubModel: SmartCodable {
        var code: Int?
        var lyricType: Int?
        var expriryTime: Int?
    }
}

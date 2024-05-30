//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import HandyJSON


import SmartCodable

class Test2ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: [String: Any] = [
            "age": "10",
            "sub": [
                "name": "Mccc"
            ]
        ]
        
        
        let updateDict: [String: Any] = [
            "age": "20",
            "sub": [
                "name": "xiao li"
            ]
        ]
        guard let from = Model.deserialize(from: updateDict) else { return }
        guard var model = Model.deserialize(from: dict) else { return }

        
        SmartUpdater.update(&model, from: from, keyPaths: (\.age, \.sub))
        print(model)
    }
    
    struct Model: SmartCodable {
        var age: String = ""
        var sub: SubModel?
    }
   
    struct SubModel: SmartCodable {
        var name: String = ""
    }
}

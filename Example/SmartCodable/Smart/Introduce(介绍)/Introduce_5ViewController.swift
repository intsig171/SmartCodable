//
//  Introduce_5ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/7.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


class Introduce_5ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict = [
            "name": "小花"
        ] as [String : Any]

        
        guard let model = Model.deserialize(dict: dict) else { return }
        print(model)
    }
}




extension Introduce_5ViewController {
    
    struct Model: SmartCodable {
        var name: String = ""
        mutating func didFinishMapping() {
            name = "我是\(name)"
        }
    }
}

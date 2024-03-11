//
//  Strength_2ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/7.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


/// 解码完成时回调
class Strength_2ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict = [
            "name": "小花"
        ] as [String : Any]

        
        guard let model = Model.deserialize(dict: dict) else { return }
        print(model)
    }
}




extension Strength_2ViewController {
    
    struct Model: SmartCodable {
        var name: String = ""
        mutating func didFinishMapping() {
            name = "我是\(name)"
        }
    }
}


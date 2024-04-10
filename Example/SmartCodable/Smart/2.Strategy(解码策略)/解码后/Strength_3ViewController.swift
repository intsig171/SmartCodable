//
//  Strength_3ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/7.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


/// 解码完成时回调
class Strength_3ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict = [
            "name": "小花"
        ] as [String : Any]

        
        guard let model = Model.deserialize(from: dict) else { return }
        print(model)
    }
}




extension Strength_3ViewController {
    
    struct Model: SmartCodable {
        var name: String = ""
        mutating func didFinishMapping() {
            name = "我是\(name)"
        }
    }
}





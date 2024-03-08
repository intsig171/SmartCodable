//
//  Strength_5ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/12/4.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable

/// 当解析失败的时，使用当前属性初始化的值进行填充。
class Strength_5ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: [String: Any] = [
            "hobby": "{\"name\":\"sleep\"}",
        ]
        
        guard let model = Model.deserialize(dict: dict) else { return }
        print(model)
    }
}




extension Strength_5ViewController {

    struct Model: SmartCodable {
        var hobby: Hobby?
    }
    
    struct Hobby: SmartCodable {
        var name: String = ""
    }
}

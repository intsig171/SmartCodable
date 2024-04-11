//
//  BeforeDecodingViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/28.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation


import Foundation
import SmartCodable

/** 忽略Key的解析
 */

class BeforeDecodingViewController: BaseCompatibilityViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let dict: [String: Any] = [
            "name": "Mccc1",
            "ignore": "请忽略我",
            "selfAge": 10
        ]
        
        guard let model = Model.deserialize(from: dict) else { return }
        print(model)
    }
}


extension BeforeDecodingViewController {
    struct Model: SmartCodable {
        var name: String = ""
        var ignore: String = ""
        var age: Int = 0
        
        /// ⚠️： 你也可以通过重写CodingKeys实现key的重命名
        enum CodingKeys: String, CodingKey {
            case name
            case age = "selfAge"
            // 忽略ignore的解析。
//            case ignore
        }
    }
}








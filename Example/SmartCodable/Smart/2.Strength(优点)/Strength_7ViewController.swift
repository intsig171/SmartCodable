//
//  Strength_7ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/28.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation


import Foundation
import SmartCodable

/** 自定义key的解析路径
 */

class Strength_7ViewController: BaseCompatibilityViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let dict = [
            "sub": [
                "name": "Mccc"
            ]
        ]
        
        guard let model = Model.deserialize(from: dict) else { return }
        print(model)
    }
}


extension Strength_7ViewController {
    struct Model: SmartCodable {
        var name: String = ""
        static func mapping() -> [KeyTransformer]? {
            [ CodingKeys.name <--- "sub.name" ]
        }
    }
}







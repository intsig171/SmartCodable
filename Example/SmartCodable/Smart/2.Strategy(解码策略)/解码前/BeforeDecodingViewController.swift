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
                
        let dict = [
            "name": "Mccc1",
            "ignore": "请忽略我"
        ]
        
        guard let model = Model.deserialize(from: dict) else { return }
        print(model)
    }
}


extension BeforeDecodingViewController {
    struct Model: SmartCodable {
        var name: String = ""
        var ignore: String = ""
        
        enum CodingKeys: CodingKey {
            case name
            // 忽略ignore的解析。
//            case ignore
        }
    }
}







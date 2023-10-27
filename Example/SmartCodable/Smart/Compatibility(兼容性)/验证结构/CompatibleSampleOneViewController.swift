//
//  CompatibleSampleOneViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/10/27.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable

/// 兼容性 - 验证单字典容器结构下的兼容性
class CompatibleSampleOneViewController: BaseCompatibilityViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     

  
        let dict = [
            "string": 1,
            "string1": "Smaple One",
        ] as [String : Any]
        
        guard let feed = CompatibleSampleOne.deserialize(dict: dict) else { return }
        BTLog.print(feed)
    }

}

struct CompatibleSampleOne: SmartCodable {
    var string: String = ""
    var string1: String = ""

    init() { }
}




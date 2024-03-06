//
//  CompatibleSampleTwoViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/10/27.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import Foundation
import SmartCodable
import BTPrint

/// 兼容性 - 验证单字典容器结构下的兼容性
class CompatibleSampleTwoViewController: BaseCompatibilityViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     

  
        let dict = [
            "string": 2,
            "string1": "Smaple Two",
            "numbers": [0, 1, 2],
            "sampleOne" : [
                "string": 1,
                "string1": [1,2, 3],
            ]
        ] as [String: Any]
        
        guard let feed = CompatibleSampleTwo.deserialize(dict: dict) else { return }
        BTPrint.print(feed)
        

    }

}

struct CompatibleSampleTwo: SmartCodable {
    var string: String = ""
    var string1: String = ""
    var numbers: [Int] = []
    var sampleOne = CompatibleSampleOne()

    mutating func didFinishMapping() {
        self.numbers = self.numbers.reversed()
    }
    
    init() { }
}

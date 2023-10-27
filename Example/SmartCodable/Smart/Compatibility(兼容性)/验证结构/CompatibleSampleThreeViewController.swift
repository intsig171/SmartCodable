//
//  CompatibleSampleThreeViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/10/27.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import Foundation
import SmartCodable

/// 兼容性 - 验证单字典容器结构下的兼容性
class CompatibleSampleThreeViewController: BaseCompatibilityViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        SmartConfig.debugMode = .error

  
        let dict = [
            "string": 3,
            "string1": "Smaple Three",
            "smapleOne": [
                ["string": 1, "string1": "Smaple 1.0"],
                ["string": false, "string1": "Smaple 1.1"],
            ],
            "smapleTwo": [
                [
                    "string": 2,
                    "string1": "Smaple Two",
                    "numbers": [0, 1, 2],
                    "sampleOne" : [
                        "string": 1,
                        "string1": false,
                    ]
                ],
                [
                    "string": 2.1,
                    "string1": "Smaple 2.1",
                    "numbers": [0, 1, 2, 3],
                    "sampleOne" : [
                        "string": 1,
                        "string1": false,
                    ]
                ]
            ]
        ] as [String: Any]
        
        guard let feed = CompatibleSampleThree.deserialize(dict: dict) else { return }
        print("值为\n", feed)
        

    }

}

struct CompatibleSampleThree: SmartCodable {
    var string: String = ""
    var string1: String = ""
    var smapleOne: [CompatibleSampleOne] = []
    var smapleTwo: [CompatibleSampleTwo] = []

    init() { }
}

//
//  CompatibleSampleSixViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/10/27.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable

/// 兼容性 - 验证单字典容器结构下的兼容性
class CompatibleSampleSixViewController: BaseCompatibilityViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode = .error
        
        
        let arr = [
            [
                "string": 5,
                "string1": "Smaple five",
                "sampleFive": [
                    [
                        "string": 5,
                        "string1": "Smaple five",
                        "numbers": [0, 1, 2, 3, 4, 5],
                        "sampleOne": [
                            "string": 1,
                            "string1": "Smaple 1",
                        ]
                    ],
                    [
                        "string": false,
                        "string1": false,
                        "sampleOne": [
                            "string": 1.1,
                            "string1": "Smaple 1.1",
                        ]
                    ]
                ]
            ],
        ] as [Any]
        
        guard let feed = [CompatibleSampleSix].deserialize(array: arr) else { return }
        
        BTLog.print(feed)
        
    }
    
}

struct CompatibleSampleSix: SmartCodable {
    var string: String = ""
    var bool: Bool = false
    var sampleFive: [CompatibleSampleTwo] = []
    
    init() { }
}

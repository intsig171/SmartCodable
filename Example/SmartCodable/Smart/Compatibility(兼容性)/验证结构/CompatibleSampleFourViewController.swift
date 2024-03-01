//
//  CompatibleSampleFourViewController.swift
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
class CompatibleSampleFourViewController: BaseCompatibilityViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode = .error
        
        
        let dict = [
            "string": 4,
            "bool": "true",
            "sampleTwo" : [
                [
                    "string": 2,
                    "string1": "Smaple Two",
                    "numbers": [0, 1, 2, 3],
                    "sampleOne" : [
                        "string": 1,
                        "string1": false,
                    ]
                ],
                [
                    "string": 2,
                    "string1": "Smaple Two",
                    "sampleOne" : [
                        "string": 1,
                        "string1": 1.2222,
                    ]
                ]
                
            ]
        ] as [String: Any]
        
        guard let feed = CompatibleSampleFour.deserialize(dict: dict) else { return }
        
        BTPrint.print(feed)
        
    }
    
}

struct CompatibleSampleFour: SmartCodable {
    var string: String = ""
    var bool: Bool = false
    var sampleTwo: [CompatibleSampleTwo] = []
    
    init() { }
}

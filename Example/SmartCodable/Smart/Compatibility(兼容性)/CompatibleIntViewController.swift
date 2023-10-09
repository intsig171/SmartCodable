//
//  CompatibleIntViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/9/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import SmartCodable

/// 兼容Int类型，只兼容String类型的int值。
class CompatibleIntViewController: BaseCompatibilityViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        let json = """
        {
          "intValue": "123",
          "intValue1": "123.1",
          "intValue2": 12.3,
        }
        """
        
        guard let feed = CompatibleInt.deserialize(json: json) else { return }
        print(feed.intValue)
        print(feed.intValue1)
        print(feed.intValue2)
        print(feed.intValue3)
        
        /**
         123
         0
         0
         nil
         */
    }

}

struct CompatibleInt: SmartCodable {
    var intValue: Int = 0
    var intValue1: Int = 0
    var intValue2: Int = 0
    var intValue3: Int?

    init() { }
}



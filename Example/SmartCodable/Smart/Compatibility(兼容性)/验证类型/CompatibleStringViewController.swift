//
//  CompatibleStringViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/9/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

import SmartCodable

/// 兼容类String型，只兼容String类型的int值。
class CompatibleStringViewController: BaseCompatibilityViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     

  
        let dict = [
            "string1": 123,
            "string2": 345.0,
            "string3": [],
            "string4": NSNull()
        ] as [String : Any]
        
        guard let feed = CompatibleString.deserialize(dict: dict) else { return }
        print("string1的值为", feed.string1)
        print("string2的值为", feed.string2)
        print("string3的值为", feed.string3)
        print("string4的值为", feed.string4 ?? "")
        
        /**
         string1的值为 123
         string2的值为 345.0
         string3的值为
         string4的值为 nil
         */
    }

}

struct CompatibleString: SmartCodable {
    var string1: String = ""
    var string2: String = ""
    var string3: String = ""
    var string4: String?
    init() { }
}




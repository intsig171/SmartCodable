//
//  CompatibleEmptyObjectViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/9/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import SmartCodable


/// 空对象
class CompatibleEmptyObjectViewController: BaseCompatibilityViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let json = """
        {
          "secondson": {},
          "sons": []
        }
        """
        
        
        guard let father = Father.deserialize(json: json) else { return }
        
        print(father)
        print(father.firstSon)
        print(father.secondson)
        print(father.sons)
        
        /**
         Father(firstSon: Optional(SmartCodable_Example.Son(name: "")), secondson: SmartCodable_Example.Son(name: ""), sons: [])
         Optional(SmartCodable_Example.Son(name: ""))
         Son(name: "")
         []
         */

    }
}

struct Father: SmartCodable {
//     var name: String?
    var firstSon: Son?
    var secondson: Son = Son()
    var sons: [Son] = []

    init() { }
}

struct Son: SmartCodable {
    var name: String = "大头儿子"

    init() { }
}

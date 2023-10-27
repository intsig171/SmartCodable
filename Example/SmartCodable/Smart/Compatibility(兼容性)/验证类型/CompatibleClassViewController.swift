//
//  CompatibleClassViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/9/5.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


/// 结构体和Class混用
class CompatibleClassViewController: BaseCompatibilityViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let json = """
        {
          "item": { "item": { "name": "小明" } }
        }
        """
        
        
        guard let model = TopStruct.deserialize(json: json) else { return }
        
        print(model)
        print(model.item)
        print(model.item.item)
        print(model.item.item.name)

        /**
         TopStruct(item: SmartCodable_Example.CenterClass)
         SmartCodable_Example.CenterClass
         BottomStruct(name: "小明")
         小明
         */

    }
}

struct TopStruct: SmartCodable {
    var item: CenterClass = CenterClass()

    init() { }
}

class CenterClass: SmartCodable {
    var item: BottomStruct = BottomStruct()

    // 需要用required修饰
    required init() { }
}

struct BottomStruct: SmartCodable {
    var name: String = "大头儿子"

    init() { }
}

//
//  Strength_2ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/7.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


/** 给Any类型加壳
 * 如果你有对SmartAny相关的属性解析完成的进一步操作的行为。可以使用cover属性。
 * Any -> SmartAny, [String: Any] -> [String: SmartAny], [Any] -> [SmartAny]
 */
class Strength_2ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict = [
            "name": "xiao ming",
            "dict": ["key1": "value1"],
            "arr": [ ["key2": "value2"] ]
        ] as [String : Any]
        
        
        guard var model = AnyModel.deserialize(from: dict) else { return }
        print(model)
        
        
        
        let name = SmartAny(from: "新名字")
        let dict1 = ["key2": "value2"].cover
        let arr1 = [ ["key3": "value3"] ].cover
        
        model.name = name
        model.dict = dict1
        model.arr = arr1
        print(model)
    }
}

extension Strength_2ViewController {
    struct AnyModel: SmartCodable {
        var name: SmartAny = .string("")
        var dict: [String: SmartAny] = [:]
        var arr: [SmartAny] = []
    }
}



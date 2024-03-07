//
//  Strength_1ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/12/4.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


/** 关于Codable中的Any
 * Any不能实现Codable，所以在使用codable的时候，一切跟Any有关的均不允许，比如[String：Any]，[Any]
 *
 * SmartCodable提供了方案
 * 方案： 使用SmartAny替代Any，如果要获取原始值，使用.peel
 
 */
class Strength_1ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let inDict = [
            "key1": 1,
            "key2": "two",
            "key3": ["key": "1"],
            "key4": [1, 2, 3, 4]
        ] as [String : Any]
        
        let arr = [inDict]
        
        let dict = [
            "name": "xiao ming",
            "age": 20,
            "dict": inDict,
            "arr": arr
        ] as [String : Any]
        
        
        guard let model = AnyModel.deserialize(dict: dict) else { return }
        print(model.name.peel )
        print(model.age?.peel ?? 0)
        print(model.dict.peel)
        print(model.arr.peel)
    }
}

extension Strength_1ViewController {
    struct AnyModel: SmartCodable {
        var name: SmartAny = .string("")
        var age: SmartAny?
        var dict: [String: SmartAny] = [:]
        var arr: [SmartAny] = []
    }
}



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
            "key3": ["key": "one"],
            "key4": [1, 2, 3, 4]
        ] as [String : Any]
        
        let arr = [inDict]
        
        let dict = [
            "sex": true,
            "height": 184.3,
            "name": "xiao ming",
            "age": 20,
            "dict": inDict,
            "arr": arr
        ] as [String : Any]
        
        
        guard let model = AnyModel.deserialize(from: dict) else { return }
        print(model.sex?.peel ?? false)
        print(model.height)
        print(model.name.peel )
        print(model.age?.peel ?? 0)
        print(model.dict.peel)
        print(model.arr.peel)
        
        print("\n")
        print("\n")

        let encoded = model.toDictionary()
        
        let encodeDict = encoded ?? [:]
        print(encodeDict)
        print("\n")
        print("\n")

        guard let model1 = AnyModel.deserialize(from: encodeDict) else { return }
        print(model1.sex?.peel ?? false)
        print(model1.height)
        print(model1.name.peel )
        print(model1.age?.peel ?? 0)
        print(model1.dict.peel)
        print(model1.arr.peel)
    }
}

extension Strength_1ViewController {
    struct AnyModel: SmartCodable {
        var sex: SmartAny?
        var height: SmartAny?
        var name: SmartAny = .string("")
        var age: SmartAny?
        var dict: [String: SmartAny] = [:]
        var arr: [SmartAny] = []
    }
}




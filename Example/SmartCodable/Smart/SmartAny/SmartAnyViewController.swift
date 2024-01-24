//
//  SmartAnyViewController.swift
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
 * SmartCodable提供了三种方案
 * 方案1. 可以通过指定类型，比如[Sting: String],  放弃Any得使用。
 * 方案2. 或者通过范型，比如：struct AboutAny<T: Codable>。
 * 方案3. 使用SmartAny类型
 
 */
class SmartAnyViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        guard let one = AboutAny<String>.deserialize(dict: getAboutAnyOne()) else { return }
        print(one.dict1)
        print(one.dict2)
        
        
        guard let two = AboutAny<Int>.deserialize(dict: getAboutAnyTwo()) else { return }
        print(two.dict1)
        print(two.dict2)
        
        
        
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
        print(model.name?.peel ?? "")
        print(model.age.peel)
        print(model.dict.peel)
        print(model.arr.peel)
    }
}


extension SmartAnyViewController {
    func getAboutAnyOne() -> [String: Any] {
        let dict = [
            "dict1": ["a": "abc"],
            "dict2": ["b": "def"],
        ] as [String : Any]
        
        return dict
    }
    
    func getAboutAnyTwo() -> [String: Any] {
        let dict = [
            "dict1": ["a": 10],
            "dict2": ["b": 100],
        ] as [String : Any]
        
        return dict
    }
}


extension SmartAnyViewController {
    struct AboutAny<T: Codable>: SmartCodable {
        init() { }

        var dict1: [String: T] = [:]
        var dict2: [String: T] = [:]
    }


    struct AnyModel: SmartCodable {
        var name: SmartAny?
        var age: SmartAny = .int(0)
        var dict: [String: SmartAny] = [:]
        var arr: [SmartAny] = []
    }

}



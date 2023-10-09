//
//  AboutAnyViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/8/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import SmartCodable


/** 关于Codable中的Any
 * Any不能实现Codable，所以在使用codable的时候，一切跟Any有关的均不允许，比如[String：Any]，[Any]
 * 1. 可以通过指定类型，比如[Sting: String],  放弃Any得使用。
 * 2. 或者通过范型，比如：struct AboutAny<T: Codable>。
 
 */
class AboutAnyViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        guard let one = AboutAny<String>.deserialize(dict: getAboutAnyOne()) else { return }
        print(one.dict1)
        print(one.dict2)
        
        
        guard let two = AboutAny<Int>.deserialize(dict: getAboutAnyTwo()) else { return }
        print(two.dict1)
        print(two.dict2)
    }
}


extension AboutAnyViewController {
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



struct AboutAny<T: Codable>: SmartCodable {
    init() { }

    var dict1: [String: T] = [:]
    var dict2: [String: T] = [:]
}

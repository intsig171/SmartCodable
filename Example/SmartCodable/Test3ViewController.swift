//
//  Test3ViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2024/4/18.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import HandyJSON
import CleanJSON


/** 测试内容项
 1. 默认值的使用是否正常
 2. mappingForValue是否正常。
 3.
 */


import SmartCodable

class Test3ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict1: [String: Any] = [
            "arr": ["123", "<null>"]
        ]
        
        guard let model = HomeListModel.deserialize(from: dict1) else { return }
        print(model)
    }
    
    struct HomeListModel: SmartCodable {
        var arr: [String] = []
        static func mappingForValue() -> [SmartValueTransformer]? {
            [
                CodingKeys.arr <--- Tranformer()
            ]
        }
    }
}


struct Tranformer: ValueTransformable {
    func transformFromJSON(_ value: Any) -> [String]? {
        if let arr = value as? [String] {
            return arr.filter { item in
                item != "<null>"
            }
        }
        return nil
    }
    
    func transformToJSON(_ value: [String]) -> [String]? {
        return nil
    }
    
    typealias Object = [String]
    typealias JSON = [String]
}

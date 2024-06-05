//
//  TestViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/9/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SmartCodable
import HandyJSON
import CleanJSON
import BTPrint

import SmartCodable

class TestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let model = Model()
        if let dict = model.toDictionary() {
            print(dict)
        }
        
        
        
    }
    
    struct Model: SmartCodable {
        var age: Int = 100
//        var sex: Bool = true
//        var name: String = "Mccc"
  
        enum CodingKeys: String, CodingKey {
            case age = "selfAge"
        }
        
//        static func mappingForKey() -> [SmartKeyTransformer]? {
//            [
//                CodingKeys.age <--- "selfAge"
//            ]
//        }
        
        static func mappingForValue() -> [SmartValueTransformer]? {
            [
                CodingKeys.age <--- IntTransformer()
            ]
        }
    }
}



struct IntTransformer: ValueTransformable {
    
    typealias Object = Int
    typealias JSON = Int
    
    
    func transformFromJSON(_ value: Any?) -> Int? {
        return 1000
    }
    
    func transformToJSON(_ value: Int?) -> Int? {
        return 1000
    }
}

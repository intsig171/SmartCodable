//
//  Test3ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/18.
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


class Test3ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode = .none
        
        
        let model = Model()
        if let tranformValue = model.toDictionary(useMappedKeys: true) {
            print(tranformValue)
        }
            
        if let tranformValue = model.toJSONString(useMappedKeys: true, prettyPrint: true) {
            print(tranformValue)
        }
        
        print("\n 分割线 ------ \n")
        
        if let tranformValue = [model].toArray(useMappedKeys: true) {
            print(tranformValue)
        }
        
        if let tranformValue = [model].toJSONString(useMappedKeys: true, prettyPrint: true) {
            print(tranformValue)
        }
    }
    
    struct Model: SmartCodable {
        var modelKey: String = "hello"
        
        var subModel = SubModel()
        
        static func mappingForKey() -> [SmartKeyTransformer]? {
           [
            CodingKeys.modelKey <--- ["mappedKey", "mappedKey1", "mappedKey2"],
            CodingKeys.subModel <--- "mappedModel"
           ]
        }
        
        static func mappingForValue() -> [SmartValueTransformer]? {
            [
                CodingKeys.modelKey <--- AValueTransformer()
            ]
        }
    }
    
    struct SubModel: SmartCodable {
        var modelKey: String = "good luck"
        
        static func mappingForKey() -> [SmartKeyTransformer]? {
           [
            CodingKeys.modelKey <--- "mappedKey"
           ]
        }
        
        static func mappingForValue() -> [SmartValueTransformer]? {
            [
                CodingKeys.modelKey <--- BValueTransformer()
            ]
        }
    }
}



struct AValueTransformer: ValueTransformable {
    func transformFromJSON(_ value: Any) -> String? {
        return "hello Mccc"
    }
    
    func transformToJSON(_ value: String) -> String? {
        
        return "hello Mccc to Json," + value
    }
    
    typealias Object = String
    
    typealias JSON = String
}

struct BValueTransformer: ValueTransformable {
    func transformFromJSON(_ value: Any) -> String? {
        return "hello Mccc"
    }
    
    func transformToJSON(_ value: String) -> String? {
        
        return "hello Xiaoming to Json," + value
    }
    
    typealias Object = String
    
    typealias JSON = String
}

//
//  Introduce_12ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/9/26.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import Combine
import SmartCodable

class Introduce_12ViewController: BaseViewController {
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: [String: Any] = [
            "newName": 1,
            "age": "333333"
        ]
        
        if let model = PublishedModel.deserialize(from: dict) {
            print("反序列化后的 name 值: \(model.name)")
            
            // 正确访问 name 属性的 Publisher
            model.$name
                .sink { newName in
                    print("name 属性发生变化，新值为: \(newName)")
                }
                .store(in: &cancellables)
            
            // 修改 model 的 name 属性
            model.name = "Updated iOS Developer"
        }
    }
}

// 定义 PublishedModel，并实现反序列化
class PublishedModel: ObservableObject, SmartCodable {
    required init() {}
    
    @SmartPublished @SmartAny
    var name: Any = "iOS Developer"
        
    static func mappingForKey() -> [SmartKeyTransformer]? {
        [CodingKeys.name <--- "newName"]
    }
    
//    static func mappingForValue() -> [SmartValueTransformer]? {
//        [
//            CodingKeys.name <--- PublishedValueTransformer(),
//        ]
//    }
}

struct PublishedValueTransformer: ValueTransformable {
    func transformFromJSON(_ value: Any) -> String? {
        return "good"
    }
    
    func transformToJSON(_ value: String) -> String? {
        return "gooooooood"
    }
    
    typealias Object = String
    
    typealias JSON = String
}

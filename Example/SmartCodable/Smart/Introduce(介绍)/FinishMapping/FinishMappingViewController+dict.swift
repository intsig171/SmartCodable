//
//  FinishMappingViewController+dict.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/12/15.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


extension FinishMappingViewController {
    func singleDict() {
        // 1⃣️单容器非可选情况验证 （解析成功 && 解析失败）
        let singleJson = """
        {
          "name": "小明",
          "age": 10
        }
        """
        
        guard let single = FinishMappingSingle.deserialize(json: singleJson) else { return }
        print(single.name)

   
    }

    
    struct FinishMappingSingle: SmartDecodable {

        var name: String = ""
        var age: Int = 0

        mutating func didFinishMapping() {
            name = "我是\(name)"
        }
    }
}


extension FinishMappingViewController {
    func compositeDict() {
        let json = """
        {
          "name": "小明",
          "age": 10,

          "two": {
             "name": "哈哈",
             "age": 10,
          }

        }
        """
        
        guard let model = FinishMappingComposite.deserialize(json: json) else { return }
        print(model.two?.name ?? "")
    }

    
    struct FinishMappingComposite: SmartDecodable {

        init() { }
        var name: String = ""
        var age: Int = 0
        
        var one = CompositeOne()
        @SmartOptional var two: CompositeOne?

        mutating func didFinishMapping() {
            name = "我是 \(name), 我\(age)岁了"
        }
    }
    
    
    class CompositeOne: SmartDecodable {

        required init() { }
        var name: String = ""
        var age: Int = 0

        func didFinishMapping() {
            name = "我是 \(name), 我\(age)岁了"
        }
    }
}

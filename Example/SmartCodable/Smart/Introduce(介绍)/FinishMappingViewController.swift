//
//  FinishMappingViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2023/8/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation


import SmartCodable


/** didFinishMap的用法
 * 含义
 * - 1. 当前类，结束decode之后的回调
 *
 * 作用
 * - 1. 提供类在decode之后，进一步对值进行处理的能力
 *
 * 场景覆盖：
 * - 1. 单容器 （解析成功 && 解析失败）
 * - 2. 单可选容器 （解析成功 && 解析失败）
 * - 3. 嵌套容器 （解析成功 && 解析失败）
 * - 4. 嵌套可选容器 （解析成功 && 解析失败）
 */

class FinishMappingViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode = .none
        
        // 1⃣️ 单容器验证
        single()
        
        nest()
        

    }
    
    func nest() {
        
        let nestJson = """
        {
          "item1": {
              "name": "小明",
              "age": 10
           },
          "item2": {"name": "小明"},
          "item3": {
              "name": "小明",
              "age": 10
           },
          "item4": {},
        }
        """
        
        
        guard let value = FinishMappingNest.deserialize(json: nestJson) else { return }
        
        print(value.item1Desc)
        print(value.item2Desc ?? "")
        print(value.item3Desc)
        print(value.item4Desc ?? "")
    }
    
    
    func single() {
        // 1⃣️单容器非可选情况验证 （解析成功 && 解析失败）
        let singleJson = """
        {
          "name": "小明",
          "age": 10
        }
        """
        
        let singleJsonTwo = """
        { }
        """
        
        guard let single = FinishMappingSingle.deserialize(json: singleJson) else { return }
        print(single.desc)
        // 10的小明
        
        guard let singleTwo = FinishMappingSingle.deserialize(json: singleJsonTwo) else { return }
        print(singleTwo.desc)
        // 0岁的人

        // 2⃣️单容器可选情况验证 （解析成功 && 解析失败）
        guard let single = FinishMappingSingleOptional.deserialize(json: singleJson) else { return }
        print(single.desc)
        // 10岁的小明

        guard let singleTwo = FinishMappingSingleOptional.deserialize(json: singleJsonTwo) else { return }
        print(singleTwo.desc)
        // 没有岁数的人
    }
}


class FinishMappingSingle: SmartDecodable {

    var name: String = ""
    var age: Int = 0
    var desc: String = ""
    
    enum CodingKeys: CodingKey {
        case name
        case age
    }
    
    required init() { }
    
    func didFinishMapping() {
                
        if name.isEmpty {
            desc = "\(age)岁的" + "人"
        } else {
            desc = "\(age)岁的" + name
        }
    }
}

class FinishMappingSingleOptional: SmartDecodable {

    var name: String?
    var age: Int?
    var desc: String = ""
    
    enum CodingKeys: CodingKey {
        case name
        case age
    }
    
    required init() { }
    
    func didFinishMapping() {
        
        if let tempName = name {
            if let tempAge = age {
                desc = "\(tempAge)岁的" + tempName
            } else {
                desc = "没有岁数的" + tempName
            }
        } else {
            if let tempAge = age {
                desc = "\(tempAge)岁的人"
            } else {
                desc = "没有岁数的人"
            }
        }
    }
}







struct FinishMappingNest: SmartDecodable {
    
    enum CodingKeys: CodingKey {
        case item1
        case item2
        case item3
        case item4
    }

    

    var item1: FinishMappingSingle = FinishMappingSingle()
    @SmartOptional var item2: FinishMappingSingle?
    var item3: FinishMappingSingleOptional = FinishMappingSingleOptional()
    @SmartOptional var item4: FinishMappingSingleOptional?
    
    var item1Desc: String = ""
    var item2Desc: String?
    var item3Desc: String = ""
    var item4Desc: String?

    
    mutating func didFinishMapping() {
        
        item1Desc = item1.desc
        item2Desc = item2?.desc
        item3Desc = item3.desc
        item4Desc = item4?.desc
        
    }
}

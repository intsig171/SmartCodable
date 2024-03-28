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

//to 完成三种功能的示例， 完成readme
//
//* 1. ✅ 支持自定义解析路径
//*   - 说明：可以像HandyJSON一样，跨路径解析。例如 "nameDict.name" 将nameDict字典里的name自动解析到name属性上。
//*   - 结论：在数据层做文章，将路径对应的value获取到，添加到当前的字典中（判断字典是否有这个key）。
//*
//* 2. ✅ 支持全局的key映射
//*   - 说明：蛇形转驼峰，首字母大写转小写
//*   - 结论：SmartDecodingOption中新增keyStrategy，支持全局key的解码策略。
//*
//* 3. ✅ 支持手动加壳
//*   - 说明：Any -> SmartAny, [Any] -> [SmartAny], [String: Any] -> [String: SmartAny]
//*   - 结论：新增cover方法。


class TestViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: [String: Any] = [
            "Name": "Mccc",
            "Age": 10,
            "sub": [
                "Name": "小明",
                "Age": 20
            ],
            "sub1": [
                "Name": "小李",
                "Age": 20
            ]
        ]
        
        
        
        guard var model = HandyModel.deserialize(from: dict) else { return }
        print(model)
        


    }
}

extension TestViewController {
    
    struct SmartModel: SmartCodable {
        var name: String = ""
        var age: Int = 0
        var sub: [String: SmartAny]?
        
        static func mapping() -> [MappingRelationship]? {
            [ CodingKeys.name <--- "sub1.Name" ]
        }
    }
    
    struct SmartSubModel: SmartCodable {
        var realMame: String = ""
        var age: Int = 0
        
        static func mapping() -> [MappingRelationship]? {
            [ CodingKeys.realMame <--- "Name" ]
        }
    }
}
extension TestViewController {
    
    struct HandyModel: HandyJSON {
        var name: String = ""
        var age: Int = 0
        var sub: HandySubModel?
        
        mutating func mapping(mapper: HelpingMapper) {
            mapper <<<
                self.name <-- "Name"
        }
    }
    
    struct HandySubModel: HandyJSON {
        var realMame: String = ""
        var age: Int = 0
        
        mutating func mapping(mapper: HelpingMapper) {
            mapper <<<
                self.realMame <-- "Name"
        }
    }
}

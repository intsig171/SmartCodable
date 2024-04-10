//
//  KeyDecodingStrategyViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/28.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import Foundation
import SmartCodable

/** 全局的Key映射关系
 * 1. 首字母大写转小写
 * 2. 蛇形转驼峰命名
 * 3. 💗如有其他需求，可联系作者定制。
 */

class KeyDecodingStrategyViewController: BaseCompatibilityViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let dict: [String: Any] = [
            "Name": "Mccc",
            "Age": 10,
            "Sex": "男",
            "sub": [
                "Name": "小李"
            ]
        ]
        
        // 首字母大写转小写
        let option: SmartDecodingOption = .key(.firstLetterLower)
        guard let model = Model.deserialize(from: dict, options: [option]) else { return }
        print(model)


        
        
        let dict1: [String: Any] = [
            "nick_name": "Mccc",
            "self_age": 10,
            "sub_info": [
                "real_name": "小李"
            ]
        ]
        
        // 蛇形转驼峰命名
        let option1: SmartDecodingOption = .key(.fromSnakeCase)
        guard let model1 = TwoModel.deserialize(from: dict1, options: [option1]) else { return }
        print(model1)
    }
}


extension KeyDecodingStrategyViewController {
    struct Model: SmartCodable {
        var name: String = ""
        var age: Int = 0
        var sex: String = ""
        var sub: SubModel?
    }
    
    struct SubModel: SmartCodable {
        var name: String = ""
    }
}


extension KeyDecodingStrategyViewController {
    struct TwoModel: SmartCodable {
        var nickName: String = ""
        var selfAge: Int = 0
        var subInfo: SubTwoModel?
    }
    
    struct SubTwoModel: SmartCodable {
        var realName: String = ""
    }
}

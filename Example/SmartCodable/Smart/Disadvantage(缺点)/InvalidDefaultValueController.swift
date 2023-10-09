//
//  InvalidDefaultValueController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/9/8.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation

import SmartCodable


// 模型设置的默认值，在解析失败的时候无效。
// Codable在进行解码的时候，是无法知道这个属性的。所以在decode的时候，如果解析失败，使用默认值进行填充时，拿不到这个默认值。只能自己生成一个对应类型的默认值。

class InvalidDefaultValueController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let json = """
        {
          
        }
        """
        
        guard let model = InvalidDefaultValueModel.deserialize(json: json) else { return }
        print("model.name的值为： \(model.name)")

    }
}





struct InvalidDefaultValueModel: SmartCodable {
    var name: String = "没有名字"
}

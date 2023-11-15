//
//  FieldNameMapViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2023/8/8.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable




/** 修改字段映射关系
 * 使用CodingKeys：修改当前Model的属性。建议使用。
 * 使用keyDecodingStrategy： 当前解析的所有Model生效（包含嵌套Model），
 
 */

class FieldNameMapViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode = .none

        let json = """
        {
          "nick_name": "小明"
        }
        """
        
        // 1. CodingKeys 映射
        guard let feedOne = FeedOne.deserialize(json: json) else { return }
        print("feedOne.name = \(feedOne.name)")

        // 2. 通过初始化decoder, 使用keyDecodingStrategy的驼峰命名
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let feedTwo = FeedTwo.deserialize(json: json, decoder: decoder) else { return }
        print("feedTwo.nickName = \(feedTwo.nickName)")
        
        
        // 3. 通过初始化decoder, 使用keyDecodingStrategy的自定义策略
        let decoder2 = JSONDecoder()
        decoder2.keyDecodingStrategy = .mapper(
            [["nick_name"]: "name"]
        )
        guard let feedThree = FeedThree.deserialize(json: json, decoder: decoder2) else { return }
        print("feedThree.name = \(feedThree.name)")
    }
}



extension FieldNameMapViewController {

    struct FeedOne: SmartCodable {
        var name: String = ""
        enum CodingKeys: String, CodingKey {
            case name = "nick_name"
        }
    }
    
    struct FeedTwo: SmartCodable {
        var nickName: String = ""
    }
    
    struct FeedThree: SmartCodable {
        var name: String = ""
    }
}




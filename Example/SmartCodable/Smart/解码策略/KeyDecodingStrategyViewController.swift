//
//  File.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/11/30.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable




/** 修改字段映射关系
 * 使用CodingKeys：修改当前Model的属性。建议使用。
 * 使用keyDecodingStrategy： 当前解析的所有Model生效（包含嵌套Model），
 
 */

class KeyDecodingStrategyViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode = .none

        let dict: [String: Any] = [
            "nick_name": "Mccc1",
            "two": [
                "realName": "Mccc2",
                "three": [
                    ["nickName": "Mccc3"]
                ]
            ]
        ]
        
        // 1. CodingKeys 映射
        guard let feedOne = FeedOne.deserialize(dict: dict) else { return }
        print("feedOne = \(feedOne)")
        print("\n")
        // feedOne = FeedOne(name: "Mccc1", two: FeedOne.Two(name: "Mccc2", three: [Three(name: "Mccc3")]))

        
        
        // 2. 蛇形命名转驼峰命名
        guard let feedTwo = FeedTwo.deserialize(dict: dict, keyStrategy: .convertFromSnakeCase) else { return }
        print("feedTwo = \(feedTwo)")
        print("\n")
        // feedTwo = FeedTwo(nickName: "Mccc1", two: Two(nickName: "", three: [Three(nickName: "Mccc3")]))
        // "Mccc2" 没能解析成功，因为字段未匹配上。

        
        // 3. 使用SmartGlobalMap，本次解析全部替换。
        let keys = [
            SmartGlobalMap(from: "nick_name", to: "nickName"),
            SmartGlobalMap(from: "realName", to: "nickName"),
        ]
        guard let feedTwo = FeedTwo.deserialize(dict: dict, keyStrategy: .globalMap(keys)) else { return }
        print("feedTwo = \(feedTwo)")
        print("\n")
        // feedTwo = FeedTwo(nickName: "Mccc1", two: Two(nickName: "Mccc2", three: [Three(nickName: "Mccc3")]))



        // 4. 使用SmartGlobalMap，本次解析全部替换。
        let keys2 = [
            SmartExactMap(path: "", from: "nick_name", to: "nickName"),
            SmartExactMap(path: "two", from: "realName", to: "nickName"),
        ]
        guard let feedThree = FeedTwo.deserialize(dict: dict, keyStrategy: .exactMap(keys2)) else { return }
        print("feedThree = \(feedThree)")
        print("\n")
        // feedThree = FeedTwo(nickName: "Mccc1", two: Two(nickName: "Mccc2", three: [Three(nickName: "Mccc3")]))

    }
}



extension KeyDecodingStrategyViewController {

    struct FeedOne: SmartCodable {
        var nickName: String = ""
        var two: Two = Two()
        
        enum CodingKeys: String, CodingKey {
            case nickName = "nick_name"
            case two
        }
        
        struct Two: SmartCodable {
            var nickName: String = ""
            var three: [Three] = []
            
            enum CodingKeys: String, CodingKey {
                case nickName = "realName"
                case three
            }
            
            struct Three: SmartCodable {
                var nickName: String = ""
            }
        }
    }
}


extension KeyDecodingStrategyViewController {

    struct FeedTwo: SmartCodable {
        var nickName: String = ""
                
        var two: Two = Two()
        
        struct Two: SmartCodable {
            var nickName: String = ""
            
            var three: [Three] = []
            struct Three: SmartCodable {
                var nickName: String = ""
            }
        }
    }
}


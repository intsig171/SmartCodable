//
//  CaseFour_KeyStrategyViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

import SmartCodable




/** 修改字段映射关系
 * 使用CodingKeys：修改当前Model的属性。建议使用。
 * 使用keyDecodingStrategy： 当前解析的所有Model生效（包含嵌套Model），
 
 */

class CaseFour_KeyStrategyViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode = .none


        
//        test1()

        test2()
    }
}

extension CaseFour_KeyStrategyViewController {
    
    struct CodingKeysModel: SmartCodable {
        var jsonString: JSONString?
    }
    
    struct Nested: Codable {
        var nestedKey: String?
    }
    
    struct JSONString: SmartCodable {
        var jsonKey: String?
    }
    
    
    func test2()  {
        
        /** 在 Swift 中，使用 #""" 和 """ 创建 JSON 字符串时，主要区别在于处理字符串内部的引号和特殊字符。这两种方式都是用来定义多行字符串，但它们处理转义序列的方式不同。
         
         使用 #"""（带有井号的多行字符串）:

         在这种方式中，Swift 不会将 \ 视为特殊字符。这意味着您不需要对字符串内部的引号进行额外的转义。
         示例：#""" {"jsonString": "{\"json_key\":\"sleep\"}"} """#
         在这个例子中，{\"json_key\":\"sleep\"} 被直接识别为字符串的一部分，不需要额外的转义。
         使用 """（普通多行字符串）:

         在普通多行字符串中，\ 仍然被视为转义字符。因此，您需要对内部的引号进行转义。
         示例：""" {"jsonString": "{\\"json_key\\":\\"sleep\\"}"} """
         在这个例子中，每个引号前都需要加上 \ 来进行转义，以便将其包含在字符串中。
         */
        
        
        let data = #"""
                    {
                       "json_string": "{\"json_key\":\"sleep\"}"
                    }
                """#.data(using: .utf8)!
        
        let dict1 = data.toDictionary() ?? [:]

        
        let decoder = SmartJSONDecoder()
  
        let map = SmartExactMap(path: "", from: "json_string", to: "jsonString")
        let map1 = SmartExactMap(path: "json_string", from: "json_key", to: "jsonKey")
        let option = JSONDecoder.SmartDecodingKey.exactMap([map, map1])
        let system  = option.toSystem()

        decoder.keyDecodingStrategy = system
        
        if let model = try? decoder.decode(CodingKeysModel.self, from: dict1) {
            print(model)
        }
        
    }
}





extension CaseFour_KeyStrategyViewController {
    
    func test1() {
        let dict: [String: Any] = [
            "nick_name": "Mccc1",
            "two": [
                "realName": "Mccc2",
                "three": [
                    ["nick_name": "Mccc3"]
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
            SmartExactMap(path: "two.three", from: "nick_name", to: "nickName"),
        ]
        guard let feedThree = FeedTwo.deserialize(dict: dict, keyStrategy: .exactMap(keys2)) else { return }
        print("feedThree = \(feedThree)")
        print("\n")
        // feedThree = FeedTwo(nickName: "Mccc1", two: Two(nickName: "Mccc2", three: [Three(nickName: "Mccc3")]))
    }
    

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
                enum CodingKeys: String, CodingKey {
                    case nickName = "nick_name"
                }
            }
        }
    }
}


extension CaseFour_KeyStrategyViewController {

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




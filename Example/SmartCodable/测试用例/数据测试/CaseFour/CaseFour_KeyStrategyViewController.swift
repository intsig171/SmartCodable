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
        
        使用CodingKeys进行值映射()

        使用mapping方法进行值映射()
        
        值为json字符串的模型化解析key映射()
    }
}

extension CaseFour_KeyStrategyViewController {
    
    struct CodingKeysModel: SmartCodable {
        var jsonString: JSONString?
        
        static func mapping() -> [MappingRelationship]? {
            [ CodingKeys.jsonString <-- "json" ]
        }
    }
    
    struct JSONString: SmartCodable {
        var jsonKey: String?
        static func mapping() -> [MappingRelationship]? {
            [ CodingKeys.jsonKey <-- "json_key" ]
        }

    }
    
    
    func 值为json字符串的模型化解析key映射()  {
        
        let data = #"""
                    {
                       "json": "{\"json_key\":\"sleep\"}"
                    }
                """#.data(using: .utf8)!
        
        
        if let model = CodingKeysModel.deserialize(data: data) {
            print(model)
        }
        
    }
}




extension CaseFour_KeyStrategyViewController {
    
    struct FeedTwo: SmartCodable {
        var nickName: String = ""
                
        var two: Two = Two()
        
        static func mapping() -> [MappingRelationship]? {
            [ CodingKeys.nickName <-- "nick_name" ]

        }
        
        struct Two: SmartCodable {
            var nickName: String = ""
            
            var three: [Three] = []
            static func mapping() -> [MappingRelationship]? {
                [ CodingKeys.nickName <-- "realName" ]
            }
            
            
            struct Three: SmartCodable {
                var nickName: String = ""
                static func mapping() -> [MappingRelationship]? {
                    [ CodingKeys.nickName <-- "name" ]
                }
            }
        }
    }
    
    func 使用mapping方法进行值映射() {
        
        let dict: [String: Any] = [
            "nick_name": "Mccc1",
            "two": [
                "realName": "Mccc2",
                "three": [
                    ["name": "Mccc3"]
                ]
            ]
        ]
        // 2. 使用mapping
        guard let feedTwo = FeedTwo.deserialize(dict: dict) else { return }
        print("feedTwo = \(feedTwo)")
        print("\n")
        // feedTwo = FeedTwo(nickName: "Mccc1", two: Two(nickName: "", three: [Three(nickName: "Mccc3")]))
        // "Mccc2" 没能解析成功，因为字段未匹配上。
    }
}


extension CaseFour_KeyStrategyViewController {
    
    func 使用CodingKeys进行值映射() {
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

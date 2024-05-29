//
//  Support_KeyStrategyViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

import SmartCodable




/** todo
 
 */


class KeyMapping_firstLetterViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        使用CodingKeys进行值映射()

        使用mapping方法进行值映射()
        
        值为json字符串的模型化解析key映射()
    }
}

extension KeyMapping_firstLetterViewController {
    
    struct CodingKeysModel: SmartCodable {
        var jsonString: JSONString?
        
        static func mappingForKey() -> [SmartKeyTransformer]? {
            [ CodingKeys.jsonString <--- "json" ]
        }
    }
    
    struct JSONString: SmartCodable {
        var jsonKey: String?
        static func mappingForKey() -> [SmartKeyTransformer]? {
            [ CodingKeys.jsonKey <--- "json_key" ]
        }

    }
    
    
    func 值为json字符串的模型化解析key映射()  {
        
        let data = #"""
                    {
                       "json": "{\"json_key\":\"sleep\"}"
                    }
                """#.data(using: .utf8)!
        
        
        if let model = CodingKeysModel.deserialize(from: data) {
            print(model)
        }
        
    }
}




extension KeyMapping_firstLetterViewController {
    
    struct FeedTwo: SmartCodable {
        var nickName: String = ""
                
        var two: Two = Two()
        
        static func mappingForKey() -> [SmartKeyTransformer]? {
            [ CodingKeys.nickName <--- "nick_name" ]

        }
        
        struct Two: SmartCodable {
            var nickName: String = ""
            
            var three: [Three] = []
            static func mappingForKey() -> [SmartKeyTransformer]? {
                [ CodingKeys.nickName <--- "realName" ]
            }
            
            
            struct Three: SmartCodable {
                var nickName: String = ""
                static func mappingForKey() -> [SmartKeyTransformer]? {
                    [ CodingKeys.nickName <--- "name" ]
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
        guard let feedTwo = FeedTwo.deserialize(from: dict) else { return }
        print("feedTwo = \(feedTwo)")
        print("\n")
        // feedTwo = FeedTwo(nickName: "Mccc1", two: Two(nickName: "", three: [Three(nickName: "Mccc3")]))
        // "Mccc2" 没能解析成功，因为字段未匹配上。
    }
}


extension KeyMapping_firstLetterViewController {
    
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
        guard let feedOne = FeedOne.deserialize(from: dict) else { return }
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

//
//  CodableBaseViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2023/8/14.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit





class CodableBaseViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        let dict = [
            "name": "xiaoming",
        ] as [String : Any]
        
        let jsonStr = dict.bt_toJSONString() ?? ""
        
        guard let jsonData = jsonStr.data(using: .utf8) else { return }
        
        let decoder = JSONDecoder()
        
        do {
            let feed = try decoder.decode(BaseFeed.self, from: jsonData)
            print(feed)
        } catch let error {
            print(error)
        }
        
        
        
        
        
        //        let dict = [
        //            "read_name": "xiaoming",
        //            "age": 15,
        //            "sex": true,
        //        ] as [String : Any]
        //
        //        guard let feed = dict.decode(type: BaseFeed.self) else { return }
        //        print(feed)
        
        
        
        //
        //        let jsonString = "[185, 98.2, 30]"
        //        guard let model1 = jsonString.decode(type: BaseFeedOne.self) else { return }
        //        print(model1)
        
        
        
        
        
        //        let dict2 = [
        //            "age": 10,
        //        ] as [String : Any]
        //
        //        guard let feed2 = dict2.decode(type: BaseFeedTwo.self) else { return }
        //        print(feed2)
        
        
        
        
        
    }
    
}



/** Codeable
 public typealias Codable = Decodable & Encodable,
 ' Codable '是' Encodable '和' Decodable '协议的类型别名。
 */


/// ===== 基本使用
struct BaseFeed: Codable {
    var name: String = ""
    var age: Int = 0
    var sex: Bool = false
    
    
    enum CodingKeys: String, CodingKey {
        // 对字段重命名
        case name
        //        case age = "age"
        
        // 不声明sex，表示不解析sex字段。
        // case sex
    }
    
    init(from decoder: Decoder) throws {
        
        //        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // typeMismatch(Swift.Array<Any>, Swift.DecodingError.Context(codingPath: [], debugDescription: "Expected to decode Array<Any> but found a dictionary instead.", underlyingError: nil))
        //        let containerArr = try decoder.unkeyedContainer()
        let container = try decoder.singleValueContainer()
        
        // typeMismatch(Swift.String, Swift.DecodingError.Context(codingPath: [], debugDescription: "Expected to decode String but found a dictionary instead.", underlyingError: nil))
        self.name = try container.decode(String.self)
        
        
        
        // [CodingKeys(stringValue: "age", intValue: nil), CodingKeys(stringValue: "read_name", intValue: nil)]
        // 是否为null
        let nameNull = try container.decode(String.self)
        print(nameNull)
        
        // 单个属性的解码，必须
        self.name = try container.decode(String.self)
        //        self.age = try container.decode(Int.self, forKey: .age)
        
        print(container.codingPath)
    }
}


/// ===== unkeyedContainer
struct BaseFeedOne: Codable {
    var age: Int = 0
    var height: Int = 0
    var weight: CGFloat = 0
    
    
    
    init(from decoder: Decoder) throws {
        
        /// 是用于解码Codable对象中的无键容器的类型。 它允许您按照它们出现的顺序访问和解码容器中的值。要解码无键容器，您可以使用UnkeyedDecodingContainer协议提供的decode方法。在decoder上调用unkeyedContainer()方法以获取无键容器，然后使用decode方法按照容器中的顺序逐个解码值。请注意，与decode一起使用的类型应与无键容器中的值的类型匹配。
        var container = try decoder.unkeyedContainer()
        
        
        /** 解码顺序，按照实现的顺序一一对应。
         *
         *  "[185, 98.2, 30]"
         *  BaseFeedOne(age: 30, height: 185, weight: 98.2)
         *
         */
        
        /** 异常情况
         * 少一个值的情况。 valueNotFound(Swift.Int, Swift.DecodingError.Context(codingPath: [_JSONKey(stringValue: "Index 2", intValue: 2)], debugDescription: "Unkeyed container is at end.", underlyingError: nil))
         *
         * 类型不匹配的情况： dataCorrupted(Swift.DecodingError.Context(codingPath: [_JSONKey(stringValue: "Index 2", intValue: 2)], debugDescription: "Parsed JSON number <30.1> does not fit in Int.", underlyingError: nil))
         */
        height = try container.decode(Int.self)
        weight = try container.decode(CGFloat.self)
        age = try container.decode(Int.self)
    }
}







struct BaseFeedTwo: Codable {
    var age: Int = 0
    
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        age = try container.decode(Int.self, forKey: .age)
        
        /** decoder.userInfo是什么呢？
         (lldb) po decoder.userInfo
         ▿ 1 element
         ▿ 0 : 2 elements
         ▿ key : CodingUserInfoKey
         - rawValue : "test"
         ▿ value : 1 element
         ▿ 0 : 2 elements
         - key : "age"
         - value : 10
         */
        
        if let info = decoder.userInfo[CodingUserInfoKey.init(rawValue: "test")!] {
            print(info)
        }
        
    }
}


/// ======》 nestedContainer
struct BaseThreePerson: Codable {
    var name: String
    var age: Int
    var address: BaseThreeAddress
}

struct BaseThreeAddress: Codable {
    var street: String
    var city: String
}

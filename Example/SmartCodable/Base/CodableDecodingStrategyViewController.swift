//
//  CodableDecodingStrategyViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2023/8/15.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class CodableDecodingStrategyViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        

//        keyDecodingStrategy()
    

        dataDecodingStrategy()
        
    }
}

//MARK: - dataDecodingStrategy
extension CodableDecodingStrategyViewController {
    func dataDecodingStrategy() {
        
        let dict = [
//            "time": "2022-01-01T12:00:00Z",
            "timestamp": 1641024000,
        ] as [String : Any]
        let jsonStr = dict.bt_toJSONString() ?? ""

        guard let jsonData = jsonStr.data(using: .utf8) else {
            return
        }
        
        
        do {
            let decoder = JSONDecoder()
            
            decoder.dateDecodingStrategy = .secondsSince1970

            
            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let feed = try decoder.decode(DecodingStrtegyDateFeed.self, from: jsonData)
            print(feed)
        } catch let error {
            print(error)
            return
        }
    }
}

struct DecodingStrtegyDateFeed: Codable {
//    var time: Date
    var timestamp: Date
}





//MARK: - keyDecodingStrategy
extension CodableDecodingStrategyViewController {
    func keyDecodingStrategy() {
        
        let dict = [
            "read_name": "xiaoming",
            "age": 10
        ] as [String : Any]
        let jsonStr = dict.bt_toJSONString() ?? ""

        guard let jsonData = jsonStr.data(using: .utf8) else {
            return
        }
        
        
        /**
         
         /// 用于在解码之前自动更改密钥值的策略。
         public enum KeyDecodingStrategy : Sendable {

             /// 使用每种类型指定的键。这是默认策略。
             case useDefaultKeys

             case convertFromSnakeCase

             @preconcurrency case custom(@Sendable (_ codingPath: [CodingKey]) -> CodingKey)
         }
         */
        
        do {
            let decoder = JSONDecoder()
            /// 默认的
//            decoder.keyDecodingStrategy = .useDefaultKeys
            /// 小驼峰 read_name -》 readName
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            /// 自定义 需要返回CodingKey类型。
            decoder.keyDecodingStrategy = .custom({ codingPath in
                
                for path in codingPath {
                    if path.stringValue == "read_name" {
                        return CustomJSONKey.init(stringValue: "readName")!
                    } else {
                        return path
                    }
                }
                return CustomJSONKey.super
            })
            let feed = try decoder.decode(DecodingStrtegyFeed.self, from: jsonData)
            print(feed)
        } catch let error {
            print(error)
            return
        }
    }
}

struct DecodingStrtegyFeed: Codable {
    var readName: String = ""
    var age: Int = 0
}


struct CustomJSONKey : CodingKey {
    
    public var stringValue: String
    
    public var intValue: Int?
    
    public init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    public init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
    
    public init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }
    
    init(index: Int) {
        self.stringValue = "Index \(index)"
        self.intValue = index
    }
    
    static let `super` = CustomJSONKey(stringValue: "super")!
}

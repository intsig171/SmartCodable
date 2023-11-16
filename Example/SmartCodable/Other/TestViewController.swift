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




class TestViewController : BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        let json = """
        {
          "success" : true,
          "data" : {
            "last_id" : "2022-01-20 05:36:46",
            "datalist" : [
              {
                "goods_name" : "妙投会员",
                "goods_type" : "",
                "create_time" : "2022-04-11 15:41:16",
                "is_buy_single" : false,
                "type" : 3,
                "total_price" : 0.01
              },
              {
                "goods_name" : "妙投会员",
                "goods_type" : "",
                "create_time" : "2022-04-11 15:36:32",
                "is_buy_single" : false,
                "type" : 3,
                "total_price" : 0.01
              },
              {
                "goods_name" : "妙投会员",
                "goods_type" : "",
                "create_time" : "2022-04-11 15:31:25",
                "is_buy_single" : false,
                "type" : 3,
                "total_price" : 0.01
              },
              {
                "goods_name" : "妙投会员",
                "goods_type" : "",
                "create_time" : "2022-04-11 15:26:47",
                "is_buy_single" : false,
                "type" : 3,
                "total_price" : 0.01
              },
              {
                "goods_name" : "妙投会员",
                "goods_type" : "",
                "create_time" : "2022-04-11 15:21:47",
                "is_buy_single" : false,
                "type" : 3,
                "total_price" : 0.01
              },
              {
                "goods_name" : "妙投会员",
                "goods_type" : "",
                "create_time" : "2022-04-11 15:17:26",
                "is_buy_single" : false,
                "type" : 3,
                "total_price" : 0.01
              },
              {
                "goods_name" : "妙投会员",
                "goods_type" : "",
                "create_time" : "2022-04-11 15:12:24",
                "is_buy_single" : false,
                "type" : 3,
                "total_price" : 0.01
              },
              {
                "goods_name" : "妙投会员",
                "goods_type" : "",
                "create_time" : "2022-04-11 15:04:58",
                "is_buy_single" : false,
                "type" : 3,
                "total_price" : 0.01
              },
              {
                "goods_name" : "妙投会员",
                "goods_type" : "",
                "create_time" : "2022-04-11 14:41:36",
                "is_buy_single" : false,
                "type" : 3,
                "total_price" : 0.01
              },
              {
                "goods_name" : "妙投会员",
                "goods_type" : "",
                "create_time" : "2022-01-20 05:36:46",
                "is_buy_single" : false,
                "type" : 3,
                "total_price" : 0.01
              }
            ],
            "cur_page" : 1,
            "total_page" : 3,
            "pagesize" : 10,
            "total" : 24
          },
          "message" : "请求成功"
        }

        """
        
        let dict = json.bt_toDictionary() ?? [:]
       
        let dataDict = dict["data"] as? [String: Any] ?? [:]
        let list: [Any] = dataDict["datalist"] as? [Any] ?? []

        let strategy: SmartKeyDecodingStrategy = .convertFromSnakeCase
//        let strategy: SmartKeyDecodingStrategy = .custom("total_price", "totalPrice")
        
        guard let models = [HXTradingRecordModel].deserialize(array: list, strategy: strategy) as? [HXTradingRecordModel] else { return }
        print(models)
    }
    
    
}


struct HXTradingRecordModel: SmartCodable {
    init() {
    }
    
    var funVer: String = ""
    var goodsType: String = ""
    var goodsName: String = ""
    var totalPrice: String = ""
    var createTime: String = ""
    var isBuySingle: Bool = false
    var type: Int = 0
    
    
//    enum CodingKeys: String, CodingKey {
//        case totalPrice = "total_price"
//    }
    
    
//    enum CodingKeys: String, CodingKey {
////        case fun_ver
//        case goods_name
//        case total_price
//        case is_buy_single
//        case type
//        case goodsType = "goods_type"
//        case createTime = "create_time"
//    }

}
extension String {
    /// JSONString转换为字典
    fileprivate func bt_toDictionary() -> Dictionary<String, Any>? {
        guard let jsonData:Data = data(using: .utf8) else { return nil }
        if let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
            if let temp = dict as? Dictionary<String, Any> {
                return temp
            }
        }
        return nil
    }

    /// JSONString转换为数组
    fileprivate func toArray() -> Array<Any>? {
        guard let jsonData:Data = data(using: .utf8) else { return nil }
        if let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
            if let temp = array as? Array<Any> {
                return temp
            }
        }
        return nil
    }
}

//
//  DictionaryAndModelViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/9/6.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


/** 模型和json之间互相转化
 * 1. 验证 字典转模型， 此时的模型转字典。
 * 2. 验证json字符串转模型，模型转json字符串
 * 3. 验证数组字典转模型数组，数组模型转数组字典，字典数组转json字符串，json字符串转模型数组。
 */
class DictionaryAndModelViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict = [
            "name": "xiaoming",
            "className": "35 class",
            "detail": ["detail": "my name is xiaoming"],
            "love": [["name": "basketball", "time": "7 years"], ["name": "football", "time": "3 years"]]
        ] as [String : Any]
        
       

        // 字典转json字符串
        guard let json = dict.bt_toJSONString() else { return }
        print(json)
        /**
         {"love":[{"time":"7 years","name":"basketball"},{"time":"3 years","name":"football"}],"detail":{"detail":"my name is xiaoming"},"className":"35 class","name":"xiaoming"}
         */
        
        
        
        // 字典转模型
        guard let xiaoMing = JsonToModel.deserialize(dict: dict) else { return }
        print(xiaoMing)
        /**
         JsonToModel(name: "xiaoming", className: "35 class", detail: SmartCodable_Example.JsonToModelDetail(detail: "my name is xiaoming"), love: [["time": "7 years", "name": "basketball"], ["time": "3 years", "name": "football"]])
         */
        
        
        // 模型转字典
        let studentDict = xiaoMing.toDictionary() ?? [:]
        print(studentDict)
        /**
         ["detail": {
             detail = "my name is xiaoming";
         }, "className": 35 class, "love": <__NSArrayI 0x6000032fbb60>(
         {
             name = basketball;
             time = "7 years";
         },
         {
             name = football;
             time = "3 years";
         }
         )
         , "name": xiaoming]
         */
        
        
        
        // 模型转json字符串
        let json1 = xiaoMing.toJSONString(prettyPrint: true) ?? ""
        print(json1)
        /**
         {
           "name" : "xiaoming",
           "className" : "35 class",
           "detail" : {
             "detail" : "my name is xiaoming"
           },
           "love" : [
             {
               "name" : "basketball",
               "time" : "7 years"
             },
             {
               "name" : "football",
               "time" : "3 years"
             }
           ]
         }
         */

        
        
        // json字符串转模型
        guard let xiaoMing2 = JsonToModel.deserialize(json: json1) else { return }
        print(xiaoMing2)
        /**
         JsonToModel(name: "xiaoming", className: "35 class", detail: SmartCodable_Example.JsonToModelDetail(detail: "my name is xiaoming"), love: [["name": "basketball", "time": "7 years"], ["name": "football", "time": "3 years"]])
         */
        

        
        
        /** 验证数组
         * 1. 字典类型的数组，转模型数组
         * 2. 模型数组转字典数组
         * 3. 字典数组，转json字符串
         * 4. json字符串转模型数组
         */
        let arr = [dict, dict]
        guard let models = [JsonToModel].deserialize(array: arr) as? [JsonToModel] else { return }
        print(models)

        let arrTranform = models.toArray() ?? []
        print(arrTranform)

        let arrJson = models.toJSONString() ?? ""
        print(arrJson)

        guard let models2 = [JsonToModel].deserialize(json: arrJson) else { return }
        print(models2)

        
    }
}




struct JsonToModel: SmartCodable {
    var name: String = ""
    var className: String = ""
    var detail: JsonToModelDetail = JsonToModelDetail()
    var love: [[String: String]] = []
    
    init() { }
}

struct JsonToModelDetail: SmartCodable {
    var detail: String = ""
    
    init() { }
}




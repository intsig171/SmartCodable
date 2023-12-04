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
        SmartConfig.openErrorAssert = false
        
        
        
        let inDict =  ["key1": 1, "key2": "two", "key3": ["key": "1"]] as [String : Any]
        
        let arr = [inDict]
        
        // [["key3": ["key": "1"], "key2": "two", "key1": 1]]

        
        let dict = [
            "arr": arr
        ] as [String : Any]
        
        
        guard let model = AnyModel.deserialize(dict: dict) else { return }
        print(model.arr.peel)
        
        
//        let dict1 = [
//            "name": "12",
//            "dict": ["key1": "one", "key2": "two"]
//        ] as [String : Any]
//
//
//        guard let model1 = AnyModel.deserialize(dict: dict1) else { return }
//        print(model1.dict.peel)
//
//        let dictt = model1.dict.peel
//
//        if let abc = dictt as? [String: String] {
//            print(abc)
//        }
    }
}
struct AnyModel: SmartCodable {
    
    var arr: [SmartAny] = []
}




struct TestModel: SmartCodable {
    var testModel: Test2Model = Test2Model()
//    var createDateTime: Date?
}

struct Test2Model: SmartCodable {
    var value: String?
    var key: String?
}

struct ApiCommon <Element: SmartCodable>: SmartCodable {
    
    init() {}
    
    public var data: Element = Element()
//    public var statusCode: Int?
//    public var createDateTime: Int?
//    public var errorMsg: String?
    
//    init(from decoder: Decoder) throws {
//        let container: KeyedDecodingContainer<ApiCommon<Element>.CodingKeys> = try decoder.container(keyedBy: ApiCommon<Element>.CodingKeys.self)
////        self.errorMsg = try container.decode(String.self, forKey: ApiCommon<Element>.CodingKeys.errorMsg)
////        self.statusCode = try container.decode(Int.self, forKey: ApiCommon<Element>.CodingKeys.statusCode)
//        self.data = try container.decode(Element.self, forKey: .data)
////        self.data = nil
//    }
}


/**
 let json = """
   {
     "data": {
        "testModel": "{\\\"value\\\": \\\"helow\\\",\\\"key\\\": \\\"keyvalue\\\"}"
     },
     "statusCode": 200
   }

   """





 let a = ApiCommon<TestModel>.deserialize(json: json)

 print(a)
 
 */

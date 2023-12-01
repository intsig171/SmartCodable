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
    }


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


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
import HandyJSON
import CleanJSON

class TestViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let dict = [
            "name": "小明",
            "age": 10
        ] as [String : Any]

        guard let model = Model.deserialize(dict: dict) else { return }
        print(model.age)
        print(model.name)

        let dict1 = model.encode() ?? [:]
        print(dict1)


//        let dict1 = [
//            "nickName": NSNull(),
//            "realName": "小花",
//            "age": 10,
//            "person_age": 20,
//        ] as [String : Any]
//
//        guard let model = Model.deserialize(dict: dict1) else { return }


    }
}


class BaseModel: Codable {
    var name: String = ""
    required init() { }
}

class Model: BaseModel {
    var age: Int = 0
}

通过SIL查看中间代码

class BaseModel : Decodable & Encodable {

 @_hasStorage @_hasInitialValue var name: String { get set }

 required init()

 enum CodingKeys : CodingKey {

  case name

  @_implements(Equatable, ==(_:_:)) static func __derived_enum_equals(_ a: BaseModel.CodingKeys, _ b: BaseModel.CodingKeys) -> Bool

  func hash(into hasher: inout Hasher)

  init?(stringValue: String)

  init?(intValue: Int)

  var hashValue: Int { get }

  var intValue: Int? { get }

  var stringValue: String { get }

 }

 @objc deinit

 func encode(to encoder: Encoder) throws

 required init(from decoder: Decoder) throws

}



@_inheritsConvenienceInitializers class Model : BaseModel {

 @_hasStorage @_hasInitialValue var age: Int { get set }

 required init()

 required init(from decoder: Decoder) throws

 @objc deinit

}

为什么 Model 中，有 required init(from decoder: Decoder) throws 方法的实现，解析的时候 age 不会解析？

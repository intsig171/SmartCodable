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

struct BaseFeed123: Codable {
    var name: String = ""
//    var age: Int = 0
//    var sex: Bool = false
}

class TestViewController : BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        
        
//        SmartConfig.debugMode = .none
        
        
        let dict: [String : Any] = [
            "name": "Mccc",
            "subs": [
                [
                    "nickName": "Mccc",
                    "subSex": [
                        "sexName": NSNull()
                    ]
                ],
                [
                    "nickName": "Mccc",
                    "age": "123",
                    "subSex": [
                        "sex": "男"
                    ]
                ]
            ]
        ]

        if let model = MapModel.deserialize(dict: dict) {
            print(model)
        }
        
//        let arr = dict["subs"] as? [Any] ?? []
//        if let models = [MapSubModel].deserialize(array: arr) as? [MapSubModel] {
//            print(models)
//        }
    }
}

struct MapModel :SmartCodable {
   
    public var name: String?
    var subs: [MapSubModel]?
    public init() {}
}
struct MapSubModel :SmartCodable {
    public var age: String = ""
    var subSex: MapSubSexModel = MapSubSexModel()
    public init() {}
}

struct MapSubSexModel :SmartCodable {
    public var sex: String = ""
    public init() {}
}


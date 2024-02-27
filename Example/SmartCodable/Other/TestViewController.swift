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
        
//        SmartConfig.debugMode = .none
        
        
//        let dict: [String : Any] = [
//            "nickName": "Mccc",
//            "subs": [[
//                "nickName": "Mccc",
//                "subSex": [
//                    "sexName": NSNull()
//                ]
//            ]]
//        ]
  
        
        let json = """
        {
          "name": 123
        }
        """
        

        if let model = MapModel.deserialize(json: json) {
            print(model)
        }
    }
}

struct MapModel :SmartCodable {
   
    public var name: String?
//    var subs: [MapSubModel] = []
    public init() {}
}
//struct MapSubModel :SmartCodable {
//    public var age: String = ""
//    var subSex: MapSubSexModel = MapSubSexModel()
//    public init() {}
//}
//
//struct MapSubSexModel :SmartCodable {
//    public var sex: String = ""
//    public init() {}
//}


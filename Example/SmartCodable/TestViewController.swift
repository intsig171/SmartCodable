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
        
        
        let dict: [String: Any] = [
            "name": "Mccc"
        ]

        guard let handyModel = HandyModel.deserialize(from: dict) else { return }
        let toDict = handyModel.toJSON()
        let toJsonStr = handyModel.toJSONString()
        
        guard let smartModel = SmartModel.deserialize(from: dict) else { return }
        let toDict1 = smartModel.toDictionary()
        let toJsonStr1 = smartModel.toJSONString()
        
        
        guard let handyModels = [HandyModel].deserialize(from: [dict]) as? [HandyModel] else { return }
        print(handyModels)
        let toArr = handyModels.toJSON()
        let toArrStr = handyModels.toJSONString()
        
        guard let smartModels = [SmartModel].deserialize(from: [dict]) else { return }
        print(smartModels)
        let toArr1 = smartModels.toArray()
        let toArrStr1 = smartModels.toJSONString()
    }
}

extension TestViewController {
    class HandyModel: HandyJSON {
        var name: String = ""
        required init() { }
    }
    
    class SmartModel: SmartCodable {
        var name: String = ""
        required init() { }
    }
}
class HandyModel: HandyJSON {
    var name: String = ""
    required init() { }
}

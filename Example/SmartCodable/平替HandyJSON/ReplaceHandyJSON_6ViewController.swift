//
//  ReplaceHandyJSON_6ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/26.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

import Foundation
import UIKit
import SmartCodable
import HandyJSON

class ReplaceHandyJSON_6ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: [String: Any] = [
            "sex": "man123",
        ] as [String : Any]
        
        guard let handyModel = HandyModel.deserialize(from: dict) else { return }
        print(handyModel.sex)
        
        guard let smartModel = SmartModel.deserialize(from: dict) else { return }
        print(smartModel.sex)
    }
}
extension ReplaceHandyJSON_6ViewController {
    
    enum HandySex: String, HandyJSONEnum {
        case man
        case women
    }
    
    struct HandyModel: HandyJSON {
        var sex: HandySex = .man
    }
}


extension ReplaceHandyJSON_6ViewController {
    
    enum SamrtSex: String, SmartCaseDefaultable {
        static var defaultCase: SamrtSex = .man
        case man
        case women
    }
    
    struct SmartModel: SmartCodable {
        var sex: SamrtSex = .man
    }
}








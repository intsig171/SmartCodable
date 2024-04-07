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
            "Name": "Mccc",
            "Age": 10,
            "sub": [
                "Name": "小明",
                "Age": 20
            ],
            "sub1": [
                "Name": "小李",
                "Age": 20
            ]
        ]
        
        
        
//        
//        guard let model = HandyModel.deserialize(from: dict) else { return }
//        print(model)
        

        let dict1: [String: Any] = [
            "date1": "2024-04-07",
            "sub": [
                "date2": "2025-04-07",
            ]
        ]
        
        guard let model1 = SmartModel.deserialize(from: dict1) else { return }
        print(model1)

    }
}

extension TestViewController {
    
    struct SmartModel: SmartCodable {
//        var name: String = ""
//        var age: Int = 0
        var date1: Date?
        var sub: SmartSubModel?

//        var sub: [String: SmartAny]?
        
//        static func mapping() -> [MappingRelationship]? {
//            [ CodingKeys.name <--- "sub1.Name" ]
//        }
    }
    
    struct SmartSubModel: SmartCodable {
//        var realMame: String = ""
//        var age: Int = 0
        var date2: Date?
//        static func mapping() -> [MappingRelationship]? {
//            [ CodingKeys.realMame <--- "Name" ]
//        }
    }
}
extension TestViewController {
    
    struct HandyModel: HandyJSON {
        var name: String = ""
        var age: Int = 0
        var sub: HandySubModel?
        
        mutating func mapping(mapper: HelpingMapper) {
            mapper <<<
                self.name <-- "Name"
        }
    }
    
    struct HandySubModel: HandyJSON {
        var realMame: String = ""
        var age: Int = 0
        
        mutating func mapping(mapper: HelpingMapper) {
            mapper <<<
                self.realMame <-- "Name"
        }
    }
}

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
import BTPrint


class TestViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode = .none
//        todo1()
        
        todo2()
    }
}


extension TestViewController {
    
    func todo2() {
        
        let dict: [String: Any] = [
            "students": [
                "name": "Mccc"
            ],
            "sex": "man123"
        ]
        let model1 = ClassName.deserialize(from: dict)
        BTPrint.print(model1)

    }
    
    struct ClassName: SmartCodable {
        var students: Student = Student()
        var sex: Sex = .women

        enum Sex: String, SmartCaseDefaultable {
            static var defaultCase: ClassName.Sex = .man
            case man
            case women
        }
    }

    struct Student: SmartCodable {
        var name: String = ""
    }
}



extension TestViewController {
    
    func todo1() {
        let json = """
         {
             "matches": [
                    {
                        "id": 2,
                        "time_line": [
                             {
                                "count": 2
                              }
                         ]
                      }
                    ]
                }
        """
        
        let model = QLMatchList.deserialize(from: json)
        
        BTPrint.print(model)

        if let matches = model?.matches, matches.count > 0 {
            let uid = matches[0].id
            if uid == 2 {
                print("正确")
            }else{
                print("错误")
            }
        }
    }
    
    
    struct QLMatchList: SmartCodable {
        var matches: [QLMatch]?
    }

    struct QLMatch: SmartCodable {
        var id: Int = 0
        var time_line: [QLTimeLine]?
        var team_type: QLTeamType = .normal
        
//        enum CodingKeys: CodingKey {
//            case id
//            case time_line
//        }
    }
    struct QLTimeLine: SmartCodable {
        var count: Int = 2
    }

    public enum QLTeamType: Int, SmartCaseDefaultable {
        public static var defaultCase: QLTeamType = .normal
        

        case normal = 0
        case home = 1
        case away = 2
    }
}

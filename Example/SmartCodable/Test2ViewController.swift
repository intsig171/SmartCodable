//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import HandyJSON



class Test2ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let arr: [Any] = [
            [
                "sons": NSNull(),
                "father": [
                    "name": 123,
                    "dog": [
                        "hobby": NSNull()
                    ]
                ],
            ],
            [
                "sons": [
                    [
                        "hobby": 123
                    ]
                ],
                "father": [
                    "name": NSNull(),
                ],
//                "location": ,
            ]
        ]
        guard let _ = [Family].deserialize(from: arr) else { return }
//        print("model = \(model)")
    }
}


extension Test2ViewController {
    struct Family: SmartCodable {
        var name: String = "我的家"
        var location: String = ""
        var date: Date = Date()
//
        var father: Father = Father()
        var sons: [Son] = []
    }

    struct Father: SmartCodable {
        var name: String = ""
        var age: Int = 0
        var dog: Dog = Dog()
    }


    struct Son: SmartCodable {
        var hobby: String = ""
        var age: Int = 0
    }

    struct Dog: SmartCodable {
        var hobby: String = ""
    }
}

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
        
       
        let dict: [String: Any] = [
            "one": NSNull()
        ]
        
        
        let model = Feed.deserialize(dict: dict)
        print(model?.one as Any)
    }
}


struct Feed: SmartCodable {
    @SmartOptional var one: FeedOne?
}


class FeedOne: SmartCodable {
    var name: String = ""
    required init() { }
}

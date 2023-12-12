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
         "type": "11",
         "name": "xiaoming"
        }
        """
        
//        let v = FeedTestOne.deserialize(json: json)
//        print(v)
        
    }
}






extension TestViewController {
    func newRequest<T: SmartCodable>(model: T.Type) {
        
        
        
    }
}




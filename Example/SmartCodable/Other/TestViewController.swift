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
        

        let json = """
        {
          "date": "2023-01-01 00:00:00",
          "test": 100.0
        }
        """

        let formart = DateFormatter()
        formart.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let dateStrategy: JSONDecoder.DateDecodingStrategy = .formatted(formart)
        guard let model = TestModel.deserialize(json: json, options: [.dateStrategy(dateStrategy)]) else { return }
        print(model)
    }
}

struct TestModel: SmartCodable {
    var date: Date?
    var test: Decimal?
}



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
          "date": "2023-01-01 00:00:00"
        }
        """
        
        
        let model = TestModel.deserialize(json: json) { decoder in
            decoder.dateDecodingStrategy = .iso8601
        }
        
        print(model)
        print(Date())
        
        
        let decoder = JSONDecoder()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formatter)
        let v = try? decoder.decode(TestModel.self, from: json.data(using: .utf8)!)
        print(v)
        
        
    }
}




struct TestModel: SmartCodable {
    var date: Date?
}

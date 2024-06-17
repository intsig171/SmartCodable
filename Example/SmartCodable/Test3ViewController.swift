//
//  Test3ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/18.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import HandyJSON
import CleanJSON



class Test3ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let dict: [String: Any] = [
            "data": 1.1,
        ]
        
        guard let data = _toData(dict) else { return }
        
        let decoder = JSONDecoder()
        let dict1 = try? decoder.decode(Model.self, from: data)
        print(dict1)
    }
    
    struct Model: Codable {
        var data: Decimal?
    }
}
fileprivate func _toData(_ value: Any) -> Data? {
    guard JSONSerialization.isValidJSONObject(value) else { return nil }
    return try? JSONSerialization.data(withJSONObject: value)
}

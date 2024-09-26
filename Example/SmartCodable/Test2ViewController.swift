//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SmartCodable
import BTPrint
import Combine

class Test2ViewController: BaseViewController {
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let currentTime = Date()
        let timeInterval = currentTime.timeIntervalSince1970
        let millisecondsSince1970 = Int(timeInterval * 1000)
        
        print("time == \(millisecondsSince1970)")
        
        let dict: [String: Any] = [
            "nick_name": "Mccc",
            "date": "\(millisecondsSince1970)"
        ]
        
        
        guard let model = [Model].deserialize(from: [dict, dict], options: [.key(.fromSnakeCase), .date(.millisecondsSince1970)]) else { return }
        
        
        print(model)
        
        let options: Set<SmartEncodingOption> = [
            .date(.millisecondsSince1970),
//            .key(.toSnakeCase)
        ]
        
        let json = model.toArray(useMappedKeys: false, options: options)
        print(json)
//        
//        let tranJson = model.toJSONString(options: options)
//        print(tranJson)
        
        

    }
    
    struct Model: SmartCodable {
        var nickName: String = ""
        var date: Date?
        
        
        static func mappingForKey() -> [SmartKeyTransformer]? {
            [
                CodingKeys.nickName <--- "nick_name"
            ]
        }
    }
}

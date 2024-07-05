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

        
        let dict: [String: Any] = [
            "key": 4.99
        ]
        
        let data = dict.toData()!
        
        let decoder = JSONDecoder()
        
        do {
            let model = try decoder.decode(Model.self, from: data)
            print(model)
        } catch  {
            print(error)
        }
        
        

    }
    struct Model: Codable {
        var key: String?
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<Test2ViewController.Model.CodingKeys> = try decoder.container(keyedBy: Test2ViewController.Model.CodingKeys.self)
            let double = try container.decodeIfPresent(Double.self, forKey: Test2ViewController.Model.CodingKeys.key)
            
            self.key = "\(String(describing: double))"
        }
    }
}

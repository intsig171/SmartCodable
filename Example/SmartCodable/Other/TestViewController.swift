//
//  TestViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/9/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
//import SmartCodable




class TestViewController : BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let json = """
        {
          "name": 123,
          "age": 10
        }
        """
        


        
        

  
//        let model = Person.deserialize(dict: dict)
//        print(model)

        
        guard let jsonData = json.data(using: .utf8) else { return }
        do {
            let decoder = JSONDecoder()
            let feed = try decoder.decode(Person.self, from: jsonData)
            print(feed)
        } catch let error {
            print(error)
        }
    }


}

// 不可变属性将不会被解码，因为它是用无法覆盖的初始值声明的

struct Person: Codable {
    var name: String = ""
    var age: Int = 0
}


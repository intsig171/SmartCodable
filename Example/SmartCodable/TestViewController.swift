//
//  TestViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2023/9/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import CodableWrapper


class TestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let jsonStr = """
        {
            "name": "Mccc",
            "age": {}
        }
        """
        
        do {
            let model = try JSONDecoder().decode(SubModel.self, from: jsonStr.data(using: .utf8)!)
            print(model.name)
            print(model.age)
            
            let dict = model.encode()!
            print(dict)
        } catch {
            print(error)
        }
    }

    @Codable
    class BaseModel {
        var name: String = ""
    }
    
    @CodableSubclass
    class SubModel: BaseModel {
        var age: Int = 0
    }

}




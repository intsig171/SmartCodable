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
          "name": null
        }
        """


        guard let jsonData = json.data(using: .utf8) else { return }
        let decoder = JSONDecoder()
        do {
            let feed = try decoder.decode(Person.self, from: jsonData)
            print(feed)
        } catch let error {
            print(error)
        }
    }


}

struct Person: Codable {
    var name: String = ""
}


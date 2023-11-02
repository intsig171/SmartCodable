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
          "name": null
        }
        """
        
        
        guard let jsonData = json.data(using: .utf8) else { return }

        let decoder = JSONDecoder()
        do {
            let feed = try decoder.decode(Feed.self, from: jsonData)
            print(feed)
        } catch let error {
            print(error)
        }

    }
    
    
}


struct Feed: Codable {
    var name: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
          // 1.数据中是否否包含该键
        if container.contains(.name) {
            // 2.是否为nil
            if try container.decodeNil(forKey: .name) {
                self.name = ""
            } else {
                do {
                    // 3.是否类型正确
                    self.name = try container.decode(String.self, forKey: .name)
                } catch {
                    self.name = ""
                }
            }
        } else {
            self.name = ""
        }
    }
}
 


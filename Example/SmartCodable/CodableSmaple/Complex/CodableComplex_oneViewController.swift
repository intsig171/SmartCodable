//
//  CodableComplex_oneViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/8/28.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class CodableComplex_oneViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        let json = """
        [
          {
              "hobby": {
                  "name": "football",
                  "age": 2,
              }
          },
          {
              "hobby": {
                  "name": "basketball",
                  "age": 5,
              }
          }
        ]
        """
      

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()

        do {
            let xiaoMing = try decoder.decode(XiaoMing.self, from: data)
            print(xiaoMing)
        } catch {
            print("Error decoding: \(error)")
        }
    }

}


struct XiaoMing: Codable {
    var hobbies: [Hobby]
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        var list: [Hobby] = []
        while !container.isAtEnd {
            let student = try container.decode(Hobby.self)
            list.append(student)
        }
        self.hobbies = list
    }
}


struct Hobby: Codable {
    var name: String
    var age: Int
    
    enum ContainerCodingKeys: CodingKey {
        case hobby
    }
    enum CodingKeys: CodingKey {
        case name
        case age
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
        
        let con2 = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .hobby)
        
        self.name = try con2.decode(String.self, forKey: .name)
        self.age = try con2.decode(Int.self, forKey: .age)
    }
}




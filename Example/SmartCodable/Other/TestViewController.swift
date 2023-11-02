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
         "x" : 1,
         "y" : 2,
         "z" : 3
        }
        """
        
        guard let point = Point3D.deserialize(json: json) else { return }
        print(point)
        
        
        point.encode()
        
        guard let json11 = point.toJSONString(prettyPrint: true) else { return }
        print(json11)
        
    }
    
    
}

class Point2D: SmartCodable {
    required init() {
        
    }

    
    var x: Double = 0.0
    var y: Double = 0.0
     
    enum CodingKeys: CodingKey {
        case x
        case y
    }
     
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.x = try container.decode(Double.self, forKey: .x)
        self.y = try container.decode(Double.self, forKey: .y)
    }
    
 }
 
class Point3D: Point2D {

    
    var z = 0.0
   
    enum CodingKeys: CodingKey {
        case z
        case point2D
        case `super`
    }
     
    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.z = try container.decode(Double.self, forKey: .z)

        try super.init(from: decoder)

    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    

    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.z, forKey: .z)
         
        let superEncoder = container.superEncoder(forKey: .super)
        
//        let superEncoder = container.superEncoder()
        try super.encode(to: superEncoder)
    }
 }



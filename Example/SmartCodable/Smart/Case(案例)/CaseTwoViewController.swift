//
//  CaseTwoViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/10/27.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


class CaseTwoViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let point = Point3D()
        point.x = 1.0
        point.y = 2.0
        point.z = 3.0
        
        guard let value = point.encode() else { return }
        print(value)


    }
}

class Point2D: Codable {
    var x = 0.0
    var y = 0.0
    
    private enum CodingKeys: CodingKey {
        case x
        case y
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.x, forKey: .x)
        try container.encode(self.y, forKey: .y)
    }
}



class Point3D: Point2D {
    var z = 0.0
    
    enum CodingKeys: CodingKey {
        case z
    }
    
    override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.z, forKey: .z)
    }
}

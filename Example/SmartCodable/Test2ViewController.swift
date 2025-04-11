//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SmartCodable
import BTPrint

class Test2ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dict: [String: Any] = [
            "size": [],
            "id": 2,
            "name": "Mccc"
        ]
        
        guard let model = C.deserialize(from: dict) else { return }

        print(model.size)
        print(model.id)
        print(model.name)
        print("\n")
        
        model.size = nil
        
        let ddd = model.toDictionary()
        print(ddd)
        
        
    }
}

class A: SmartCodable {
    var size: Int? = 10
    required init() { }
}

class B: A {
    var name: String = "Mccc"
    
    enum CodingKeys: CodingKey {
        case name
    }
    required init(from decoder: any Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
    
    required init() {
        super.init()
    }
}


class C: B {
    var id: Int = 1
    enum CodingKeys: CodingKey {
        case id
    }
    required init(from decoder: any Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
    }
    required init() {
        super.init()
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
    }
}

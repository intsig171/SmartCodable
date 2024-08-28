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

        
        
        SmartConfig.debugMode = .none
        
        guard let image = UIImage(named: "question") else { return }
        let byte = UIImagePNGRepresentation(image)!
    
        
        var dict111: [String: Any] = [
            "id": "112312",
            "name": "hello",
            "byte": byte
        ]

//        print(dict111)
        
        let model = DataModel11.deserialize(from: dict111)
        print(model)
        print(model?.thumbnail_picture)
    }
}
struct DataModel11: SmartCodable {
    /// 表id
    var id: Int = -1
    /// 名称
    var name: String = ""
    /// 缩略图流
    var byte: Data? = nil
    
    var thumbnail_picture: UIImage? {
        guard let byte = byte else {
            return nil
        }
        return UIImage(data: byte)
    }
}

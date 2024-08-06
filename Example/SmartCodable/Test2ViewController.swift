//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SmartCodable
import BTPrint

class Test2ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict = [
            "nick_name": "Mccc",
            "self_age": 10,
            "dict": ["k":"l"]
        ] as [String : Any]
                
        guard let smartModel = SmartModel.deserialize(from: dict) else { return }
        BTPrint.print(smartModel.dict)
        smartPrint(value: smartModel)
    }
}

struct SmartModel: SmartCodable {
    
    var nick_name: String?
    @IgnoredKey
    var dict: NSMutableDictionary = .init()
    var self_age: String?
    
    static func mappingForValue() -> [SmartValueTransformer]? {
        [
            CodingKeys.dict <--- DictTransformer()
        ]
    }
}

struct DictTransformer: ValueTransformable {
    func transformFromJSON(_ value: Any) -> NSMutableDictionary? {
        
        if let dict = value as? NSDictionary {
            let dictM = NSMutableDictionary(dictionary: dict)
            
            print("dictM = \(dictM)")
            return dictM
        }
        
        return nil
        
        
//        (value as? NSDictionary)?.mutableCopy() as? NSMutableDictionary
    }
    
    func transformToJSON(_ value: NSMutableDictionary) -> [String : Any]? {
        value as? [String: Any]
    }

    typealias Object = NSMutableDictionary
    typealias JSON = [String: Any]
}

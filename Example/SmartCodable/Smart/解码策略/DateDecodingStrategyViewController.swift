//
//  DateDecodingStrategy.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/11/30.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable

class DateDecodingStrategyViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode = .error

        let json = """
        {
          "float": NaN
        }
        """
        
        
        guard let model = FeedOne.deserialize(json: json, options: []) else {
            print("123")
            return }
        print(model)
        
    }
}



extension DateDecodingStrategyViewController {

    struct FeedOne: SmartCodable {
        var float: Float = 0
    }
}





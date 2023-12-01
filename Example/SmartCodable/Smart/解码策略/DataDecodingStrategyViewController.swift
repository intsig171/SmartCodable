//
//  DataDecodingStrategy.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/11/30.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable

class DataDecodingStrategyViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
}



extension DataDecodingStrategyViewController {

    struct FeedOne: SmartCodable {
        var name: String = ""
    }
}

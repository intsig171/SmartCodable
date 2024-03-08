//
//  CaseFive_wcdbViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/5.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import WCDBSwift

class CaseFive_wcdbViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "兼容WCDB"
        
        let database = Database(withPath: "~/Intermediate/Directories/Will/Be/Created/sample.db")
        
        let object = WCDBSample()
        object.identifier = 1
        object.description = "sample_insert"
        //Insert
        try? database.insert(objects: object, intoTable: "sampleTable")

    }
    

}


extension CaseFive_wcdbViewController {
    class WCDBSample: TableCodable {
        var identifier: Int? = nil
        var description: String? = nil
        
        enum CodingKeys: String, CodingTableKey {
            typealias Root = WCDBSample
            static let objectRelationalMapping = TableBinding(CodingKeys.self)
            case identifier
            case description
        }
    }
}

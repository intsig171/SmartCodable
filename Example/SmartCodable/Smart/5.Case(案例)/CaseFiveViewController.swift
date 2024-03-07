//
//  CaseFiveViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/11/30.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation


import SmartCodable




class CaseFiveViewController : BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let json = """
        {
          "data": "success",
          "message": "200"
        }
        """

        
        guard let model = ApiConmon<StringModel>.deserialize(json: json) else { return }
        print(model)
    }
}



struct StringModel: SmartCodable {
    var string: String = ""
}

struct ApiConmon<Element: SmartCodable>: SmartCodable {
    init() {
        
    }
    
    var data: Element?
    var message: String = ""

    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<ApiConmon<Element>.CodingKeys> = try decoder.container(keyedBy: ApiConmon<Element>.CodingKeys.self)
        self.message = try container.decode(String.self, forKey: ApiConmon<Element>.CodingKeys.message)

        
        if Element.self == StringModel.self {
            if  let v  = try container.decodeIfPresent(String.self, forKey: ApiConmon<Element>.CodingKeys.data) {
                self.data = StringModel(string: v) as? Element
            }
        } else {
            self.data = try container.decodeIfPresent(Element.self, forKey: ApiConmon<Element>.CodingKeys.data)
        }
        
    }
}

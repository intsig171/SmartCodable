//
//  SmartDecoder.swift
//  SmartCodable
//
//  Created by Mccc on 2023/12/1.
//

import Foundation

public protocol SmartDecoder: Decoder {
    
    var topContainer: Any { get }

}

// MARK: SmartDecoder Methods
extension _CleanJSONDecoder {
    
    /// 当前解码的数据（json数据），可以用来做类型兼容
    var topContainer: Any {
        storage.topContainer
    }
}

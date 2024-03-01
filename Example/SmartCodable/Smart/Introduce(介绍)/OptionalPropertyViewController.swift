//
//  PropertyTypeViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/9/8.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


/** 如果要解析嵌套结构，该模型属性要设置为可选。
 * 需要使用 @ SmartOptional属性包装器修饰。
 * SmartOptional修饰的对象必须满足一下三个要求：
 * - 1. 必须遵循SmartDecodable协议。
 * - 2. 必须是可选属性
 * - 3. 必须是class类型。
 * 【模型数组不要求】
 */


/** 这么做的原因
 1. 为了做解码失败的兼容，我们重写了KeyedEncodingContainer的decode和decodeIfPresent方法，这两个类型的方法均会走到我的兜底smartDecode方法中。
    该方法最终使用了public func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? 实现了decode能力。
 2. KeyedEncodingContainer容器是用结构体实现的。 重写了结构体的方法之后，没办法再调用父方法。
 3. 这种情况下，如果再重写public func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T?方法，就会导致方法的循环调用。
 4. 我们使用SmartOptional属性包装器修饰可选的属性，被修饰后会产生一个新的类型，对此类型解码就不会走decodeIfPresent，而是会走decode方法。
 */


class OptionalPropertyViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict = [
            "items": [[
                "name": "123"
            ],[
                "name": "456"
            ],[
                "name": "789"
            ]],
            "item": ["name": "小明"]
        ] as [String : Any]

        
        guard let model = OptionalPropertyModel.deserialize(dict: dict) else { return }
        
        print(model.item?.name ?? "")
        
        for item in model.items ?? [] {
            print(item.name)
        }
    }
}





struct OptionalPropertyModel: SmartCodable {
    
    // Generic struct 'DefalutDecodeWrapper' requires that 'OptionalPropertyItemModel' be a class type
    // Property type 'OptionalPropertyItemModel' does not match 'wrappedValue' type 'OptionalPropertyItemModel?'
    // Generic struct 'DefalutDecodeWrapper' requires that 'OptionalPropertyItemModel' conform to 'SmartDecodable'
    var item: OptionalPropertyItemModel?
    

    var items: [OptionalPropertyItemModel]?
}




class OptionalPropertyItemModel: SmartCodable {
    var name: String = ""
    
    
    func didFinishMapping() {
        name = "被教育过的小朋友" + name
    }
    
    required init() { }
}

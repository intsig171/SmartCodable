//
//  Transform.swift
//  CodableWrapperDev
//
//  Created by winddpan on 2020/8/15.
//  Copyright © 2020 YR. All rights reserved.
//

import Foundation

public protocol TransformType {
    associatedtype Object
    associatedtype JSON: Codable

    func transformFromJSON(_ json: JSON?) -> Object
    func transformToJSON(_ object: Object) -> JSON?
}

public extension TransformType {
    func transformFromJSON(_ json: JSON?,
                           fallback _: @autoclosure () -> Object) -> Object {
        return transformFromJSON(json)
    }

    func transformFromJSON<Wrapped>(_ json: JSON?,
                                    fallback: @autoclosure () -> Wrapped) -> Wrapped where Object == Wrapped?
    {
        if let value = transformFromJSON(json) {
            return value
        }
        return fallback()
    }
}

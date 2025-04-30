//
//  TransformOf.swift
//  CodableWrapperDev
//
//  Created by winddpan on 2020/8/15.
//  Copyright © 2020 YR. All rights reserved.
//

import Foundation

open class TransformOf<Object, JSON: Codable>: TransformType {
    open var fromJSON: (JSON?) -> Object
    open var toJSON: (Object) -> JSON?

    public init(fromJSON: @escaping ((JSON?) -> Object),
                toJSON: @escaping ((Object) -> JSON?))
    {
        self.fromJSON = fromJSON
        self.toJSON = toJSON
    }

    open func transformFromJSON(_ json: JSON?) -> Object {
        fromJSON(json)
    }

    open func transformToJSON(_ object: Object) -> JSON? {
        toJSON(object)
    }
}

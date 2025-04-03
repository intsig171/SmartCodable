//
//  WrapperLifecycle.swift
//  SmartCodable
//
//  Created by qixin on 2025/2/25.
//

import Foundation



/// A marker protocol for property wrappers that need lifecycle callbacks.
protocol WrapperLifecycle {
    
    /**
     Callback invoked when the wrapped value finishes decoding/mapping.
     
     - Returns: An optional new instance of the wrapper with processed value
     - Note: Primarily used by property wrappers containing types conforming to SmartDecodable
     */
    func wrappedValueDidFinishMapping() -> Self?
}

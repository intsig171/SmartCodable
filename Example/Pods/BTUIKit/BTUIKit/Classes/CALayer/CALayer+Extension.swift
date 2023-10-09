//
//  CALayer+Extension.swift
//  BTFoundation
//
//  Created by qxb171 on 2020/12/3.
//

import Foundation
import BTNameSpace

//extension CALayer: NamespaceWrappable { }
extension NamespaceWrapper where T: CALayer {
    
    /// 通过图层生成图片
    public func makeImage() -> UIImage? {
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(wrappedValue.bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            wrappedValue.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
}

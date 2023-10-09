//
//  UIEdgeInsets+Extension.swift
//  Pods
//
//  Created by qixin on 2022/12/13.
//

import Foundation

import BTNameSpace

extension UIEdgeInsets: NamespaceWrappable { }
extension NamespaceWrapper where T == UIEdgeInsets {
    public var horizontal: CGFloat {
        return wrappedValue.left + wrappedValue.right
    }
    
    public var vertical: CGFloat {
        return wrappedValue.top + wrappedValue.bottom
    }
}

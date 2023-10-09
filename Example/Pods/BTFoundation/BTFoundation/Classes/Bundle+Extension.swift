//
//  Bundle+Extension.swift
//  BTFoundation
//
//  Created by Mccc on 2020/4/7.
//

import Foundation
import BTNameSpace


@objc extension Bundle: NamespaceWrappable {}

extension NamespaceWrapper where T: Bundle {
    
    /// 加载图片资源文件（图片文件， 不是从Images.xcassets加载图片）
    /// - Parameters:
    ///   - imageName: 图片名称
    ///   - bundleName: bundle名称
    ///   - podName: pod库名
    @available(*, deprecated, message:"Use update(priority: BTUIKit func loadImage(_ name: String, inBundle bundle: Bundle) -> UIImage?.")
    public static func loadImageWithName(
        _ imageName: String,
        fromBundle bundleName: String,
        inPod podName: String) -> UIImage? {
        
        
        
        if let bundle = Bundle.bt.getBundleWithName(bundleName, inPod: podName) {
            let scale = Int(UIScreen.main.scale)
            
            // 适配2x还是3x图片
            let name = imageName + "@" + String(scale) + "x"
            if let path = bundle.path(forResource: name, ofType: "png") {
                let image1 = UIImage.init(contentsOfFile: path)
                return image1
            }
        }
        
        return nil
    }
    
    
    
    /// 获取bundle
    /// - Parameters:
    ///   - bundleName: bundle的名称
    ///   - podName: pod库的名称
    public static func getBundleWithName(
        _ bundleName: String,
        inPod podName: String) -> Bundle? {
        
        
        var associateBundleURL = Bundle.main.url(forResource: "Frameworks", withExtension: nil)
        associateBundleURL = associateBundleURL?.appendingPathComponent(podName)
        associateBundleURL = associateBundleURL?.appendingPathExtension("framework")
        
        
        if let tempUrl = associateBundleURL, let associateBunle = Bundle.init(url: tempUrl) {
            if let bundleUrl = associateBunle.url(forResource: bundleName, withExtension: "bundle"), let bundle = Bundle.init(url: bundleUrl) {
                return bundle
            }
        }
        
        print("获取bundle失败")
        return nil
    }
}

//
//  UIImageView+Extension.swift
//  BTUIKit
//
//  Created by Tao on 2020/11/11.
//

import Foundation
import BTNameSpace
//import Kingfisher




extension NamespaceWrapper where T == UIImageView {

    /// 生成企业头像或人员头像
    /// - Returns: UIImageView
    public static func makeLogo(radius: CGFloat = 2, isShowBorder: Bool = true) -> UIImageView  {
        let iv = UIImageView()
        iv.layer.cornerRadius = radius
        iv.layer.masksToBounds = true
        if isShowBorder {
            iv.layer.borderWidth = 0.5
            iv.layer.borderColor = UIColor.bt.hex("E9E9E9").cgColor
        }
        iv.contentMode = .scaleAspectFit
        return iv
    }
}



extension NamespaceWrapper where T == UIImageView {
    
    

    /// 设置网络头像专用方法 (用于企业头像或人员头像的加载， 通过处理优化了默认图的生成规则，适用于列表类型场景使用)
    /// - Parameters:
    ///   - urlString: url
    ///   - type: placceholder的类型（企业，人员，还是自定义）
    ///   - text: placceholder 显示的文字
    ///   - assistText: placceholder 显示的文字(如果text的备选)
    ///   - id: 通过id的尾号固定placceholder的背景颜色。 eid 或 pid
    public func setNetworkAvatar(
        with urlString: String,
        type: NamespaceWrapper<UIImage>.UIImageTextPlaceholderType,
        text: String?,
        assistText: String?,
        id: String) {

            let size = wrappedValue.bounds.size

            var WH = min(size.width, size.height)
            if WH < 10 {
                WH = 40
            }
            
            let placeholder = UIImage.bt.make(text: text, assistText: assistText, type: type, wAndH: WH, id: id)
            let url = URL.init(string: urlString)
            wrappedValue.kf.setImage(with: url, placeholder: placeholder)

            

            // 有bug 列表中会导致网络头像复用。
//            let size = wrappedValue.bounds.size
//
//            var WH = min(size.width, size.height)
//            if WH < 10 {
//                WH = 40
//            }
//
//            if let url = URL(string: urlString) {
//                wrappedValue.kf.setImage(with: url, placeholder: nil, options: nil) { result in
//                    switch result {
//                    case .failure(_):
//                        let placeholder = UIImage.bt.make(text: text, assistText: assistText, type: type, wAndH: WH, id: id)
//                        wrappedValue.image = placeholder
//                    case .success(let result):
//                        wrappedValue.image = result.image
//                    }
//                }
//            } else {
//                let placeholder = UIImage.bt.make(text: text, assistText: assistText, type: type, wAndH: WH, id: id)
//                wrappedValue.image = placeholder
//            }
        }
   

    
    
    
    /// 加载网络图
    /// - Parameters:
    ///   - urlString: 网络图片地址
    ///   - placeholder: 默认图
    public func setImage(with urlString: String, placeholder: UIImage? = nil) {

        let url = URL.init(string: urlString)
        wrappedValue.kf.setImage(with: url, placeholder: placeholder)

        // 会导致图片复用， 将options改为 强制 forreRefresh。
//        if let url = URL(string: urlString) {
//            wrappedValue.kf.setImage(with: url, placeholder: placeholder)
//        } else {
//            if let placeholder = placeholder {
//                wrappedValue.image = placeholder
//            }
//        }
    }
    
    /// 加载网络图数组，根据优先级依次加载，加载成功，不再加载。 （方法写的好像有问题？ 需要测试一下。completionHandler的回调是有时间差的）
    /// - Parameters:
    ///   - urlStrings: 网络图片地址数组
    ///   - placeholder: 默认图
    public func setImage(with urlStrings: [String], placeholder: UIImage? = nil) {
        
        if urlStrings.count == 0 {
            if let placeholder = placeholder {
                wrappedValue.image = placeholder
            }
            return
        }
        
        var i = 0
        
        /// 采用递归函数加载图片
        func loadImage(urlStrings: [String], index: Int) {
            /// 所有的网络图片都加载了一遍，还是没成功。就使用默认图
            if i >= urlStrings.count {
                if let placeholder = placeholder {
                    wrappedValue.image = placeholder
                }
                return
            }
            
            if let url = URL(string: urlStrings[i]) {
                wrappedValue.kf.setImage(with: url, placeholder: placeholder, completionHandler:  { response in
                    switch response {
                    case .failure(_):
                        i = i + 1
                        loadImage(urlStrings: urlStrings, index: i)
                    case .success(let result):
                        wrappedValue.image = result.image
                        return
                    }
                })
            }
        }
        
        loadImage(urlStrings: urlStrings, index: 0)
    }
}


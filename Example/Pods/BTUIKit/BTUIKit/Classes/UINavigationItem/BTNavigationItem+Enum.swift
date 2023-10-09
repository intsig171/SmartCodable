//
//  UINavigationItem+Ability.swift
//  pluto
//
//  Created by Allen on 2020/6/17.
//  Copyright © 2020 bertadata. All rights reserved.
//
//import Kingfisher

// MARK: - 导航栏两侧按钮的枚举类型
// 两侧按钮的枚举类型

import BTFoundation


public enum BTBarButtonItemType: Equatable {
    
    case text(TextType)
    
    case image(ImageType)
    
    public enum TextType {
        
        /// 纠错
        case reportError
        
        /// 样例分析
        case exampleAnylise
        
        /// 自定义类型
        case custom(String,Int)
    }
    
    public enum ImageType {
        
        //------------左侧按钮的类型--------------//
        /// 返回按钮
        case back
        
        /// 关闭按钮
        case close
        
        //------------右侧按钮的类型--------------//
        /// 启信宝logo
        case qxbLogo
        
        /// 弹出带存长图的分享面板
        case share
        
        /// 直接点击保存图片
        case saveImage
        
        /// 返回首页
        case backToHome
        
        /// 更多按钮
        case more
        
        /// 搜索按钮
        case search
        
        /// 自定义本地图片
        case custom(UIImage, Int)
        
        /// 自定义网络图片
        case customUrl(String, Int, [String:Any])
    }
    
    public static func == (lhs: BTBarButtonItemType, rhs:BTBarButtonItemType) -> Bool {
        
        switch (lhs, rhs) {
        case (.text(let aType), .text(let bType)):
            
            switch (aType,bType) {
            case (.reportError, .reportError): return true
            case (.exampleAnylise, .exampleAnylise): return true
            case (.custom(let aString, _),.custom(let bString, _)): return aString == bString
            default: return false
            }
            
        case (.image(let aType), .image(let bType)):
            
            switch (aType, bType) {
            case (.back, .back), (.close, .close), (.qxbLogo, .qxbLogo), (.share, .share), (.saveImage, .saveImage), (.backToHome, .backToHome), (.more, .more):
                return true
            default:
                return false
            }
            
        default:
            return false
        }
    }
    
    // 根据枚举类型获取对应的本地图片source
    func getPicture() -> UIImage?{
        
        func loadBundleImage(_ name: String) -> UIImage? {
            let bundle = Bundle.bt.getBundleWithName("BTUIKitUINavigationItemBundle", inPod: "BTUIKit")
            let image = UIImage.bt.loadImage(name, inBundle: bundle)
            return image
        }
        
        var imageSource: UIImage? = nil
        switch self {
        
        case .image(let type):
            switch type {
            case .back: imageSource = loadBundleImage("backBtn")
            case .close: imageSource = loadBundleImage("closeBtn")
            case .qxbLogo: imageSource = loadBundleImage("longImageAndShareHeadLogo")
            case .share: imageSource = loadBundleImage("saveLongPicture")
            case .saveImage: imageSource = loadBundleImage("ShareDetailWithRed")
            case .backToHome: imageSource = loadBundleImage("nav_backhome")
            case .more: imageSource = loadBundleImage("nav_more")
            case .search: imageSource = loadBundleImage("nav_search")
            default:
                break
            }
            
        default: break
            
        }
        return imageSource
    }
    
    func getTitle() -> String? {
        switch self {
        case .text(let type):
            switch type {
            case .exampleAnylise: return "样例分析"
            case .reportError: return "纠错"
            case .custom(let customString, _):
                if customString.count > 4 {
                    return (customString as NSString).substring(to: 4)
                } else {
                    return customString
                }
            }
        default:
            return nil
        }
    }
}

// MARK: - 导航栏中间的枚举类型
public enum BTTitleViewType {
    
    /// 只需要文字，没有点击事件
    case onlyTitle(String, TitleAligment)
    
    /// 文字右侧带vip标志，没有点击事件
    case vipTitle(String)
    
    /// 文字左侧带问号按钮,肯定有点击事件
    case questionTitle(String)
    
    /// 自定义样式，直接传UIView，点击事件由外部自己设置
    case custom(UIView)
    
    /// 只需要图片,可能有点击事件
    case onlyImage(ImageType)
    
    public enum ImageType {
        case image(UIImage, [String: Any])
        case webUrl(String, [String: Any])
    }
    
    public enum TitleAligment {
        /// 居左显示
        case left
        /// 居中显示
        case middle
    }
}

/// 显示标签枚举
public enum RedTagType {
    /// 显示小红点
    case redPoint
    
    /// 显示自定义文本的标签
//    case tag(String)
}

extension UINavigationItem {
    
    private static func loadBundleImage(_ name: String) -> UIImage? {
        
        let bundle = Bundle.bt.getBundleWithName("BTUIKitUINavigationItemBundle", inPod: "BTUIKit")
        let image = UIImage.bt.loadImage(name, inBundle: bundle)        
        return image
    }
}

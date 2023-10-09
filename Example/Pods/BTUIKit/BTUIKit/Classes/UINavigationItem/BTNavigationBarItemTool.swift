//
//  UINavigationItem+Config.Swift
//  pluto
//
//  Created by Allen on 2020/6/17.
//  Copyright © 2020 bertadata. All rights reserved.
//

//import Kingfisher
import BTFoundation
import BTFoundation

class BTNavigationBarItemTool: NSObject, iPhoneModelType {
    
    public private(set) var sideBarItemWidth: CGFloat = 0
    
    public private(set) var leftBarView: UIView = UIView()
    
    public private(set) var rightBarItems: [UIBarButtonItem] = []
    
    public private(set) var items: [BTBarButtonItemType] = []
            
    private weak var target: UINavigationItem? = nil
    
    private var selector: Selector = #selector(aaa)
    
    private var tagParam: [Int: RedTagType] = [:]
    
    /// 初始化两侧的按钮数据模型类
    /// - Parameters:
    ///   - items: 需要展示的按钮对应的枚举
    ///   - isLeft: 是否是左侧按钮区
    ///   - actionBlock: 点击的回调
    public init(items: [BTBarButtonItemType], isLeft: Bool, target: UINavigationItem, actionSelector: Selector, tagParam: [Int: RedTagType] = [:]) {
        super.init()
        
        self.target = target
        self.selector = actionSelector
        self.tagParam = tagParam

        if isLeft {
            self.items = items

            if items.count == 0 {
                sideBarItemWidth = 0
            } else {
                makeNavigationLeftSideView(target: target, actionSelector: actionSelector)
            }
        } else {
            self.items = items.reversed()

            if items.count == 0 {
                sideBarItemWidth = getBarButtomItemMargin() - 8.0
            } else {
                makeNavigationRightSideView(target: target, actionSelector: actionSelector)
            }
        }
    }
    
    @objc private func aaa() {
    
    }
    
    /// 总结的两个定则：
    /// 1.不同机型最边上按钮距离两侧屏幕的宽度是有个固定值的Width
    /// 2. Width减去8等于右侧按钮为空时，titleview距离屏幕的宽度
    /// - Returns:
    private func getBarButtomItemMargin() -> CGFloat {

        let type = iPhone()
        switch type {
        case .iPhone6, .iPhone6s:
            return 16
        case .iPhone6Plus, .iPhone6sPlus:
            return 20
        case .iPhone7:
            return 16
        case .iPhone7Plus:
            return 20
        case .iPhone8:
            return 16
        case .iPhone8Plus:
            return 20
        case .iPhoneX:
            return 16
        case .iPhoneXR:
            return 20
        case .iPhoneXS:
            return 16
        case .iPhoneXSMax:
            return 20
        case .iPhone11:
            return 20
        case .iPhone11Pro:
            return 16
        case .iPhone11ProMax:
            return 16
        case .iPhone12Mini:
            return 16
        case .iPhone12:
            return 16
        case .iPhone12Pro:
            return 16
        case .iPhone12ProMax:
            return 20
        case .iPhoneSE1:
            return 16
        case .iPhoneSE2:
            return 16
        case .iPhone13:
            return 16
        case .iPhone13Pro:
            return 16
        case .iPhone13Mini:
            return 16
        case .iPhone13ProMax:
            return 20
        default:
            return 16
        }
    }
}

// MARK: - 创建两侧按钮的方法
extension BTNavigationBarItemTool {
    
    /// 生成左侧按钮区的按钮
    private func makeNavigationLeftSideView(target: Any, actionSelector: Selector) {
        
        let navigationTotal = UIApplication.shared.statusBarFrame.height + 44
        let leftBgView: UIView = UIView.init(frame: .zero)
        leftBgView.isUserInteractionEnabled = true
        
        var leftBarItemsTotalWidth: CGFloat = 0
        
        if let firstItem = items.first, items.count == 1, firstItem == .image(.back) {
            // 只有返回按钮
            let btn = createCustomImageButton(type: firstItem)
            btn.frame = .init(x: 0, y: 0, width: 44, height: 44)
            btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: -10, bottom: 10, right: 10)
            leftBgView.addSubview(btn)
                        
            leftBgView.frame = .init(x: 0, y: navigationTotal, width: 44, height: 44)
            leftBarItemsTotalWidth = 44
            
        } else if let firstItem = items[0~], firstItem == .image(.back), let secondItem = items[1~], secondItem == .image(.close) {
            
            let backBtn = createCustomImageButton(type: firstItem)
            backBtn.frame = .init(x: 0, y: 0, width: 44, height: 44)
            backBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: -10, bottom: 10, right: 10)

            let closeBtn = createCustomImageButton(type: secondItem)
            closeBtn.frame = .init(x: 32, y: 0, width: 32, height: 44)
            closeBtn.imageEdgeInsets = UIEdgeInsets(top: 15.33, left: -9.33, bottom: 15.33, right: 9.33)

            leftBgView.addSubview(backBtn)
            leftBgView.addSubview(closeBtn)
            
            leftBgView.frame = .init(x: 0, y: navigationTotal, width: 64, height: 44)
            leftBarItemsTotalWidth = 64
        } else {
            // 如果不满足以上情况，那就是乱写的，直接设置一个返回按钮
            
            let btn = createCustomImageButton(type: BTBarButtonItemType.image(.back))
            btn.frame = .init(x: -10, y: 0, width: 44, height: 44)
            leftBgView.addSubview(btn)
            
            leftBgView.frame = .init(x: 0, y: navigationTotal, width: 44, height: 44)
            leftBarItemsTotalWidth = 44
        }
        let systemMargin = getBarButtomItemMargin()
        sideBarItemWidth = systemMargin + leftBarItemsTotalWidth + 6
        leftBarView = leftBgView
    }
    
    /// 生成右侧按钮区的按钮
    private func makeNavigationRightSideView(target: Any, actionSelector: Selector) {
        
        var itemsArray: [UIBarButtonItem] = []
        var rightBarItemsTotalWidth: CGFloat = 0
        
        for type in items {
            
            switch type {
            
            case .text(let textType):
                
                switch textType {
                case .exampleAnylise, .reportError:
                    let btn = createCustomTitleButton(type: type)
                    
                    let barBtn = UIBarButtonItem.init(customView: btn)
                    itemsArray.append(barBtn)
                    
                    rightBarItemsTotalWidth = rightBarItemsTotalWidth + btn.frame.size.width
                    
                case .custom(_, let tag):
                    let btn = createCustomTitleButton(type: type)

                    /// 添加标签
                    if let tagType = tagParam[tag] {
                        btn.addRedPoint(type: tagType, onLabel: true)
                    }
                    
                    let barBtn = UIBarButtonItem.init(customView: btn)
                    itemsArray.append(barBtn)
                    
                    rightBarItemsTotalWidth = rightBarItemsTotalWidth + btn.frame.size.width
                }
                
            case .image(let imgType):
                
                switch imgType {
                case .qxbLogo,.share,.saveImage,.backToHome,.more,.search:
                    let btn = createCustomImageButton(type: type)
                    let barBtn = UIBarButtonItem.init(customView: btn)
                    itemsArray.append(barBtn)
                    rightBarItemsTotalWidth = rightBarItemsTotalWidth + btn.frame.size.width
                    
                case .custom(let img, let tag):
                    let btn = createCustomImageButton(type: type)
                    btn.setImage(img, for: .normal)
                    
                    /// 添加标签
                    if let tagType = tagParam[tag] {
                        btn.addRedPoint(type: tagType, onLabel: false)
                    }
                    
                    let barBtn = UIBarButtonItem.init(customView: btn)
                    itemsArray.append(barBtn)
                    rightBarItemsTotalWidth = rightBarItemsTotalWidth + btn.frame.size.width
                    
                case .customUrl(let url, let tag, _):
                    let btn = BTNavigationBarButton.init(type: .custom)
                    btn.addTarget(self.target, action: self.selector, for: .touchUpInside)
                    btn.type = type
                    btn.frame.size = .init(width: 44, height: 44)
                    btn.setDownloadPicture(with: url)
                    btn.type = type
                    
                    /// 添加标签
                    if let tagType = tagParam[tag] {
                        btn.addRedPoint(type: tagType, onLabel: false)
                    }
                                        
                    let barBtn = UIBarButtonItem.init(customView: btn)
                    itemsArray.append(barBtn)
                    rightBarItemsTotalWidth = rightBarItemsTotalWidth + 44
                    
                default:
                    break
                }
            }
        }
        let systemMargin = getBarButtomItemMargin()
        sideBarItemWidth = 6 + rightBarItemsTotalWidth + CGFloat((itemsArray.count - 1) * 8) + systemMargin
        rightBarItems = itemsArray
    }
}
// MARK: - 创建自定义button的快捷方法
extension BTNavigationBarItemTool {
    
    /// 创建自定义的图片按钮
    private func createCustomImageButton(type: BTBarButtonItemType) -> BTNavigationBarButton {
        
        let btn = BTNavigationBarButton.init(type: .custom)
        btn.addTarget(self.target, action: self.selector, for: .touchUpInside)
        btn.type = type
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(type.getPicture(), for: .normal)
        btn.sizeToFit()
        
        if type == .image(.qxbLogo) { // 启信宝logo的size特殊处理
            btn.frame.size = CGSize(width: 58, height: 16)
        }
        return btn
    }
    
    /// 创建自定义的文本类型按钮
    private func createCustomTitleButton(type: BTBarButtonItemType) -> BTNavigationBarButton {
        
        /// 文本类型按钮文字不超过4个字
//        let content = title.prefix(4)
        let btn = BTNavigationBarButton.init(type: .custom)
        btn.addTarget(self.target, action: self.selector, for: .touchUpInside)
        btn.type = type
        btn.adjustsImageWhenHighlighted = false
        btn.setTitle(type.getTitle(), for: .normal)
        btn.setTitleColor(.init(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.sizeToFit()
        return btn
    }
    
}

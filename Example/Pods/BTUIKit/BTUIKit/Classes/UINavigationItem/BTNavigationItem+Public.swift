//
//  BTNavigationItem+Public.Swift
//  pluto
//
//  Created by Allen on 2020/6/17.
//  Copyright © 2020 bertadata. All rights reserved.
//
import BTFoundation

extension UINavigationItem {

    /// 创建导航栏按钮
    /// - Parameters:
    ///   - left: 左侧按钮的类型
    ///   - middle: 中间按钮的枚举类型
    ///   - right: 右侧按钮的枚举类型
    ///   - tagParam: key指的自定义按钮的tag，value显示小红点标签的类型 （小红点标签只会在右侧按钮区显示）
    ///   - sideBlock: 两侧按钮的点击事件回调
    ///   - middleBlock: 中间按钮的点击事件回掉
    public func make(left: [BTBarButtonItemType], middle: BTTitleViewType, right: [BTBarButtonItemType], tagParam:[Int: RedTagType] = [:], barItemActionBlock: BTBarButtomItemActionBlock? = nil, middleActionBlock: BTMiddleActionBlock? = nil) {
        
        self.barItemActionBlock = barItemActionBlock
        self.middleActionBlock = middleActionBlock
                
        let leftSide = BTNavigationBarItemTool.init(items: left, isLeft: true, target: self, actionSelector: #selector(didClickItem(sender:)))
        
        let rightSide = BTNavigationBarItemTool.init(items: right, isLeft: false, target: self, actionSelector:#selector(didClickItem(sender:)), tagParam: tagParam)
        
        let middleTool = BTNavigationTitleViewTool.init(item: middle, leftWidth: leftSide.sideBarItemWidth, rightWidth: rightSide.sideBarItemWidth, target: self, actionSelector: #selector(didClickMiddle))
        
        leftBarButtonItem = UIBarButtonItem.init(customView: leftSide.leftBarView)
        rightBarButtonItems = rightSide.rightBarItems
        titleView = middleTool.titleView
    }
    
    @objc private func didClickItem(sender: BTNavigationBarButton) {
        barItemActionBlock?(sender.type)
    }
    
    @objc private func didClickMiddle() {
        middleActionBlock?()
    }
}

// MARK: - 为UINavigationItem添加两个block回调的存储属性
extension UINavigationItem {
    
    public typealias BTBarButtomItemActionBlock = ((BTBarButtonItemType) -> ())
    public typealias BTMiddleActionBlock = (() -> ())
    
    private struct AssociatedKey {
        
        static var BTBarButtomItemActionBlockKey: String = "BTBarButtomItemActionBlock"
        
        static var BTMiddleActionBlockKey: String = "BTMiddleActionBlock"
    }
        
    private var barItemActionBlock: BTBarButtomItemActionBlock? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.BTBarButtomItemActionBlockKey) as? BTBarButtomItemActionBlock ?? nil
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKey.BTBarButtomItemActionBlockKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    private var middleActionBlock: BTMiddleActionBlock? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.BTMiddleActionBlockKey) as? BTMiddleActionBlock ?? nil
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKey.BTMiddleActionBlockKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
}

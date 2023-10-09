//
//  UINavigationItem+Config.Swift
//  pluto
//
//  Created by Allen on 2020/6/17.
//  Copyright © 2020 bertadata. All rights reserved.
//
//import Kingfisher
import BTFoundation

open class BTNavigationTitleViewTool: NSObject {
        
    public private(set) var item: BTTitleViewType = .onlyTitle("启信宝", .middle)
        
    public private(set) var titleView: UIView = UIView()
    
    private weak var target: UINavigationItem? = nil
    
    private var selector: Selector = #selector(aaa)
    
    public init(item: BTTitleViewType, leftWidth: CGFloat, rightWidth: CGFloat, target: UINavigationItem, actionSelector: Selector) {
        super.init()
        
        self.target = target
        self.selector = actionSelector
        self.item = item

        makeItemView(leftWidth, rightWidth)
    }
    
    @objc private func aaa() {
    
    }
}

// MARK: - make UI
extension BTNavigationTitleViewTool {
    
    private func makeItemView(_ leftItemWidth: CGFloat, _ rightItemWidth: CGFloat) {
                
        // 屏幕宽度
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width

        // 最大titleView容纳宽度
        let maxWidth: CGFloat = screenWidth - leftItemWidth - rightItemWidth
        
        var viewArray: [UIView] = []
        var isCustom: Bool = false
        switch item {
        case .onlyTitle(let title, let align):
            let label = BTNavigationMiddleTool.createLabel(title: title)
            
            switch align {
            case .middle:
                let resultFrames = BTNavigationMiddleTool.getFrames(maxWidth: maxWidth, leftBarWidth: leftItemWidth, rightBarWidth: rightItemWidth, middleTitleSize: label.frame.size)
                label.frame = resultFrames.1
                
            case .left:
                let labelHeight = label.frame.size.height
                let labelY = 22 - labelHeight/2
                label.frame = CGRect(x: 0, y: labelY, width: maxWidth, height: labelHeight)
            }
            
            viewArray.append(label)
            
        case .onlyImage(let type):

            switch type {
            case .image(let img, _):
                
                let imgView = BTNavigationMiddleTool.createImageView(image: img)
                
                let leftPictureWidth: CGFloat = screenWidth/2 - leftItemWidth
                let rightPictureWidth: CGFloat = screenWidth/2 - rightItemWidth
                
                // 计算出图片想要居中，最大的宽度
                let maxPictureWidth = min(leftPictureWidth, rightPictureWidth) * 2
                
                // 实际图片可以居中显示的允许宽度
                let imageWidth = min(imgView.frame.size.width, maxPictureWidth)
                let imageHeight = min(imgView.frame.size.height / imgView.frame.size.width * imageWidth, 44)
                let imageX = (screenWidth - imageWidth)/2 - leftItemWidth
                let imageY = 22 - imageHeight/2
                imgView.frame = .init(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
                viewArray.append(imgView)
                
            case .webUrl(let url, _):
                let imgView = UIImageView.init()
                imgView.kf.setImage(with: URL.init(string: url))
                
                let imageX = (screenWidth - maxWidth)/2 - leftItemWidth - 6
                imgView.frame = .init(x: imageX, y: 0, width: maxWidth, height: 44)
                imgView.contentMode = .scaleAspectFit
                viewArray.append(imgView)
            }
        case .questionTitle(let title):

            let bundle = Bundle.bt.getBundleWithName("BTUIKitUINavigationItemBundle", inPod: "BTUIKit")
            if let questionImage = UIImage.bt.loadImage("history_question", inBundle: bundle) {
                
                let label = BTNavigationMiddleTool.createLabel(title: title)
                let imgView = BTNavigationMiddleTool.createImageView(image: questionImage)
                
                let resultFrame = BTNavigationMiddleTool.getFrames(maxWidth: maxWidth, leftBarWidth: leftItemWidth, rightBarWidth: rightItemWidth, leftImageSize: imgView.frame.size, middleTitleSize: label.frame.size)
                
                if let leftImgFrame = resultFrame.0 {
                    imgView.frame = leftImgFrame
                }
                label.frame = resultFrame.1

                viewArray.append(imgView)
                viewArray.append(label)
            } else {
                let label = BTNavigationMiddleTool.createLabel(title: title)
                let resultFrames = BTNavigationMiddleTool.getFrames(maxWidth: maxWidth, leftBarWidth: leftItemWidth, rightBarWidth: rightItemWidth, middleTitleSize: label.frame.size)
                label.frame = resultFrames.1
                viewArray.append(label)
            }
            
        case .vipTitle(let title):
            
            let bundle = Bundle.bt.getBundleWithName("BTUIKitUINavigationItemBundle", inPod: "BTUIKit")
            if let vipImage = UIImage.bt.loadImage("TittleVip", inBundle: bundle) {
                let vipView = BTNavigationMiddleTool.createImageView(image: vipImage)
                let label = BTNavigationMiddleTool.createLabel(title: title)
                
                let resultFrames = BTNavigationMiddleTool.getFrames(maxWidth: maxWidth, leftBarWidth: leftItemWidth, rightBarWidth: rightItemWidth, middleTitleSize: label.frame.size, rightImageSize: vipView.frame.size)
                
                label.frame = resultFrames.1
                if let rightImgFrame = resultFrames.2 {
                    vipView.frame = rightImgFrame
                }
                
                viewArray.append(label)
                viewArray.append(vipView)
                
            } else {
                let label = BTNavigationMiddleTool.createLabel(title: title)
                let resultFrames = BTNavigationMiddleTool.getFrames(maxWidth: maxWidth, leftBarWidth: leftItemWidth, rightBarWidth: rightItemWidth, middleTitleSize: label.frame.size)
                label.frame = resultFrames.1
                viewArray.append(label)
            }
            
        case .custom(let customView):
            isCustom = true
            let resultFrames = BTNavigationMiddleTool.getFrames(maxWidth: maxWidth, leftBarWidth: leftItemWidth, rightBarWidth: rightItemWidth, middleTitleSize: CGSize(width: maxWidth, height: 44))
            customView.frame.origin.x = resultFrames.1.origin.x
            
            if let diyView = customView as? BTNavigationCustomTitleView {
                diyView.update(maxWidth: resultFrames.1.size.width)
            }
            titleView = .init(frame: .init(x: 0, y: 0, width: screenWidth, height: 44))
            titleView.addSubview(customView)
        }
        
        if !isCustom {
            titleView = .init(frame: .init(x: 0, y: 0, width: screenWidth, height: 44))
            titleView.backgroundColor = UIColor.clear
            titleView.isUserInteractionEnabled = true
            titleView.clipsToBounds = true
            
            let tap = UITapGestureRecognizer.init(target: self.target, action: self.selector)
            titleView.addGestureRecognizer(tap)
            
            viewArray.forEach { subView in
                titleView.addSubview(subView)
            }
        }
    }
}

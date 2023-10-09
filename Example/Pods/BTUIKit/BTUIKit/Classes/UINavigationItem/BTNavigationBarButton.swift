//
//  UINavigationItem+Config.Swift
//  pluto
//
//  Created by Allen on 2020/6/17.
//  Copyright © 2020 bertadata. All rights reserved.
//

//import Kingfisher
import BTFoundation

class BTNavigationBarButton: UIButton {
    
    var type: BTBarButtonItemType = .image(.back)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 下载URL图片并显示
    public func setDownloadPicture(with url: String) {
        
        let bundle = Bundle.bt.getBundleWithName("BTUIKitUINavigationItemBundle", inPod: "BTUIKit")
        let placeHolderImage = UIImage.bt.loadImage("nav_more", inBundle: bundle)        
        kf.setImage(with: URL.init(string: url), for: .normal,placeholder: placeHolderImage)
    }
    
    /// 在按钮上添加tag标签方法
    /// - Parameters:
    ///   - type: 标签类型
    ///   - onLabel: 添加的位置是在label上还是图片上（文字类型tag在label上，图片类型的在图片上）
    public func addRedPoint(type: RedTagType, onLabel: Bool){
        
        var fatherView: UIView? = nil
        if onLabel {
            fatherView = self.titleLabel
        } else {
            fatherView = self.imageView
        }
        
        switch type {
        case .redPoint:
            if let currentFatherView = fatherView {
                
                currentFatherView.clipsToBounds = false
                
                let size = currentFatherView.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: 20))
                let view = UIView.init(frame: .init(x: size.width, y: 0, width: 4, height: 4))
                view.backgroundColor = .red
                view.layer.cornerRadius = 2
                currentFatherView.addSubview(view)
            }
//        case .tag(let tagString):
//
//            if let currentFatherView = fatherView {
//
//                currentFatherView.clipsToBounds = false
//                let size = currentFatherView.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: 20))
//
//                if tagString.count > 0 {
//                    let view = UILabel.init(frame: .zero)
//                    view.textAlignment = .center
//                    view.textColor = .white
//                    view.backgroundColor = .red
//                    view.text = tagString
//                    view.font = UIFont.systemFont(ofSize: 6)
//                    view.sizeToFit()
//
//                    if onLabel {
//                        view.frame = .init(x: size.width, y: -3, width: view.frame.size.width + 10, height: 10)
//                    } else {
//                        view.frame = .init(x: currentFatherView.frame.size.width, y: -3, width: view.frame.size.width + 10, height: 10)
//                    }
//                    view.layer.cornerRadius = 5
//                    view.clipsToBounds = true
//                    currentFatherView.addSubview(view)
//                } else {
//                    let view = UIView.init(frame: .init(x: currentFatherView.frame.size.width, y: 0, width: 4, height: 4))
//                    view.backgroundColor = .red
//                    view.layer.cornerRadius = 2
//
//                    if onLabel {
//                        view.frame = .init(x: size.width, y: 0, width: 4, height: 4)
//                    } else {
//                        view.frame = .init(x: currentFatherView.frame.size.width, y: 0, width: 4, height: 4)
//                    }
//                    currentFatherView.addSubview(view)
//                }
//            }
//
//            break
        }
    }
}

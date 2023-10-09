//
//  BTToast+Text.swift
//  BTToast
//
//  Created by Mccc on 2020/6/24.
//


import BTFoundation


var kScreenWidth: CGFloat {
    UIScreen.main.bounds.size.width
}
var kScreenHeight: CGFloat {
    UIScreen.main.bounds.size.height
}



// MARK: - 显示纯文字
extension Prompt {
    
    
    /// 展示文字toast
    /// - Parameters:
    ///   - text: 文字内容
    ///   - offset: 距离屏幕Y轴中心的距离（正下，负上，0为中）。默认距离屏幕底部120。
    ///   - duration: 显示的时间（秒）
    ///   - respond: 交互类型
    ///   - callback: 隐藏的回调
    @discardableResult
    internal static func showText(_ text: String,
                                  offset: CGFloat = (UIScreen.main.bounds.size.height / 2 - 120),
                                  duration: CGFloat) -> UIWindow? {
        
        func createWindow() -> UIWindow {
            let label = UILabel()
            label.text = text
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 15)
            label.textAlignment = .center
            label.textColor = UIColor.white
            let labelWidth = kScreenWidth - (55 + 15) * 2
            let size = label.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude))
            label.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            let width: CGFloat = label.frame.width + 2*15
            let height: CGFloat = label.frame.height + 30
            let superFrame = CGRect(x: 0, y: 0, width: width, height: height)
            
            
            let mainView = Prompt.createMainView(frame: superFrame)
            let window = Prompt.createWindow(frame: superFrame)
            
            
            window.addSubview(mainView)
            mainView.frame = CGRect(x: (UIDevice.bt.width - width)/2, y: UIDevice.bt.height-120-height, width: width, height: height)
            
            mainView.addSubview(label)
            let labelX: CGFloat =  mainView.frame.size.width/2
            let labelY: CGFloat = mainView.frame.size.height/2
            label.center = CGPoint.init(x: labelX, y: labelY)
            
            
            windows.append(window)
            
            Prompt.autoRemove(window: window, duration: duration)
            
            return window
        }
        
        if text.isEmpty {
            return nil
        }
        var temp: UIWindow?
        
        
        DispatchQueue.main.bt.safeAsync {
            temp = createWindow()
        }        
        return temp
    }
}

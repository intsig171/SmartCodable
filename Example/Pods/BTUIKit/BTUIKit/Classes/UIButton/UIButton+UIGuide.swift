//
//  UIButton+UIGuide.swift
//  BTFoundation
//
//  Created by 满聪 on 2020/8/25.
//

import BTNameSpace


//添加渐变色

extension NamespaceWrapper where T == UIButton {

    /// UI规范Button的类型
    public enum BTCustomButtonType {
        
        /// 不做处理
        case no
        /// 圆角矩形
        case roundRect(BTCustomButtonFillType, BTCustomButtonColorType)
        /// 直角矩形
        case rectangular(BTCustomButtonFillType, BTCustomButtonColorType)
        
        
        /// 自定义Button的填充类型
        public enum BTCustomButtonFillType {
            /// 实心
            case solid
            /// 空心
            case hollow
        }
        
        
        /// 自定义Button的颜色
        public enum BTCustomButtonColorType {
            /// 主题蓝色
            case main
            /// 警告红
            case warning
            /// 自定义颜色
            case custom(String)
            
            func normalColor() -> UIColor {
                switch self {
                case .main:
                    return UIColor.bt.u0D53FB
                case .warning:
                    return UIColor.bt.uFE4C24
                case .custom(let hex):
                    return UIColor.bt.hex(hex)
                }
            }
            
            func highlightColor() -> UIColor {
                switch self {
                case .main:
                    return UIColor.bt.hex("3E72C1")
                case .warning:
                    return UIColor.bt.hex("DC4E37")
                case .custom( _ ):
                    return normalColor()
                }
            }
            
            func disableColor() -> UIColor {
                switch self {
                case .main:
                    return UIColor.bt.hex("A2BFEB")
                case .warning:
                    return normalColor()
                case .custom( _ ):
                    return normalColor()
                }
            }
        }
    }
}


extension NamespaceWrapper where T == UIButton {

    
    /// 快速生成 UI规范 的按钮样式
    /// - Parameters:
    ///   - title: 按钮的标题
    ///   - type: 按钮的类型 具体请查看 BTCustomButtonType枚举
    public func makeAppearance(title: String?, type: BTCustomButtonType) {
        
        wrappedValue.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        wrappedValue.setTitle(title, for: .normal)
        
        switch type {
            
            // 直角矩形
        case .rectangular(let fill, let colorType):
            let normalColor = colorType.normalColor()

            // 实体填充
            if case .solid = fill {
                let highlightColor = colorType.highlightColor()
                let disableColor = colorType.disableColor()
                wrappedValue.setBackgroundImage(normalColor.bt.makeImage(), for: .normal)
                wrappedValue.setBackgroundImage(highlightColor.bt.makeImage(), for: .highlighted)
                wrappedValue.setBackgroundImage(disableColor.bt.makeImage(), for: .disabled)
                wrappedValue.setTitleColor(UIColor.white, for: .normal)
            } else { // 空心
                wrappedValue.setBackgroundImage(UIColor.white.bt.makeImage(), for: [.normal, .highlighted])
                wrappedValue.setBackgroundImage(UIColor.white.bt.makeImage(), for: .highlighted)
                wrappedValue.setTitleColor(normalColor, for: .normal)
                
                wrappedValue.layer.borderWidth = 1
                wrappedValue.layer.borderColor = normalColor.cgColor
            }

        case .roundRect(let fill, let colorType):
            
            let normalColor = colorType.normalColor()

            // 实体填充
            if case .solid = fill {
                
                let highlightColor = colorType.highlightColor()
                let disableColor = colorType.disableColor()
                
                wrappedValue.setBackgroundImage(normalColor.bt.makeImage(), for: .normal)
                wrappedValue.setBackgroundImage(highlightColor.bt.makeImage(), for: .highlighted)
                wrappedValue.setBackgroundImage(disableColor.bt.makeImage(), for: .disabled)
                wrappedValue.setTitleColor(UIColor.white, for: .normal)
                
                wrappedValue.layer.masksToBounds = true
                wrappedValue.layer.cornerRadius = 4
            } else { // 空心
                wrappedValue.setBackgroundImage(UIColor.white.bt.makeImage(), for: [.normal, .highlighted])
                wrappedValue.setTitleColor(normalColor, for: .normal)
                
                wrappedValue.layer.masksToBounds = true
                wrappedValue.layer.cornerRadius = 4
                wrappedValue.layer.borderWidth = 1
                wrappedValue.layer.borderColor = normalColor.cgColor
            }
        default:
            break
        }
    }
}

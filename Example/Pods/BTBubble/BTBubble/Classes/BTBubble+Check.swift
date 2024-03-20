//
//  BTBubble+Check.swift
//  BTBubble
//
//  Created by Mccc on 2022/11/21.
//

import Foundation


extension BTBubble {
    
    /// 获取目标的中心点X值
    func formCenterX() -> CGFloat {
        
        /** 校验
         1. 不可以超出自身
         */
        
        if horizontalOffset >= from.width / 2 {
            return from.origin.x + from.width / 2
        } else {
            return from.origin.x + from.width / 2 + horizontalOffset
        }
    }
    
    
    /// 获取目标的中心点Y值
    func getFormCenterY() -> CGFloat {
        return from.origin.y + from.height / 2 + horizontalOffset
    }
}

extension BTBubble {
    
    /// 箭头偏移量是否满足条件
    func checkArrowOffset(maxOffset: CGFloat) -> Bool {
        
        // arrowOffset需要大于0 ，不然箭头就和角重合了。

        switch arrowOffset {
        case .before(let o):
            if o > 0 && o < maxOffset {
                return true
            }
        case .center(let o):
            if o > 0 && o < maxOffset {
                return true
            }
        case .after(let o):
            if o > 0 && o < maxOffset {
                return true
            }
        case .auto(let o):
            if o > 0 && o < maxOffset {
                return true
            }
        }
        
        return false
    }
}



extension BTBubble {
    
    /** 明确气泡显示方向
     * 如果没有明确方向，就自己决定方向
     * 尽可能的让气泡的显示趋向屏幕中间
     */
    func checkDirection() -> BTBubble.Direction {
        if direction.isAuto {
            guard let containerView = containerView else { return direction }
            var spaces: [BTBubble.Direction: CGFloat] = [:]
            
            if direction == .autoHorizontal || direction == .auto {
                spaces[.left] = from.minX - containerView.frame.minX
                spaces[.right] = containerView.frame.maxX - from.maxX
            }
            
            if direction == .autoVertical || direction == .auto {
                spaces[.up] = from.minY - containerView.frame.minY
                spaces[.down] = containerView.frame.maxY - from.maxY
            }
            
            // 降序排序， 获取最大空间的一个方案，尽可能的让气泡显示在屏幕中间
            if let space = spaces.sorted(by: { $0.1 > $1.1 }).first {
                return space.key
            }
        }
        
        return direction
    }
}


extension BTBubble {
    
    /// 校验最大宽度
    func checkMaxWidth() -> CGFloat {
        
        
        /** 校验最大宽度
         * 1. 最大宽度不可以超过（屏幕宽度 - distanceFromBoundary）
         */
        func check(_ width: CGFloat) -> CGFloat {
            let maxWidth = UIDevice.width - distanceFromBoundary*2
            
            let width = min(width, maxWidth)
            
            return max(width, 10)
        }
        
        
        guard let containerView = containerView else { return maxWidth }
        if direction.isHorizontal {
            func check(autoWidth: inout CGFloat) {
                
                if autoWidth <= 0 {
                    autoWidth = 0
                }
                                
                if autoWidth > distanceFromBoundary {
                    autoWidth = autoWidth - distanceFromBoundary
                }
                maxWidth = CGFloat.minimum(maxWidth, autoWidth)
                
                // 当方向上无法满足要求的时候，重新设置方向 (一直不满足条件的话，有可能会死循环)
                if maxWidth <= edgeInsets.horizontal && !isResetDirection {
                    direction = .auto
                    isResetDirection = true
                    setup()
                    return
                }
            }
            
            
            // 最大可显示宽度
            switch direction {
            case .left:
                var autoWidth = from.origin.x - arrowSize.height
                check(autoWidth: &autoWidth)
            case .right:
                var autoWidth = containerView.bounds.width - from.maxX - arrowSize.height
                check(autoWidth: &autoWidth)
            default:
                break
            }
        } else {
            let maxW = check(maxWidthBackUp)
            return maxW
        }
        
        let maxW = check(maxWidth)
        return maxW
        
    }
}

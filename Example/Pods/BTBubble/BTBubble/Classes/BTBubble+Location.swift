//
//  BTBubble+Location.swift
//  BTBubble
//
//  Created by Mccc on 2022/11/21.
//

import Foundation


/** 待办
 1. 通过象限，定位气泡箭头的位置。决定箭头处于气泡的位置。
 2. 新增一个arrowMinOffset，气泡距离边界的最小距离。
 */



extension BTBubble {
    public enum Direction {
        /// 上面
        case up
        /// 下面
        case down
        /// 左侧
        case left
        /// 右侧
        case right
        /// 自动计算
        case auto
        /// 水平方向自动计算
        case autoHorizontal
        /// 竖直方向自动计算
        case autoVertical
        
        /// 是否自动计算方向
        var isAuto: Bool {
            return self == .autoVertical || self == .autoHorizontal || self == .auto
        }
        
        /// 是否横向方向
        var isHorizontal: Bool {
            return self == .left || self == .right || self == .autoHorizontal
        }
        
        /// 是否纵向方向
        var isVertical: Bool {
            return self == .up || self == .down || self == .autoVertical
        }
    }
}

extension BTBubble {
    
    
    /// 设置箭头所在的位置
    /// 1. 先确定气泡的方向，根据气泡和目标的连线判断：是水平方向还是竖直方向。
    ///
    /// 2. 确定了方向，再来理解ArrowOffset的几个枚举项。
    ///
    /// 3. before：
    /// 3.1 水平方向下，
    /// 箭头位于气泡最左侧。
    /// 期望箭头向左偏移就使用负数，向右偏移就使用正数。
    ///
    /// 3.2 竖直方向下
    /// 箭头在气泡的最上侧。
    /// 期望箭头向上偏移就使用负数，向下偏移就使用正数。
    ///
    /// 4 center：
    /// 4.1 水平方向下
    /// 箭头在气泡的中心。
    /// 期望箭头向左偏移就使用负数，向右偏移就使用正数。
    ///
    /// 4.2 竖直方向下
    /// 箭头在气泡的中心。
    /// 期望箭头向上偏移就使用负数，向下偏移就使用正数。
    ///
    /// 5 after：
    /// 5.1 水平方向下
    /// 箭头在气泡的最右侧。
    /// 期望箭头向左偏移就使用负数，向右偏移就使用正数。
    ///
    /// 5.2 竖直方向下
    /// 箭头在目标的最下侧
    /// 期望箭头向上偏移就使用负数，向下偏移就使用正数。
    ///
    /// 6 auto：
    /// 根据象限自动计算
    ///
    /// 7. 注意
    /// 气泡不允许超出屏幕，如果超出了，内部会自动修正。但是如果箭头位置超出了气泡的边缘，就隐藏箭头。
    public enum ArrowOffset {
        case before(CGFloat)
        case center(CGFloat)
        case after(CGFloat)
        case auto(CGFloat)
        
        var value: CGFloat {
            switch self {
            case .before(let o):
                return o
            case .center(let o):
                return o
            case .after(let o):
                return o
            case .auto(let o):
                return o
            }
        }
    }
}



extension BTBubble {
    
    /// 气泡所在的象限
    enum Quadrant {
        // 第一象限
        case first
        // 第二象限
        case second
        // 第三象限
        case third
        // 第四象限
        case fourth
    }
}




extension BTBubble {
    
    /// 计算目标区域，在以手机屏幕中心为坐标系的象限
    /// - 第一/四象限：箭头居气泡右侧
    /// - 第二/三象限：箭头居气泡左侧
    /// - 未获取到： 当第一象限处理。
    ///      y轴
    ///       |
    ///       |
    ///   2   |   1
    ///       |
    ///       |
    ///----屏幕中心---- x轴
    ///       |
    ///       |
    ///   3   |   4
    ///       |
    ///       |
    internal func getQuadrant(with target: CGRect) -> Quadrant? {
        
        guard let reference = containerView else { return nil }
       
        
        
        // 获取参考系原点坐标
        let referenceFrameCenter = CGPoint(x: reference.frame.minX + reference.frame.width / 2, y: reference.frame.minY + reference.frame.height / 2)
        
        
        // 目标的中心点坐标
        let targetCenter = CGPoint(x: target.minX + target.size.width/2, y: target.minY + target.size.height/2)
        
        
        // 计算参考系中，目标的x和y
        let position = (targetCenter.x - referenceFrameCenter.x, referenceFrameCenter.y - targetCenter.y)

        
        switch position {
         case (0, 0): // 原点当第二象限处理
            return .second
         case (let x, 0): // 位于x轴上
            if x > 0 { return .first } else { return .second }
         case (0, let y): // 位于y轴
            if y >= 0 { return .second } else { return .third }
         case let (x, y) where x > 0 && y > 0: // 位于第一象限
             //注意此处let写在（）外，let一整个元组对象
            return .first
         case let (x, y) where x < 0 && y > 0: // 位于第二象限
            return .second
         case let (x, y) where x < 0 && y < 0: // 位于第三象限
            return .third
         case let (x, y) where x > 0 && y < 0: // 位于第四象限
            return .fourth
         default:
            return nil
         }
    }
}

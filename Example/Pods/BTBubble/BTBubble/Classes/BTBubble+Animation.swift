//
//  BTBubble+Animation.swift
//  BTBubble
//
//  Created by Mccc on 2022/11/21.
//

import Foundation






extension BTBubble {
    
    /// 指定展示动画类型的枚举
    public enum EntranceAnimation {
        /// 缩放动画 from 0% to 100%
        case scale
        /// 淡入动画
        case fadeIn
        /// 自定义动画
        case custom
        /// No Animation
        case none
    }
}


extension BTBubble {
    /// 指定退出动画类型的枚举
    public enum ExitAnimation {
        /// 缩放动画 from 0% to 100%
        case scale
        /// 淡出动画
        case fadeOut
        /// 自定义动画
        case custom
        /// No Animation
        case none
    }
}


extension BTBubble {
    /// 指定动作动画类型，动作动画在弹出提示可见和入口动画完成后执行
    public enum ActionAnimation {
        /// 弹出提示沿着它的方向弹跳。可以选择提供反弹偏移量
        case bounce(CGFloat?)
        /// 漂浮在原地。浮动偏移量可以选择提供
        case float(offsetX: CGFloat?, offsetY: CGFloat?)
        /// 通过改变它的大小而跳动。脉冲增加的最大数量可以选择提供
        case pulse(CGFloat?)
        /// No animation
        case none
    }
}






public extension BTBubble {
    
    /// 进入动画
    func performEntranceAnimation(completion: @escaping () -> Void) {
        
        alpha = 1
        
        switch entranceAnimation {
        case .scale:
            entranceScale(completion: completion)
        case .fadeIn:
            entranceFadeIn(completion: completion)
        case .custom:
            addBackgroundMask(to: containerView)

            containerView?.addSubview(self)
            entranceAnimationHandler?(completion)
        case .none:
            addBackgroundMask(to: containerView)

            containerView?.addSubview(self)
            completion()
        }
    }
    
    /// 退出的动画
    func performExitAnimation(completion: @escaping () -> Void) {
        switch exitAnimation {
        case .scale:
            exitScale(completion: completion)
        case .fadeOut:
            exitFadeOut(completion: completion)
        case .custom:
            exitAnimationHandler?(completion)
        case .none:
            completion()
        }
    }

    
    private func entranceScale(completion: @escaping () -> Void) {
        transform = CGAffineTransform(scaleX: 0, y: 0)
        addBackgroundMask(to: containerView)

        containerView?.addSubview(self)
        
        UIView.animate(withDuration: animationIn, delay: delayIn, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.5, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
            self.transform = .identity
            self.backgroundMask?.alpha = 1
        }) { (_) in
            completion()
        }
    }
    
    private func entranceFadeIn(completion: @escaping () -> Void) {
        addBackgroundMask(to: containerView)

        containerView?.addSubview(self)
        
        alpha = 0
        UIView.animate(withDuration: animationIn, delay: delayIn, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
            self.alpha = 1
            self.backgroundMask?.alpha = 1
        }) { (_) in
            completion()
        }
    }
    
    private func exitScale(completion: @escaping () -> Void) {
        transform = .identity
        
        UIView.animate(withDuration: animationOut, delay: delayOut, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
            self.backgroundMask?.alpha = 0
        }) { (_) in
            completion()
        }
    }
    
    private func exitFadeOut(completion: @escaping () -> Void) {
        alpha = 1
        
        UIView.animate(withDuration: animationOut, delay: delayOut, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
            self.alpha = 0
            self.backgroundMask?.alpha = 0
        }) { (_) in
            completion()
        }
    }
    
    private func addBackgroundMask(to targetView: UIView?) {
        
        guard let backgroundMask = backgroundMask, let targetView = targetView else { return }
        
        targetView.addSubview(backgroundMask)
        
        guard shouldCutoutMask else {
            if shouldShowMask {
                backgroundMask.backgroundColor = maskColor
            } else {
                backgroundMask.backgroundColor = UIColor.clear
            }
            return
        }
        
        
        // 设置切片
        let cutoutView = UIView(frame: backgroundMask.bounds)
        let cutoutShapeMaskLayer = CAShapeLayer()
        
        
        let cutoutPath = cutoutPathGenerator(from)
        let path = UIBezierPath(rect: backgroundMask.bounds)
        
        path.append(cutoutPath)
        
        cutoutShapeMaskLayer.path = path.cgPath
        cutoutShapeMaskLayer.fillRule = .evenOdd
        
        cutoutView.layer.mask = cutoutShapeMaskLayer
        cutoutView.clipsToBounds = true
        cutoutView.backgroundColor = maskColor
        cutoutView.isUserInteractionEnabled = false
        
        backgroundMask.addSubview(cutoutView)
    }
}






extension BTBubble {
    func performActionAnimation() {
        switch actionAnimation {
        case .bounce(let offset):
            shouldBounce = true
            bounceAnimation(offset: offset ?? BTBubbleConfig.shared.defaultBounceOffset)
        case .float(let offsetX, let offsetY):
            floatAnimation(offsetX: offsetX ?? BTBubbleConfig.shared.defaultFloatOffset, offsetY: offsetY ?? BTBubbleConfig.shared.defaultFloatOffset)
        case .pulse(let offset):
            pulseAnimation(offset: offset ?? BTBubbleConfig.shared.defaultPulseOffset)
        case .none:
            return
        }
    }
    
    func dismissActionAnimation(_ completion: (() -> Void)? = nil) {
        shouldBounce = false
        UIView.animate(withDuration: actionAnimationOut / 2, delay: actionDelayOut, options: .beginFromCurrentState, animations: {
            self.transform = .identity
        }) { (_) in
            self.layer.removeAllAnimations()
            completion?()
        }
    }
    
    /// 使弹出提示无限期地执行动作。在弹出提示显示后，动作动画会引起用户的注意
    func startActionAnimation() {
        performActionAnimation()
    }
    
    /// 停止弹出提示动作动画。如果弹出提示一开始就没有动画，则什么也不做
    func stopActionAnimation(_ completion: (() -> Void)? = nil) {
        dismissActionAnimation(completion)
    }
    
    
    
    private func bounceAnimation(offset: CGFloat) {
        var offsetX = CGFloat(0)
        var offsetY = CGFloat(0)
        switch direction {
        case .auto, .autoHorizontal, .autoVertical: break // The decision will be made at this point
        case .up:
            offsetY = -offset
        case .left:
            offsetX = -offset
        case .right:
            offsetX = offset
        case .down:
            offsetY = offset
        }
        
        UIView.animate(withDuration: actionAnimationIn / 10, delay: actionDelayIn, options: [.curveEaseIn, .allowUserInteraction, .beginFromCurrentState], animations: {
            self.transform = CGAffineTransform(translationX: offsetX, y: offsetY)
        }) { (completed) in
            if completed {
                UIView.animate(withDuration: self.actionAnimationIn - self.actionAnimationIn / 10, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                    self.transform = .identity
                }, completion: { (done) in
                    if self.shouldBounce && done {
                        self.bounceAnimation(offset: offset)
                    }
                })
            }
        }
    }
    
    private func floatAnimation(offsetX: CGFloat, offsetY: CGFloat) {
        var offsetX = offsetX
        var offsetY = offsetY
        switch direction {
        case .up:
            offsetY = -offsetY
        case .left:
            offsetX = -offsetX
        default: break
        }
        
        UIView.animate(withDuration: actionAnimationIn / 2, delay: actionDelayIn, options: [.curveEaseInOut, .repeat, .autoreverse, .beginFromCurrentState, .allowUserInteraction], animations: {
            self.transform = CGAffineTransform(translationX: offsetX, y: offsetY)
        }, completion: nil)
    }
    
    private func pulseAnimation(offset: CGFloat) {
        UIView.animate(withDuration: actionAnimationIn / 2, delay: actionDelayIn, options: [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState, .autoreverse, .repeat], animations: {
            self.transform = CGAffineTransform(scaleX: offset, y: offset)
        }, completion: nil)
    }
}




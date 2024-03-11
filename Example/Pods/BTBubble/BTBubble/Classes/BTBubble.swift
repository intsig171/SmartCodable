//
//  BTBubble.swift
//  BTBubble
//
//  Created by Mccc on 2022/11/21.
//

import UIKit


/** 名词解释：
 * 目标区域：触发区域，即：from
 * 气泡： 弹出的气泡
 * 气泡箭头：气泡上的箭头
 * 切片：提示 目标区域 的切片。
 * 遮盖层：遮盖层。
 */



public class BTBubble: UIView {
    
    
    // 气泡
    /// 气泡的填充颜色（背景颜色）
    public var fillColor = BTBubbleConfig.shared.appearance.backgroundColor
    /// 气泡圆角的设置
    public var cornerRadius = BTBubbleConfig.shared.appearance.cornerRadius
    /// 气泡边框颜色
    public var borderColor = BTBubbleConfig.shared.appearance.borderColor
    /// 气泡边框宽度 (设置过大，会出现UI问题)
    public var borderWidth = BTBubbleConfig.shared.appearance.borderWidth
    /// 气泡阴影的颜色
    public var shadowColor: UIColor = BTBubbleConfig.shared.appearance.shadowColor
    /// 气泡阴影的偏移量
    public var shadowOffset: CGSize = BTBubbleConfig.shared.appearance.shadowOffset
    /// 气泡阴影的圆角
    public var shadowRadius: Float = BTBubbleConfig.shared.appearance.shadowRadius
    /// 气泡阴影的不透明度
    public var shadowOpacity: Float = BTBubbleConfig.shared.appearance.shadowOpacity
    /// 气泡的内边距
    public var edgeInsets = BTBubbleConfig.shared.appearance.edgeInsets

    
    // 气泡文字
    /// 气泡上的文字大小
    public var font = BTBubbleConfig.shared.textSetting.font
    /// 气泡上的文字颜色
    public var textColor = BTBubbleConfig.shared.textSetting.textColor
    /// 气泡字体的`NSTextAlignment`
    public var textAlignment = BTBubbleConfig.shared.textSetting.textAlignment
    
    
    
    // 气泡箭头
    /// 气泡箭头的大小
    public var arrowSize = BTBubbleConfig.shared.arrow.arrowSize
    /// 气泡箭头的圆角
    public var arrowRadius = BTBubbleConfig.shared.arrow.arrowRadius
    /// 气泡箭头的偏移量
    public var arrowOffset: ArrowOffset = BTBubbleConfig.shared.arrow.arrowOffset
    

    
    
    // 遮罩层
    /// 遮罩层的颜色
    public var maskColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    /// 是否显示遮罩层
    public var shouldShowMask = false
    /// 是否在遮罩层上显示挖孔（突出）
    public var shouldCutoutMask = false { didSet { verticalOffset = 8 } }
    /// 设置cutout的自定义样式 （裁剪漏出的图形）
    public var cutoutBezierPath: UIBezierPath?
    
    
    
    
    // 气泡的位置
    /// 气泡距离屏幕最小间距
    public var distanceFromBoundary = CGFloat(16.0)
    /// 气泡距离目标区域的距离（轴线方向垂直偏移，负数趋向目标移动，正数背离目标移动）
    public var verticalOffset = CGFloat(2.0)
    /// 气泡(整体)相对于目标控件的中心的偏移量（水平偏移，负数趋向左，正数向右）
    public var horizontalOffset = CGFloat(0)
    /// 目标控件的frame，可以通过改变  `from` 改变位置。
    public var from = CGRect.zero { didSet { setup() } }
    
    
    
    
    // 气泡的动画
    /// 气泡显示的动画时长
    public var animationIn: TimeInterval = 0.4
    /// 气泡显示的动画延迟时长
    public var delayIn: TimeInterval = 0
    /// 气泡显示动画的类型
    public var entranceAnimation = BTBubble.EntranceAnimation.fadeIn
    /// 自定义进入动画，需要将entranceAnimation设置为custom，并且动画结束回调回来。
    public var entranceAnimationHandler: ((@escaping () -> Void) -> Void)?
    
    /// 气泡隐藏的动画时长
    public var animationOut: TimeInterval = 0.2
    /// 气泡隐藏的动画延迟时长
    public var delayOut: TimeInterval = 0
    /// 气泡隐藏的动画类型
    public var exitAnimation = BTBubble.ExitAnimation.fadeOut
    /// 自定义结束动画，需要将exitAnimation设置为custom，并且动画结束回调回来。
    public var exitAnimationHandler: ((@escaping () -> Void) -> Void)?
    
    /// 气泡展示中的动画类型
    public var actionAnimation = BTBubble.ActionAnimation.none
    /// 气泡展示中的动画时长
    public var actionAnimationIn: TimeInterval = 1.2
    /// 气泡展示中的动画时长
    public var actionAnimationOut: TimeInterval = 1.0
    /// 气泡展示中的动画开始延迟时长
    public var actionDelayIn: TimeInterval = 0
    /// 气泡展示中的动画结束延迟时长
    public var actionDelayOut: TimeInterval = 0

    
    
    
    // 手势 & 事件
    /// 点击气泡是否支持消失
    public var shouldDismissOnTap = true
    /// 点击气泡外区域是否支持消失
    public var shouldDismissOnTapOutside = true
    /// 决定在气泡外滑动是否隐藏气泡
    public var shouldDismissOnScrollOutside = true
    /// 点击气泡区域
    public var tapHandler: ((BTBubble) -> Void)?
    /// 点击了气泡之外的区域
    public var tapOutsideHandler: ((BTBubble) -> Void)?
    /// 点击了目标区域
    public var tapTargetHandler: ((BTBubble) -> Void)?
    /// 气泡外滑动
    public var scrollOutsideHandler: ((BTBubble) -> Void)?
    
    
    /// 气泡出现
    public var appearHandler: ((BTBubble) -> Void)?
    /// 气泡消失
    public var dismissHandler: ((BTBubble) -> Void)?
    
    

    /// 弹出框显示的文本。可以更新一旦弹出提示是可见的
    public private(set) var text: String? {
        didSet {
            accessibilityLabel = text
            setNeedsLayout()
        }
    }
    /// 气泡是否可见，当动画完成时是可见的，气泡移除时是不可见的。
    public var isVisible: Bool { get { return self.superview != nil } }
    /// 气泡的位置
    public private(set) var arrowPosition = CGPoint.zero
    /// 当前的容器
    public private(set) weak var containerView: UIView?
    /// 气泡展示的方向
    public internal(set) var direction = BTBubble.Direction.auto
    /// 气泡是否正在动画中
    public private(set) var isAnimating: Bool = false
    /// 遮盖层，其出现只有淡入效果。
    public private(set) var backgroundMask: UIView?
    /// 点击手势
    public private(set) var tapGestureRecognizer: UITapGestureRecognizer?
    /// 移除手势
    public private(set) var tapToRemoveGestureRecognizer: UITapGestureRecognizer?

    /// 设置cutout的样式 （裁剪漏出的图形）
    internal func cutoutPathGenerator(_ from: CGRect) -> UIBezierPath {
        if let temp = self.cutoutBezierPath {
            return temp
        } else {
            return UIBezierPath(roundedRect: from.insetBy(dx: -8, dy: -8), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8))
        }
    }
    
    internal var maxWidth = BTBubbleConfig.shared.maxWidth
    internal var maxWidthBackUp: CGFloat = BTBubbleConfig.shared.maxWidth
    
    
    fileprivate var attributedText: NSMutableAttributedString?
    fileprivate var paragraphStyle = NSMutableParagraphStyle()
    fileprivate var panGestureRecognizer: UIPanGestureRecognizer?
    fileprivate var dismissTimer: Timer?
    fileprivate var textBounds = CGRect.zero
    fileprivate var customView: UIView?
    fileprivate var hostingController: UIViewController?
    fileprivate var isApplicationInBackground: Bool?
    

    fileprivate var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    var shouldBounce = false
    

    /// 是否重新调整过方向
    var isResetDirection = false

    
    
    /// 展示字符串的气泡
    ///
    /// - Parameters:
    ///   - text: 字符串
    ///   - direction: 气泡的展示方向
    ///   - maxWidth： 最大宽度， 如果不合适，会被覆盖。
    ///   - view: 气泡的父视图
    ///   - frame: 目标frame，气泡箭头指向目标的中心。
    ///   - duration: 自动隐藏时间， 默认4秒, 如何设置为nil则不隐藏。
    public func show(text: String, direction: BTBubble.Direction = .autoVertical, maxWidth: CGFloat = BTBubbleConfig.shared.maxWidth, from target: UIView, duration: TimeInterval? = 4) {

        if text.count == 0 { return }
        resetView()
        
        attributedText = nil
        customView?.removeFromSuperview()
        customView = nil
        
        self.text = text
        
        accessibilityLabel = text
        self.direction = direction
            
        containerView = UIWindow.current
        self.maxWidth = maxWidth
        maxWidthBackUp = maxWidth

        label.isHidden = false
                
        from = target.convertFrameToScreen()

        show(duration: duration)
    }

    
    /// 展示富文本的气泡
    ///
    /// - Parameters:
    ///   - attributedText: 富文本字符串
    ///   - direction: 气泡的展示方向
    ///   - maxWidth： 最大宽度， 如果不合适，会被覆盖。
    ///   - view: 气泡的父视图
    ///   - frame: 目标frame，气泡箭头指向目标的中心。
    ///   - duration: 自动隐藏时间， 默认4秒, 如何设置为nil则不隐藏。
    public func show(attributedText: NSMutableAttributedString, direction: BTBubble.Direction = .autoVertical, maxWidth: CGFloat = BTBubbleConfig.shared.maxWidth, from target: UIView, duration: TimeInterval? = 4) {
        resetView()
        
        if attributedText.string.isEmpty { return }
        
        text = nil
        customView?.removeFromSuperview()
        customView = nil
        
        let newAttString = NSMutableAttributedString(attributedString: attributedText)
        let attDict = newAttString.attributes(at: 0, effectiveRange: nil)
        if !attDict.keys.contains(.foregroundColor) {
            newAttString.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: newAttString.string.count))
        }
        
        if !attDict.keys.contains(.font) {
            newAttString.addAttribute(.font, value: font, range: NSRange(location: 0, length: newAttString.string.count))
        }
        
        self.attributedText = newAttString
        accessibilityLabel = newAttString.string
        self.direction = direction
        containerView = UIWindow.current
        self.maxWidth = maxWidth
        maxWidthBackUp = maxWidth
        
        label.isHidden = false
        from = target.convertFrameToScreen()

        show(duration: duration)
    }
    
    
    /// 展示自定义的气泡
    ///
    /// - Parameters:
    ///   - customView:自定义的view
    ///   - direction: 气泡的展示方向
    ///   - view: 气泡的父视图
    ///   - frame: 目标frame，气泡箭头指向目标的中心。
    ///   - duration: 自动隐藏时间， 默认4秒, 如何设置为nil则不隐藏。
    public func show(customView: UIView, direction: BTBubble.Direction, from target: UIView, duration: TimeInterval? = 4) {
        resetView()
        
        text = nil
        attributedText = nil
        self.direction = direction
        containerView = UIWindow.current
        maxWidth = customView.frame.size.width
        self.customView?.removeFromSuperview()
        self.customView = customView
        label.isHidden = true
        addSubview(customView)
        from = target.convertFrameToScreen()

        show(duration: duration)
    }
    

    /// 更新显示内容（文字）
    public func update(text: String) {
        self.text = text
        updateBubble()
    }
    
    /// 更新显示内容（富文本）
    public func update(attributedText: NSMutableAttributedString) {
        self.attributedText = attributedText
        updateBubble()
    }
    
    /// 更新显示内容（自定义view）
    public func update(customView: UIView) {
        // 先移除再添加，防止前后更新的custom不是一个对象。
        self.customView?.removeFromSuperview()
        self.customView = customView
        addSubview(customView)
        updateBubble()
    }
    
    
    /// 隐藏弹出提示并将其从视图中移除。当动画完成，弹出提示从父视图中移除时.
    /// - Parameter forced: 强制删除，忽略正在运行的动画
    @objc public func hide(forced: Bool = false) {
        if !forced && isAnimating {
            return
        }
        
        resetView()
        isAnimating = true
        dismissTimer?.invalidate()
        dismissTimer = nil
        
        if let gestureRecognizer = tapToRemoveGestureRecognizer {
            containerView?.removeGestureRecognizer(gestureRecognizer)
        }
        if let gestureRecognizer = panGestureRecognizer {
            containerView?.removeGestureRecognizer(gestureRecognizer)
        }
        
        let completion = {
            self.hostingController?.willMove(toParent: nil)
            self.customView?.removeFromSuperview()
            self.hostingController?.removeFromParent()
            self.customView = nil
            self.dismissActionAnimation()
            self.backgroundMask?.removeFromSuperview()
            self.backgroundMask?.subviews.forEach { $0.removeFromSuperview() }
            self.removeFromSuperview()
            self.layer.removeAllAnimations()
            self.transform = .identity
            self.isAnimating = false
            self.dismissHandler?(self)
        }
        
        if isApplicationInBackground ?? false {
            completion()
        } else {
            performExitAnimation(completion: completion)
        }
    }
    

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}



extension BTBubble {
    func setup() {
        guard let containerView = containerView else { return }
        
        var rect = CGRect.zero
        backgroundColor = .clear
        
        /** 1. 明确气泡显示方向
         * 如果没有明确方向，就自己决定方向
         * 尽可能的让气泡的显示趋向屏幕中间
         */
        direction = checkDirection()
        
        /** 2. 校验最大宽度，避免超出屏幕。
         * 横向显示的时候，计算最大宽度， 如果不满足宽度要求，就重设方向
         */
        maxWidth = checkMaxWidth()
        
        
        
        // 3. 计算label的bounds
        textBounds = textBounds(for: text, attributedText: attributedText, view: customView, with: font, edges: edgeInsets, in: maxWidth)
        
        
        // 4. 根据方向设置位置
        switch direction {
        case .auto, .autoHorizontal, .autoVertical: break // 此时已经有了方向
        case .up:
            let dimensions = setupVertically()
            rect = dimensions.0
            arrowPosition = dimensions.1
            let anchor = arrowPosition.x / rect.size.width
            layer.anchorPoint = CGPoint(x: anchor, y: 1)
            layer.position = CGPoint(x: layer.position.x + rect.width * anchor, y: layer.position.y + rect.height / 2)
        case .down:
            let dimensions = setupVertically()
            rect = dimensions.0
            arrowPosition = dimensions.1
            let anchor = arrowPosition.x / rect.size.width
            textBounds.origin = CGPoint(x: textBounds.origin.x, y: textBounds.origin.y + arrowSize.height)
            layer.anchorPoint = CGPoint(x: anchor, y: 0)
            layer.position = CGPoint(x: layer.position.x + rect.width * anchor, y: layer.position.y - rect.height / 2)
        case .left:
            let dimensions = setupHorizontally()
            rect = dimensions.0
            arrowPosition = dimensions.1
            let anchor = arrowPosition.y / rect.height
            layer.anchorPoint = CGPoint(x: 1, y: anchor)
            layer.position = CGPoint(x: layer.position.x - rect.width / 2, y: layer.position.y + rect.height * anchor)
        case .right:
            let dimensions = setupHorizontally()
            rect = dimensions.0
            arrowPosition = dimensions.1
            textBounds.origin = CGPoint(x: textBounds.origin.x + arrowSize.height, y: textBounds.origin.y)
            let anchor = arrowPosition.y / rect.height
            layer.anchorPoint = CGPoint(x: 0, y: anchor)
            layer.position = CGPoint(x: layer.position.x + rect.width / 2, y: layer.position.y + rect.height * anchor)
        }
        
        label.frame = textBounds
        if label.superview == nil {
            addSubview(label)
        }
        
        frame = rect
        
        if let customView = customView {
            customView.frame = textBounds
        }
        
        // 其实是一直展示的，通过改变颜色达到目的 shouldShowMask
        if backgroundMask == nil {
            backgroundMask = UIView()
        }
        backgroundMask?.frame = containerView.bounds
        
        setNeedsDisplay()
        
        if tapGestureRecognizer == nil {
            tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BTBubble.handleTap(_:)))
            tapGestureRecognizer?.cancelsTouchesInView = false
            self.addGestureRecognizer(tapGestureRecognizer!)
        }
        if shouldDismissOnTapOutside && tapToRemoveGestureRecognizer == nil {
            tapToRemoveGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BTBubble.handleTapOutside(_:)))
            if let _ = tapTargetHandler {
                tapToRemoveGestureRecognizer?.delegate = self
            }
        }
        if shouldDismissOnScrollOutside && panGestureRecognizer == nil {
            panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(BTBubble.handleScrollOutside(_:)))
        }
        
        if isApplicationInBackground == nil {
            NotificationCenter.default.addObserver(self, selector: #selector(BTBubble.handleApplicationActive), name: UIApplication.didBecomeActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(BTBubble.handleApplicationResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        }
    }
}

extension BTBubble {
    /// 设置垂直方向的弹出提示，返回气泡的位置 和 气泡箭头的位置
    internal func setupVertically() -> (CGRect, CGPoint) {
        guard let containerView = containerView else { return (CGRect.zero, CGPoint.zero) }

        var frame = CGRect.zero
        // 1. 计算气泡size
        let width: CGFloat = textBounds.width + edgeInsets.horizontal + borderWidth * 2
        let height: CGFloat = textBounds.height + edgeInsets.vertical + arrowSize.height + borderWidth * 2
        frame.size = CGSize(width: width, height: height)
                
        

        
        // 2. 计算气泡的x值
        var x: CGFloat = 0
        
        
        switch arrowOffset {
        case .before(let o):
            x = formCenterX() - arrowSize.width / 2 - o
        case .center(let o):
            x = formCenterX() - width/2 - o
        case .after(let o):
            x = formCenterX() - (width - arrowSize.width/2 - o)
        case .auto(let o):
            // 2.1 计算目标区域所在象限
            let quadrant = getQuadrant(with: from)
            // 如果目标处于第二&第三象限，箭头应该在气泡左侧。
            if quadrant == .second || quadrant == .third {
                if checkArrowOffset(maxOffset: width) {
                    x = formCenterX() - arrowSize.width/2 - o
                } else { // 箭头居中
                    x = formCenterX() - width/2
                }
            } else { // 如果目标处于第一&第四象限，箭头应该在气泡右侧。
                if checkArrowOffset(maxOffset: width) {
                    x = from.maxX - from.width/2 + arrowSize.width/2 + o - width
                } else { // 箭头居中
                    x = formCenterX() - width/2
                }
            }
        }
        
        

        // 2.2 限制最小值
        x = max(x, distanceFromBoundary - cornerRadius)
        // 限制最大值（不要超出父视图）
        x = min(x, containerView.bounds.width - frame.width - distanceFromBoundary + cornerRadius)

        
        
        // 3. 根据方向 计算偏移量正负
        let offset = self.verticalOffset * (direction == .up ? -1 : 1)
        
        // 4. 计算气泡y
        if direction == .down {
          frame.origin = CGPoint(x: x, y: from.origin.y + from.height + offset)
        } else {
          frame.origin = CGPoint(x: x, y: from.origin.y - frame.height + offset)
        }
        
        //5. 计算箭头的位置
        let arrowPosition = CGPoint(
          x: formCenterX() - frame.origin.x,
          y: (direction == .up) ? frame.height : from.origin.y + from.height - frame.origin.y + offset
        )
        
        return (frame, arrowPosition)
    }
    
    /// 设置横向方向的弹出提示，返回气泡的位置 和 气泡箭头的位置
    internal func setupHorizontally() -> (CGRect, CGPoint) {
        guard let containerView = containerView else { return (CGRect.zero, CGPoint.zero) }

        var frame = CGRect.zero

        // 1. 计算气泡的size
        let bubbleWidth: CGFloat = textBounds.width + edgeInsets.horizontal + arrowSize.height + borderWidth * 2
        let bubbleHeight: CGFloat = textBounds.height + edgeInsets.vertical + borderWidth * 2
        frame.size = CGSize(width: bubbleWidth, height: bubbleHeight)
        
        // 2.计算气泡的x
        let offset = self.verticalOffset * (direction == .left ? -1 : 1)
        
        var x: CGFloat = 0
        
        if direction == .left {
            x = from.origin.x - frame.width + offset
        } else {
            x = from.origin.x + from.width + offset
        }
        
        
        // 限制最小值
        x = max(x, distanceFromBoundary)
        // 限制最大值（不要超出父视图）
        x = min(x, containerView.bounds.width - frame.width - distanceFromBoundary)
        
        // 3. 计算气泡的y
        var y: CGFloat = 0
        
        
        switch arrowOffset {
        case .before(let o):
            y = getFormCenterY() - arrowSize.width/2 - o
        case .center(let o):
            y = getFormCenterY() - bubbleHeight / 2 - o
        case .after(let o):
            y = getFormCenterY() - (bubbleHeight - arrowSize.height - o)
        case .auto(let o):
            // 3.1 计算目标区域所在象限
            let quadrant = getQuadrant(with: from)
            
            // 3.2 不同象限的处理
            if bubbleHeight > o*2 + arrowSize.width {
                if quadrant == .first || quadrant == .second {
                    
                    if checkArrowOffset(maxOffset: bubbleHeight) {
                        y = from.minY + from.height / 2 - arrowSize.width/2 - o
                    } else {
                        y = getFormCenterY() - frame.height / 2
                    }
                    
                } else { // 如果目标处于第一&第四象限，箭头应该在气泡右侧。
                    if checkArrowOffset(maxOffset: bubbleHeight) {
                        y = from.minY + from.height / 2 + arrowSize.width/2 + o - bubbleHeight
                    } else {
                        y = getFormCenterY() - frame.height / 2
                    }
                }
            } else { // 居中
                y = getFormCenterY() - frame.height / 2
            }
        }
        
        

        

        // 3.3 校验Y值的范围
        if y < 0 { y = distanceFromBoundary }
        // 确保我们停留在视图限制内除非它有滚动它必须在contentview限制内而不是视图
        if let containerScrollView = containerView as? UIScrollView {
          if y + frame.height > containerScrollView.contentSize.height {
            y = containerScrollView.contentSize.height - frame.height - distanceFromBoundary
          }
        } else {
          if y + frame.height > containerView.bounds.height {
            y = containerView.bounds.height - frame.height - distanceFromBoundary
          }
        }
        
        frame.origin = CGPoint(x: x, y: y)

        
        // 确保气泡没有离开视图的边界
        let arrowPosition = CGPoint(
          x: direction == .left ? from.origin.x - frame.origin.x + offset : from.origin.x + from.width - frame.origin.x + offset,
          y: getFormCenterY() - frame.origin.y
        )

        return (frame, arrowPosition)
    }
}



extension BTBubble {
    
    /// 计算文本的bound
    fileprivate func textBounds(for text: String?, attributedText: NSMutableAttributedString?, view: UIView?, with font: UIFont, edges: UIEdgeInsets, in maxWidth: CGFloat) -> CGRect {
        var bounds = CGRect.zero
        
        let textMaxWidth: CGFloat = maxWidth - edgeInsets.horizontal
        
        if let text = text {
            bounds = NSString(string: text).boundingRect(with: CGSize(width: textMaxWidth, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        }
        if let attributedText = attributedText {
            
            // 如果没有字体属性，会计算不准。
            let range = NSRange(location: 0, length: attributedText.length)
            attributedText.enumerateAttribute(.font, in: range) { value, range, isStop in
                if value == nil {
                    attributedText.addFont(UIFont.systemFont(ofSize: 14), on: range)
                }
            }
            
            bounds = attributedText.boundingRect(with: CGSize(width: textMaxWidth, height: CGFloat.infinity), options: .usesLineFragmentOrigin, context: nil)
        }
        
        
        // 最大高度不能超过 屏幕高度的35%
        bounds.size.height = min(bounds.height, BTBubbleConfig.shared.maxHeight)
        
        if let view = view {
            bounds = view.frame
        }
        bounds.origin = CGPoint(x: edges.left, y: edges.top)
        return bounds.integral
    }
}



extension BTBubble {
    open override func draw(_ rect: CGRect) {
        
        let path = BTBubble.pathWith(rect: rect, frame: frame, direction: direction, arrowSize: arrowSize, arrowPosition: arrowPosition, arrowRadius: arrowRadius, borderWidth: borderWidth, radius: cornerRadius)
        
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = CGFloat(shadowRadius)
        layer.shadowOffset = shadowOffset
        layer.shadowColor = shadowColor.cgColor
        
        fillColor.setFill()
        path.fill()
        
        borderColor.setStroke()
        path.lineWidth = borderWidth
        path.stroke()
        
        paragraphStyle.alignment = textAlignment
        
        let titleAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: textColor
        ]
        
        if let text = text {
            label.attributedText = NSAttributedString(string: text, attributes: titleAttributes)
        } else if let text = attributedText {
            label.attributedText = text
        } else {
            label.attributedText = nil
        }
        
        label.lineBreakMode = .byTruncatingTail
    }
}



extension BTBubble {
    fileprivate func updateBubble() {
        
        self.setup()
        stopActionAnimation {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
                
                let path = BTBubble.pathWith(rect: self.frame, frame: self.frame, direction: self.direction, arrowSize: self.arrowSize, arrowPosition: self.arrowPosition, arrowRadius: self.arrowRadius, borderWidth: self.borderWidth, radius: self.cornerRadius)
                
                let shadowAnimation = CABasicAnimation(keyPath: "shadowPath")
                shadowAnimation.duration = 0.2
                shadowAnimation.toValue = path.cgPath
                shadowAnimation.isRemovedOnCompletion = true
                self.layer.add(shadowAnimation, forKey: "shadowAnimation")
            }) { (_) in
                self.startActionAnimation()
            }
        }
    }
    
    fileprivate func show(duration: TimeInterval? = nil) {
        isAnimating = true
        dismissTimer?.invalidate()
        
        setNeedsLayout()
        performEntranceAnimation {
            self.customView?.layoutIfNeeded()
            
            if let tapRemoveGesture = self.tapToRemoveGestureRecognizer {
                self.containerView?.addGestureRecognizer(tapRemoveGesture)
            }
            if let panGesture = self.panGestureRecognizer {
                self.containerView?.addGestureRecognizer(panGesture)
            }
            
            self.appearHandler?(self)
            self.performActionAnimation()

            self.isAnimating = false
            if let duration = duration {
                self.dismissTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(BTBubble.hide), userInfo: nil, repeats: false)
            }
        }
    }
    
    @objc fileprivate func handleTap(_ gesture: UITapGestureRecognizer) {
        if shouldDismissOnTap {
            hide()
        }
        tapHandler?(self)
    }
    
    @objc fileprivate func handleTapOutside(_ gesture: UITapGestureRecognizer) {
        if !isVisible {
            return
        }
        
        if shouldDismissOnTapOutside {
            hide()
        }
        
        tapOutsideHandler?(self)
    }
    
    @objc fileprivate func handleScrollOutside(_ gesture: UITapGestureRecognizer) {
        if shouldDismissOnScrollOutside {
            hide()
        }
        scrollOutsideHandler?(self)
    }
    
    @objc fileprivate func handleApplicationActive() {
        isApplicationInBackground = false
    }
    
    @objc fileprivate func handleApplicationResignActive() {
        isApplicationInBackground = true
    }
    

    
    /// 重新设置view
    fileprivate func resetView() {
        CATransaction.begin()
        layer.removeAllAnimations()
        CATransaction.commit()
        transform = .identity
        shouldBounce = false
    }
}



extension BTBubble: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        let location = touch.location(in: containerView)
        if from.contains(location) {
            tapTargetHandler?(self)
        }
        return true
    }
}

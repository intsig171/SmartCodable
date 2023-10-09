//
//  BTNavigationFrameTool.swift
//  pluto
//
//  Created by Allen on 2020/6/17.
//  Copyright © 2020 bertadata. All rights reserved.
//

class BTNavigationMiddleTool: NSObject {
        
    /// 根据titleView最大宽度，左侧图片size、中间labelsize、右侧图片size，计算出保持label居中的三个控件的frame
    /// - Parameters:
    ///   - maxWidth: titleView显示的最大宽度
    ///   - leftBarWidth: 导航栏左侧按钮区域的宽度
    ///   - rightBarWidth: 导航栏右侧按钮区域的宽度
    ///   - leftImageSize: 左侧图片size
    ///   - middleTitleSize: 中间label的size
    ///   - rightImageSize: 右侧图片的size
    /// - Returns: 返回三个控件各自的尺寸(左侧图片和右侧图片不一定有，所以是可选值)
    static func getFrames(maxWidth: CGFloat,leftBarWidth: CGFloat, rightBarWidth: CGFloat, leftImageSize: CGSize = .zero, middleTitleSize: CGSize, rightImageSize: CGSize = .zero) ->(CGRect?,CGRect,CGRect?){
        
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width

        let labelHeight = middleTitleSize.height
        let labelY = 22 - labelHeight/2
        let margin: CGFloat = 5// 写死的间距为5
        
        var labelFrame: CGRect = .zero
        var leftImgFrame: CGRect? = nil
        var rightImgFrame: CGRect? = nil
        
        var middleWidth: CGFloat = 0
        if leftImageSize != .zero {
            middleWidth = middleWidth + leftImageSize.width + margin
        }
        
        // 左边按钮除了文本框已经占据的宽度
        var leftHavenWidth = leftBarWidth
        if leftImageSize != .zero {
            leftHavenWidth = leftHavenWidth + leftImageSize.width + margin
        }
        
        // 右侧按钮除了文本框已经占据的宽度
        var rightHavenWidth = rightBarWidth
        if rightImageSize != .zero {
            rightHavenWidth = rightHavenWidth + rightImageSize.width + margin
        }
        
        // 特殊情况，如果左侧占据的宽度 右侧占据的宽度 其中有一个已经超过一半了，那么titleLabel肯定无法居中显示，直接按照保底的能显示多少展示多少处理
        if leftHavenWidth > screenWidth/2 || rightHavenWidth > screenWidth/2 {
            
            /// 这种特殊情况下，左侧图片、右侧图片都尽量靠两边，是在宽度不够重叠了，产品肯定会改展示的元素。
            var leftWidth: CGFloat = 0
            var rightWidth: CGFloat = 0

            if leftImageSize != .zero {
                leftImgFrame = .init(x: 0, y: 22 - leftImageSize.height/2, width: leftImageSize.width, height: leftImageSize.height)
                leftWidth = leftImageSize.width + margin
            }
            
            if rightImageSize != .zero {
                rightImgFrame = .init(x: maxWidth - rightImageSize.width, y: 22 - rightImageSize.height/2, width: rightImageSize.width, height: rightImageSize.height)
                rightWidth = rightImageSize.width + margin
            }
            
            labelFrame = .init(x: leftWidth, y: labelY, width: maxWidth - leftWidth - rightWidth, height: labelHeight)
            
        } else {
            // titleLabel有机会居中显示，但是可能会有部分文本无法完全展示，只能...
            // 注意点：由于省略号。。。后有15的间距，为了保证文本视觉上显示的时候居中，往右多偏移了12像素，保证...和折半的第一个字对齐
            // 长方体想要居中对齐，必须把中心线分割的左右两边中短的那边作为总宽度的一半
            if leftImageSize == .zero && rightImageSize == .zero {
                // 只有文本
                let leftHalf: CGFloat = leftBarWidth
                let rightHalf: CGFloat = rightBarWidth
                
                if leftHalf >= rightHalf {
                    // titleLabel偏右边，短的那段在左边,label总宽度为短的一半的两倍
                    var labelTrueWidth = (screenWidth/2 - leftBarWidth) * 2
                    if labelTrueWidth > middleTitleSize.width {
                        labelTrueWidth = middleTitleSize.width
                    }
                    
                    let labelX: CGFloat = screenWidth/2 - leftBarWidth - labelTrueWidth/2
                    labelFrame = .init(x: labelX, y: labelY, width: labelTrueWidth, height: labelHeight)
                } else {
                    // titleLabel偏左边，短的那段在右边,label总宽度为短的那边的宽度的两倍
                    var labelTrueWidth = (screenWidth/2 - rightBarWidth) * 2
                    if labelTrueWidth > middleTitleSize.width {
                        labelTrueWidth = middleTitleSize.width
                    }
                    let labelX: CGFloat = screenWidth/2 - leftBarWidth - labelTrueWidth/2
                    labelFrame = .init(x: labelX, y: labelY, width: labelTrueWidth, height: labelHeight)
                }
                                        
            } else if rightImageSize == .zero {
                // 图片 + 文字
                let leftHalf: CGFloat = leftBarWidth + leftImageSize.width + margin
                let rightHalf: CGFloat = rightBarWidth
                
                if leftHalf >= rightHalf {
                    // titleLabel偏右边，短的那段在左边,label总宽度为短的一半的两倍
                    var labelTrueWidth = (screenWidth/2 - leftBarWidth - leftImageSize.width - margin) * 2
                    labelTrueWidth = min(labelTrueWidth, middleTitleSize.width)
                    
                    let labelX: CGFloat = screenWidth/2 - labelTrueWidth/2 - leftBarWidth
                    labelFrame = .init(x: labelX, y: labelY, width: labelTrueWidth, height: labelHeight)
                    
                    leftImgFrame = .init(x: labelX - leftImageSize.width - margin, y: 22 - leftImageSize.height/2, width: leftImageSize.width, height: leftImageSize.height)
                    
                } else {
                    // titleLabel偏左边，短的那段在右边,label总宽度为短的那边的宽度的两倍
                    var labelTrueWidth = (screenWidth/2 - rightBarWidth) * 2
                    labelTrueWidth = min(labelTrueWidth, middleTitleSize.width)

                    let labelX: CGFloat = screenWidth/2 - leftBarWidth - labelTrueWidth/2
                    labelFrame = .init(x: labelX, y: labelY, width: labelTrueWidth, height: labelHeight)
                    
                    leftImgFrame = .init(x: labelX - margin - leftImageSize.width, y: 22 - leftImageSize.height/2, width: leftImageSize.width, height: leftImageSize.height)
                }
                
            } else if leftImageSize == .zero {
                // 文字 + 图片
                let leftHalf: CGFloat = leftBarWidth
                let rightHalf: CGFloat = rightBarWidth + rightImageSize.width + margin
                
                /// 右侧的图片在文本显示不下带省略号的时候会多12像素空格，影响美观
                var imageOffset: CGFloat = 0
                
                if leftHalf >= rightHalf {
                    // titleLabel偏右边，短的那段在左边,label总宽度为短的一半的两倍
                    var labelTrueWidth = (screenWidth/2 - leftBarWidth) * 2
                    if labelTrueWidth > middleTitleSize.width {
                        labelTrueWidth = middleTitleSize.width
                    } else {
                        imageOffset = 12
                    }
                    
                    let labelX: CGFloat = screenWidth/2 - leftHalf - labelTrueWidth/2
                    labelFrame = .init(x: labelX, y: labelY, width: labelTrueWidth, height: labelHeight)
                    
                    rightImgFrame = .init(x: labelFrame.maxX + margin - imageOffset, y: 22 - rightImageSize.height/2, width: rightImageSize.width, height: rightImageSize.height)
                    
                } else {
                    // titleLabel偏左边，短的那段在右边,label总宽度为短的那边的宽度的两倍
                    var labelTrueWidth = (screenWidth/2 - rightBarWidth - rightImageSize.width - margin) * 2
                    if labelTrueWidth > middleTitleSize.width {
                        labelTrueWidth = middleTitleSize.width
                    } else {
                        /// 计算出的可用宽度和label完全显示的宽度对比，实际可用的小，那么会被压缩
                        imageOffset = 12
                    }
                    
                    let labelX: CGFloat = screenWidth/2 - leftBarWidth - labelTrueWidth/2
                    labelFrame = .init(x: labelX, y: labelY, width: labelTrueWidth, height: labelHeight)
                    
                    rightImgFrame = .init(x: labelX + labelTrueWidth + margin - imageOffset, y: 22 - rightImageSize.height/2, width: rightImageSize.width, height: rightImageSize.height)
                }
                
            } else {
                // 文字 + 图片 + 文字
                let leftHalf: CGFloat = leftBarWidth + leftImageSize.width + margin
                let rightHalf: CGFloat = rightBarWidth + rightImageSize.width + margin
                
                var imageOffset: CGFloat = 0
                
                if leftHalf >= rightHalf {
                    // titleLabel偏右边，短的那段在左边,label总宽度为短的一半的两倍
                    var labelTrueWidth = (screenWidth/2 - leftBarWidth - leftImageSize.width - margin) * 2
                    if labelTrueWidth > middleTitleSize.width {
                        labelTrueWidth = middleTitleSize.width
                    } else {
                        imageOffset = 12
                    }

                    let labelX: CGFloat = leftImageSize.width + margin
                    labelFrame = .init(x: labelX, y: labelY, width: labelTrueWidth, height: labelHeight)
                    
                    leftImgFrame = .init(x: 0, y: 22 - leftImageSize.height/2, width: leftImageSize.width, height: leftImageSize.height)
                    
                    rightImgFrame = .init(x: leftImageSize.width + margin + labelTrueWidth + margin - imageOffset, y: 22 - rightImageSize.height/2, width: rightImageSize.width, height: rightImageSize.height)
                    
                } else {
                    // titleLabel偏左边，短的那段在右边,label总宽度为短的那边的宽度的两倍
                    var labelTrueWidth = (screenWidth/2 - rightBarWidth - rightImageSize.width - margin) * 2
                    if labelTrueWidth > middleTitleSize.width {
                        labelTrueWidth = middleTitleSize.width
                    } else {
                        imageOffset = 12
                    }

                    let labelX: CGFloat = screenWidth/2 - leftBarWidth - labelTrueWidth/2
                    labelFrame = .init(x: labelX, y: labelY, width: labelTrueWidth, height: labelHeight)
                    
                    leftImgFrame = .init(x: labelX - margin - leftImageSize.width, y: 22 - leftImageSize.height/2, width: leftImageSize.width, height: leftImageSize.height)
                    
                    rightImgFrame = .init(x: labelX + labelTrueWidth + margin - imageOffset, y: 22 - rightImageSize.height/2, width: rightImageSize.width, height: rightImageSize.height)
                }
            }
        }
        return (leftImgFrame,labelFrame,rightImgFrame)
    }
    
    /// 创建文本Label
    static func createLabel(title: String) -> UILabel {
        let titleLabel: UILabel = UILabel.init(frame: .zero)
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.init(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
        titleLabel.text = title
        titleLabel.sizeToFit()
        return titleLabel
    }
    
    /// 创建图片view
    static func createImageView(image: UIImage) -> UIImageView {
        let imgView = UIImageView.init(image: image)
        if image.size.height <= 44 {
            imgView.sizeToFit()
        } else {
            let newWidth = 44 * image.size.width / image.size.height
            imgView.frame.size = .init(width: newWidth, height: 44)
        }
        return imgView
    }
}

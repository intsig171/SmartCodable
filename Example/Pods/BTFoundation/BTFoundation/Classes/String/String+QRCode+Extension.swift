//
//  String+QRCode.swift
//  BTFoundation
//
//  Created by qxb171 on 2020/5/14.
//

import Foundation
import BTNameSpace


//MARK: - 生成二维码
extension NamespaceWrapper where T == String {

    /// 生成二维码图片
    /// - Parameter logoImage: 中间logo图片
    public func makeQRImage(_ logoImage: UIImage? = nil) -> UIImage? {
    
        let qrString = wrappedValue
    
        let stringData = qrString.data(using: String.Encoding.utf8, allowLossyConversion: false)
        //创建一个二维码的滤镜
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setValue(stringData, forKey: "inputMessage")
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        let qrCIImage = qrFilter?.outputImage
        
        // 创建一个颜色滤镜,黑白色
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(qrCIImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        // 返回二维码image
        let codeImage = UIImage(ciImage: (colorFilter.outputImage!.transformed(by: CGAffineTransform(scaleX: 5, y: 5))))
        
        // 中间一般放logo
        if logoImage != nil {
            let whiteImage = UIColor.white.makeImage()
            let whiteWaterImage = codeImage.addWatermark(image: whiteImage, scale: 4.1)
            let waterImage = whiteWaterImage.addWatermark(image: logoImage!, scale: 5)
            return waterImage
        }
        return codeImage
    }
}












//MARK - 以下为私有方法
extension UIColor {
    
    /// 通过颜色生成图片
    fileprivate func makeImage() -> UIImage {
        let rect = CGRect.init(x: 0.0, y: 0.0, width: 6.0, height: 6.0)
        UIGraphicsBeginImageContext(rect.size)
        let context : CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(self.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIImage {
    /**
     * 给图片添加水印图片
     */
    fileprivate func addWatermark(image: UIImage,scale: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        
        self.draw(in: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        let waterWH = self.size.width / scale
        let waterX = (self.size.width - waterWH) / 2
        let waterH = (self.size.height - waterWH) / 2
        
        image.draw(in: CGRect.init(x: waterX, y: waterH, width: waterWH, height: waterWH))
        UIGraphicsEndPDFContext()
        let imageNew = UIGraphicsGetImageFromCurrentImageContext()
        return imageNew!
    }
}

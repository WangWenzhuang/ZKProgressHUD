//
//  ZKProgressHUD.swift
//  ZKProgressHUD
//
//  Created by 王文壮 on 2017/3/10.
//  Copyright © 2017年 WangWenzhuang. All rights reserved.
//

import UIKit

// MARK: - ZKProgressHUD
public class ZKProgressHUD: UIView {
    /// 全局中间变量
    fileprivate var hudType: HUDType!
    fileprivate var status: String?
    fileprivate var image: UIImage?
    fileprivate var gifUrl: URL?
    fileprivate var gifSize: CGFloat?
    fileprivate var progress: CGFloat?
    
    fileprivate lazy var infoImage: UIImage? = ZKProgressHUDConfig.bundleImage(.info)
    fileprivate lazy var successImage: UIImage? = ZKProgressHUDConfig.bundleImage(.success)
    fileprivate lazy var errorImage: UIImage? = ZKProgressHUDConfig.bundleImage(.error)
    
    // MARK: - UI
    fileprivate lazy var screenView: UIView = {
        $0.frame = UIScreen.main.bounds
        $0.mask?.alpha = 0.3
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.alpha = 0.3
        $0.backgroundColor = ZKProgressHUDConfig.maskBackgroundColor
        return $0
    }(UIView())
    
    fileprivate lazy var contentView: UIView = {
        $0.layer.masksToBounds = true
        $0.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        $0.layer.cornerRadius = ZKProgressHUDConfig.cornerRadius
        $0.backgroundColor = ZKProgressHUDConfig.backgroundColor
        $0.alpha = 0
        return $0
    }(UIView())
    
    /// gif(ZKProgressHUDType)
    fileprivate lazy var gifView: ZKGifView = ZKGifView()
    
    /// image(ZKProgressHUDType)
    fileprivate lazy var imageView: UIImageView = {
        $0.contentMode = .scaleToFill
        $0.tintColor = ZKProgressHUDConfig.foregroundColor
        return $0
    }(UIImageView())
    
    /// progress(ZKProgressHUDType)
    fileprivate lazy var progressView: ZKProgressView = {
        $0.progressColor = ZKProgressHUDConfig.foregroundColor
        $0.backgroundColor = .clear
        return $0
    }(ZKProgressView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)))
    
    /// activityIndicator(ZKProgressHUDType)
    fileprivate var activityIndicatorView: UIView {
        get {
            return ZKProgressHUDConfig.animationStyle == AnimationStyle.circle ? self.circleHUDView : self.systemHUDView
        }
    }
    
    fileprivate lazy var systemHUDView: UIActivityIndicatorView = {
        $0.activityIndicatorViewStyle = .whiteLarge
        $0.sizeToFit()
        $0.startAnimating()
        return $0
    }(UIActivityIndicatorView())
    
    fileprivate lazy var circleHUDView: UIView = {
        let arcCenter = CGPoint(x: 15, y: 15)
        let smoothedPath = UIBezierPath(arcCenter: arcCenter, radius: 30, startAngle: 0, endAngle: (CGFloat)(5 * Double.pi / 3), clockwise: true)
        
        let layer = CAShapeLayer()
        layer.contentsScale = UIScreen.main.scale
        layer.frame = CGRect(x: ZKProgressHUDConfig.margin, y: ZKProgressHUDConfig.margin, width: arcCenter.x * 2, height: arcCenter.y * 2)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = ZKProgressHUDConfig.foregroundColor.cgColor
        layer.lineWidth = 3
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineJoinBevel
        layer.path = smoothedPath.cgPath
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = (Double.pi * 2)
        animation.duration = 1
        animation.isRemovedOnCompletion = false
        animation.repeatCount = Float(Int.max)
        animation.autoreverses = false
        layer.add(animation, forKey: "rotate")
        
        $0.frame.size = CGSize(width: 30 + ZKProgressHUDConfig.margin * 2, height: 30 + ZKProgressHUDConfig.margin * 2)
        $0.layer.addSublayer(layer)
        return $0
    }(UIView())
    
    fileprivate lazy var statusLabel: UILabel = {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = ZKProgressHUDConfig.font
        $0.textColor = ZKProgressHUDConfig.foregroundColor
        return $0
    }(UILabel())
}

// MARK: - 实例计算属性
extension ZKProgressHUD {
    fileprivate var screenWidht: CGFloat {
        get {
            return UIScreen.main.bounds.size.width
        }
    }
    
    fileprivate var screenHeight: CGFloat {
        get {
            return UIScreen.main.bounds.size.height
        }
    }
    
    fileprivate var maxContentViewWidth: CGFloat {
        get {
            return self.screenWidht - ZKProgressHUDConfig.margin * 2
        }
    }
    
    fileprivate var maxContentViewChildWidth: CGFloat {
        get {
            return self.screenWidht - ZKProgressHUDConfig.margin * 4
        }
    }
}

extension ZKProgressHUD {
    /// 显示
    fileprivate func show(hudType: HUDType, status: String? = nil, image: UIImage? = nil, isAutoDismiss: Bool? = nil, maskStyle: MaskStyle? = nil, imageType: ImageType? = nil, gifUrl: URL? = nil, gifSize: CGFloat? = nil) {
        DispatchQueue.main.async {
            self.dismissAll()
            self.hudType = hudType
            self.status = status == "" ? nil : status
            self.image = image
            self.gifUrl = gifUrl
            self.gifSize = gifSize
            if let imgType = imageType {
                switch imgType {
                    case .info:
                    self.image = self.infoImage
                    case .error:
                    self.image = self.errorImage
                    case .success:
                    self.image = self.successImage
                }
            }
            self.updateView(maskStyle: maskStyle)
            self.updateFrame(maskStyle: maskStyle)
            if let autoDismiss = isAutoDismiss {
                if autoDismiss {
                    self.autoDismiss(delay: ZKProgressHUDConfig.autoDismissDelay)
                }
            }
        }
    }
    /// 更新视图
    fileprivate func updateView(maskStyle: MaskStyle?) {
        ZKProgressHUD.frontWindow?.addSubview(self)
        if (maskStyle ?? ZKProgressHUDConfig.maskStyle) == .visible {
            self.addSubview(self.screenView)
        }
        self.addSubview(self.contentView)

        if self.hudType != .progress {
            self.contentView.addSubview(self.statusLabel)
        }
        switch self.hudType! {
        case .gif:
            if let url = self.gifUrl {
                self.gifView.frame.size = CGSize(width: self.gifSize ?? 100, height: self.gifSize ?? 100)
                self.gifView.showGIFImage(gifUrl: url)
                self.contentView.addSubview(self.gifView)
            }
            break
        case .image:
            self.contentView.addSubview(self.imageView)
            break
        case .progress:
            self.contentView.addSubview(self.progressView)
            break
        case .activityIndicator:
            self.contentView.addSubview(self.activityIndicatorView)
        default: break
        }
    }
    /// 更新视图大小坐标
    fileprivate func updateFrame(maskStyle: MaskStyle?) {
        if self.hudType! == .progress {
            self.contentView.frame.size = {
                let width = self.progressView.width + ZKProgressHUDConfig.margin * 2
                let height = self.progressView.height + ZKProgressHUDConfig.margin * 2
                return CGSize(width: width, height: height)
            }()
            self.progressView.frame.origin = {
                let x = (self.contentView.width - self.progressView.width) / 2
                let y = ZKProgressHUDConfig.margin
                return CGPoint(x: x, y: y)
            }()
            if let progressValue = self.progress {
                self.progressView.progress = Double(progressValue)
            }
        } else {
            if self.hudType! == .gif {
                if self.gifView.width > self.maxContentViewChildWidth {
                    self.gifView.frame.size = CGSize(width: self.maxContentViewChildWidth, height: self.maxContentViewChildWidth)
                }
            }
            if self.hudType! == .image {
                self.imageView.image = self.image
                self.imageView.sizeToFit()
                // 如果图片尺寸超过限定最大尺寸，将图片尺寸修改为限定最大尺寸
                if self.imageView.width > self.maxContentViewChildWidth {
                    self.imageView.frame.size = CGSize(width: self.maxContentViewChildWidth, height: self.maxContentViewChildWidth)
                }
            }
            
            if let text = self.status {
                self.statusLabel.isHidden = false
                self.statusLabel.text = text
                self.statusLabel.frame.size = text.size(font: ZKProgressHUDConfig.font, size: CGSize(width: self.maxContentViewChildWidth, height: 400))
                self.statusLabel.sizeToFit()
            } else {
                self.statusLabel.frame.size = CGSize.zero
                self.statusLabel.isHidden = true
            }
            
            self.contentView.frame.size = {
                var width: CGFloat = 0
                switch self.hudType! {
                case .gif:
                    width = (self.statusLabel.isHidden ? self.gifView.width : (self.gifView.width > self.statusLabel.width ? self.gifView.width : self.statusLabel.width)) + ZKProgressHUDConfig.margin * 2
                case .image:
                    width = (self.statusLabel.isHidden ? self.imageView.width : (self.imageView.width > self.statusLabel.width ? self.imageView.width : self.statusLabel.width)) + ZKProgressHUDConfig.margin * 2
                case .message:
                    width = self.statusLabel.width + ZKProgressHUDConfig.margin * 2
                case .activityIndicator:
                    width = (self.statusLabel.isHidden ? self.activityIndicatorView.width : (self.activityIndicatorView.width > self.statusLabel.width ? self.activityIndicatorView.width : self.statusLabel.width)) + ZKProgressHUDConfig.margin * 2
                default: break
                }
                
                var height: CGFloat = 0
                switch self.hudType! {
                case .gif:
                    height = (self.statusLabel.isHidden ? self.gifView.height : (self.gifView.height + ZKProgressHUDConfig.margin + self.statusLabel.height)) + ZKProgressHUDConfig.margin * 2
                case .image:
                    height = (self.statusLabel.isHidden ? self.imageView.height : (self.imageView.height + ZKProgressHUDConfig.margin + self.statusLabel.height)) + ZKProgressHUDConfig.margin * 2
                case .message:
                    height = self.statusLabel.height + ZKProgressHUDConfig.margin * 2
                case .activityIndicator:
                    height = (self.statusLabel.isHidden ? self.activityIndicatorView.height : (self.activityIndicatorView.height + ZKProgressHUDConfig.margin + self.statusLabel.height)) + ZKProgressHUDConfig.margin * 2
                default: break
                }
                
                return CGSize(width: width, height: height)
            }()
            
            switch self.hudType! {
            case .gif:
                self.gifView.frame.origin = {
                    let x = (self.contentView.width - self.gifView.width) / 2
                    let y = ZKProgressHUDConfig.margin
                    return CGPoint(x: x, y: y)
                }()
                self.statusLabel.frame.origin = {
                    let x = (self.contentView.width - self.statusLabel.width) / 2
                    let y = self.gifView.y + self.gifView.height + ZKProgressHUDConfig.margin
                    return CGPoint(x: x, y: y)
                }()
            case .image:
                self.imageView.frame.origin = {
                    let x = (self.contentView.width - self.imageView.width) / 2
                    let y = ZKProgressHUDConfig.margin
                    return CGPoint(x: x, y: y)
                }()
                self.statusLabel.frame.origin = {
                    let x = (self.contentView.width - self.statusLabel.width) / 2
                    let y = self.imageView.y + self.imageView.height + ZKProgressHUDConfig.margin
                    return CGPoint(x: x, y: y)
                }()
            case .message:
                self.statusLabel.frame.origin = {
                    let x = (self.contentView.width - self.statusLabel.width) / 2
                    let y = ZKProgressHUDConfig.margin
                    return CGPoint(x: x, y: y)
                }()
            case .activityIndicator:
                self.activityIndicatorView.frame.origin = {
                    let x = (self.contentView.width - self.activityIndicatorView.width) / 2
                    let y = ZKProgressHUDConfig.margin
                    return CGPoint(x: x, y: y)
                }()
                self.statusLabel.frame.origin = {
                    let x = (self.contentView.width - self.statusLabel.width) / 2
                    let y = self.activityIndicatorView.y + self.activityIndicatorView.height + ZKProgressHUDConfig.margin
                    return CGPoint(x: x, y: y)
                }()
            default: break
            }
        }
        
        self.contentView.frame.origin = {
            let x = (self.screenWidht - self.contentView.width) / 2
            let y = (self.screenHeight - self.contentView.height) / 2
            return CGPoint(x: x, y: y)
        }()
        if (maskStyle ?? ZKProgressHUDConfig.maskStyle) == .hide {
            self.frame = self.contentView.frame
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.contentView.alpha = 1
        })
    }
    /// 移除
    fileprivate func autoDismiss(delay: Int) {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(delay), execute: {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.4, animations: {
                    self.contentView.alpha = 0
                }, completion: { (finished) in
                    self.removeFromSuperview()
                })
            }
        })
    }
    /// 移除所有
    fileprivate func dismissAll() {
        for subview in (ZKProgressHUD.frontWindow?.subviews)! {
            if subview.isKind(of: ZKProgressHUD.self) {
                subview.removeFromSuperview()
            }
        }
    }
}

// MARK: - 类计算属性
extension ZKProgressHUD {
    fileprivate static var frontWindow: UIWindow? {
        get {
            let window = UIApplication.shared.windows.reversed().first(where: {
                $0.screen == UIScreen.main &&
                    !$0.isHidden && $0.alpha > 0 &&
                    $0.windowLevel >= UIWindowLevelNormal
            })
            return window
        }
    }
    
    static var shared: ZKProgressHUD {
        get {
            return ZKProgressHUD(frame: UIScreen.main.bounds)
        }
    }
}

// MARK: - 类方法
extension ZKProgressHUD {
    // 显示gif加载
    public static func showGif(gifUrl: URL?, gifSize: CGFloat?) {
        ZKProgressHUD.showGif(status: nil, gifUrl: gifUrl, gifSize: gifSize)
    }
    public static func showGif(status: String?, gifUrl: URL?, gifSize: CGFloat?) {
        ZKProgressHUD.showGif(status: status, gifUrl: gifUrl, gifSize: gifSize, maskStyle: nil)
    }
    public static func showGif(status: String?, gifUrl: URL?, gifSize: CGFloat?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.show(hudType: .gif, status: status, maskStyle: maskStyle, gifUrl: gifUrl, gifSize: gifSize)
    }
    
    // 显示图片
    public static func showImage(_ image: UIImage?) {
        ZKProgressHUD.showImage(image: image, status: nil)
    }
    public static func showImage(image: UIImage?, status: String?) {
        ZKProgressHUD.showImage(image: image, status: status, maskStyle: nil)
    }
    public static func showImage(image: UIImage?, status: String?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.show(hudType: .image, status: status, image: image, isAutoDismiss: true, maskStyle: maskStyle)
    }
    
    // 显示消息
    public static func showMessage(_ message: String?) {
        ZKProgressHUD.showMessage(message: message, maskStyle: nil)
    }
    public static func showMessage(message: String?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.show(hudType: .message, status: message, isAutoDismiss: true, maskStyle: maskStyle)
    }
    
    // 显示进度
    public static func showProgress(_ progress: CGFloat?) {
        ZKProgressHUD.showProgress(progress: progress, maskStyle: nil)
    }
    public static func showProgress(progress: CGFloat?, maskStyle: ZKProgressHUDMaskStyle?) {
        //        shared.progress = progress
        //        shared.show(hudType: .progress, status: nil, image: nil, isAutoDismiss: nil, maskStyle: maskStyle)
    }
    
    // 显示加载
    public static func show() {
        ZKProgressHUD.show(nil)
    }
    public static func show(_ status: String?) {
        ZKProgressHUD.show(status: status, maskStyle: nil)
    }
    public static func show(status: String?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.show(hudType: .activityIndicator, status: status, maskStyle: maskStyle)
    }
    
    // 显示普通信息
    public static func showInfo(_ status: String?) {
        ZKProgressHUD.showInfo(status: status, maskStyle: nil)
    }
    public static func showInfo(status: String?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.show(hudType: .image, status: status, isAutoDismiss: true, maskStyle: maskStyle, imageType: .info)
    }
    // 显示成功信息
    public static func showSuccess(_ status: String?) {
        ZKProgressHUD.showSuccess(status: status, maskStyle: nil)
    }
    public static func showSuccess(status: String?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.show(hudType: .image, status: status, isAutoDismiss: true, maskStyle: maskStyle, imageType: .success)
    }
    // 显示失败信息
    public static func showError(_ status: String?) {
        ZKProgressHUD.showError(status: status, maskStyle: nil)
    }
    public static func showError(status: String?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.show(hudType: .image, status: status, isAutoDismiss: true, maskStyle: maskStyle, imageType: .error)
    }
    
    @available(swift, deprecated: 3.0, message: "请使用 dismiss 方法")
    public static func hide(delay: Int? = nil) {
        ZKProgressHUD.dismiss(delay)
    }
    // 移除
    public static func dismiss(_ delay: Int? = nil) {
        DispatchQueue.main.async {
            for subview in (ZKProgressHUD.frontWindow?.subviews)! {
                if subview.isKind(of: ZKProgressHUD.self) {
                    (subview as! ZKProgressHUD).autoDismiss(delay: delay ?? 0)
                }
            }
        }
    }
    
    // 设置遮罩样式
    public static func setMaskStyle (_ maskStyle : ZKProgressHUDMaskStyle ) {
        ZKProgressHUDConfig.maskStyle  = maskStyle
    }
    // 设置遮罩背景色
    public static func setMaskBackgroundColor(_ color: UIColor) {
        ZKProgressHUDConfig.maskBackgroundColor = color
    }
    // 设置前景色
    public static func setForegroundColor(_ color: UIColor) {
        ZKProgressHUDConfig.foregroundColor = color
    }
    // 设置背景色
    public static func setBackgroundColor(_ color: UIColor) {
        ZKProgressHUDConfig.backgroundColor = color
    }
    // 设置字体
    public static func setFont(_ font: UIFont) {
        ZKProgressHUDConfig.font = font
    }
    // 设置圆角
    public static func setCornerRadius(_ cornerRadius: CGFloat) {
        ZKProgressHUDConfig.cornerRadius = cornerRadius
    }
    // 设置加载动画样式动画样式
    public static func setAnimationStyle(_ animationStyle : ZKProgressHUDAnimationStyle ) {
        ZKProgressHUDConfig.animationStyle  = animationStyle
    }
    // 设置自动隐藏延时秒数
    public static func setAutoDismissDelay(_ autoDismissDelay: Int) {
        ZKProgressHUDConfig.autoDismissDelay = autoDismissDelay
    }
}

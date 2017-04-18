//
//  ViewController.swift
//  ZKProgressHUD
//
//  Created by 王文壮 on 2017/3/10.
//  Copyright © 2017年 WangWenzhuang. All rights reserved.
//

import UIKit

// MARK: - 加载动画样式
public enum ZKProgressHUDAnimationStyle {
    /// 圆圈
    case circle
    // 系统样式（菊花）
    case system
}
fileprivate typealias AnimationStyle = ZKProgressHUDAnimationStyle

// MARK: - 遮罩样式
public enum ZKProgressHUDMaskStyle {
    /// 隐藏
    case hide
    /// 显示
    case visible
}
fileprivate typealias MaskStyle = ZKProgressHUDMaskStyle

// MARK: - 显示类型
fileprivate enum ZKProgressHUDType {
    case gif
    case image
    case message
    case progress
    case activityIndicator
}
fileprivate typealias HUDType = ZKProgressHUDType

/// MARK: - ZKProgressHUD
public class ZKProgressHUD {
    /// 默认配置
    fileprivate let restorationIdentifier: String = "ZKProgressHUD"
    fileprivate let margin: CGFloat = 20
    fileprivate var maskStyle : MaskStyle = .visible
    fileprivate var maskBackgroundColor: UIColor = .black
    fileprivate var foregroundColor: UIColor = .white
    fileprivate var backgroundColor: UIColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.6)
    fileprivate var font: UIFont = UIFont.boldSystemFont(ofSize: 15)
    fileprivate var cornerRadius: CGFloat = 6
    fileprivate var animationStyle: AnimationStyle = .circle
    fileprivate var autoDismissDelay: Int = 2
    fileprivate var infoImage: UIImage!
    fileprivate var successImage: UIImage!
    fileprivate var errorImage: UIImage!
    /// 全局中间变量
    fileprivate var hudType: HUDType!
    fileprivate var status: String?
    fileprivate var image: UIImage?
    fileprivate var progress: CGFloat?
    /// 私有初始化，加载默认图片
    private init() {
        let bundle = Bundle(for: ZKProgressHUD.self)
        let url = bundle.url(forResource: "ZKProgressHUD", withExtension: "bundle")
        let imageBundle = Bundle(url: url!)
        self.infoImage = UIImage(contentsOfFile: (imageBundle?.path(forResource: "info", ofType: "png"))!)?.withRenderingMode(.alwaysTemplate)
        self.successImage = UIImage(contentsOfFile: (imageBundle?.path(forResource: "success", ofType: "png"))!)?.withRenderingMode(.alwaysTemplate)
        self.errorImage = UIImage(contentsOfFile: (imageBundle?.path(forResource: "error", ofType: "png"))!)?.withRenderingMode(.alwaysTemplate)
    }
    // MARK: - UI
    fileprivate lazy var maskView: UIView = {
        $0.frame = UIScreen.main.bounds
        $0.mask?.alpha = 0.3
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.alpha = 0.3
        $0.backgroundColor = self.maskBackgroundColor
        $0.restorationIdentifier = self.restorationIdentifier
        return $0
    }(UIView())
    
    fileprivate lazy var contentView: UIView = {
        $0.layer.masksToBounds = true
        $0.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        $0.layer.cornerRadius = self.cornerRadius
        $0.backgroundColor = self.backgroundColor
        $0.alpha = 0
        return $0
    }(UIView())
    /// image(ZKProgressHUDType)
    fileprivate lazy var imageView: UIImageView = {
        $0.contentMode = .scaleToFill
        $0.tintColor = self.foregroundColor
        return $0
    }(UIImageView())
    /// progress(ZKProgressHUDType)
    fileprivate lazy var progressView: ZKProgressView = {
        $0.progressColor = self.foregroundColor
        $0.backgroundColor = .clear
        return $0
    }(ZKProgressView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)))
    /// activityIndicator(ZKProgressHUDType)
    fileprivate var activityIndicatorView: UIView {
        get {
            return self.animationStyle == AnimationStyle.circle ? self.circleHUDView : self.systemHUDView
        }
    }
    
    fileprivate lazy var systemHUDView: UIActivityIndicatorView = {
        $0.activityIndicatorViewStyle = .whiteLarge
        $0.sizeToFit()
        return $0
    }(UIActivityIndicatorView())
    
    fileprivate lazy var circleHUDView: UIView = {
        let arcCenter = CGPoint(x: 15, y: 15)
        let smoothedPath = UIBezierPath(arcCenter: arcCenter, radius: 30, startAngle: 0, endAngle: (CGFloat)(5 * Double.pi / 3), clockwise: true)
        
        let layer = CAShapeLayer()
        layer.contentsScale = UIScreen.main.scale
        layer.frame = CGRect(x: self.margin, y: self.margin, width: arcCenter.x * 2, height: arcCenter.y * 2)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = self.foregroundColor.cgColor
        layer.lineWidth = 3
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineJoinBevel
        layer.path = smoothedPath.cgPath
        let animation = CABasicAnimation.init(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = (Double.pi * 2)
        animation.duration = 1
        animation.isRemovedOnCompletion = false
        animation.repeatCount = Float(Int.max)
        animation.autoreverses = false
        layer.add(animation, forKey: "rotate")
        
        $0.frame.size = CGSize(width: 30 + self.margin * 2, height: 30 + self.margin * 2)
        $0.layer.addSublayer(layer)
        return $0
    }(UIView())
    
    fileprivate lazy var statusLabel: UILabel = {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = self.font
        $0.textColor = self.foregroundColor
        return $0
    }(UILabel())
    
    fileprivate static let shared = ZKProgressHUD()
}
extension ZKProgressHUD {
    /// 显示
    fileprivate func show(hudType: HUDType, status: String? = nil, image: UIImage? = nil, isAutoDismiss: Bool? = nil, maskStyle: MaskStyle? = nil) {
        DispatchQueue.main.async {
            self.hudType = hudType
            self.status = status == "" ? nil : status
            self.image = image
            self.updateView(maskStyle: maskStyle)
            self.updateFrame()
            if let autoDismiss = isAutoDismiss {
                if autoDismiss {
                    self.dismiss(delay: self.autoDismissDelay)
                }
            }
        }
    }
    /// 更新视图
    fileprivate func updateView(maskStyle: MaskStyle?) {
        self.maskView.backgroundColor = self.maskBackgroundColor
        self.contentView.backgroundColor = self.backgroundColor
        self.contentView.layer.cornerRadius = self.cornerRadius
        self.statusLabel.textColor = self.foregroundColor
        self.statusLabel.font = self.font
        self.imageView.tintColor = self.foregroundColor
        self.progressView.progressColor = self.foregroundColor
        self.systemHUDView.color = self.foregroundColor
        
        if (maskStyle ?? self.maskStyle) == .hide {
            if self.maskView.superview != nil {
                self.maskView.removeFromSuperview()
            }
        } else {
            if self.maskView.superview == nil {
                self.frontWindow?.addSubview(self.maskView)
            } else {
                self.maskView.superview?.bringSubview(toFront: maskView)
            }
        }
        
        if self.contentView.superview == nil {
            self.frontWindow?.addSubview(self.contentView)
        } else {
            self.contentView.superview?.bringSubview(toFront: contentView)
        }
        
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        if self.hudType != .progress {
            self.contentView.addSubview(self.statusLabel)
        }
        
        switch self.hudType! {
        case .gif:
            /// TODO: 添加 gif 视图
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
    fileprivate func updateFrame() {
        if self.hudType! == .progress {
            self.contentView.frame.size = {
                let width = self.progressView.width + self.margin * 2
                let height = self.progressView.height + self.margin * 2
                return CGSize(width: width, height: height)
            }()
            self.progressView.frame.origin = {
                let x = (self.contentView.width - self.progressView.width) / 2
                let y = self.margin
                return CGPoint(x: x, y: y)
            }()
            if let progressValue = self.progress {
                self.progressView.progress = Double(progressValue)
            }
        } else {
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
                self.statusLabel.frame.size = text.size(font: self.font, size: CGSize(width: self.maxContentViewChildWidth, height: 400))
                self.statusLabel.sizeToFit()
            } else {
                self.statusLabel.frame.size = CGSize.zero
                self.statusLabel.isHidden = true
            }
            
            self.contentView.frame.size = {
                var width: CGFloat = 0
                switch self.hudType! {
                case .activityIndicator:
                    width = (self.statusLabel.isHidden ? self.activityIndicatorView.width : (self.activityIndicatorView.width > self.statusLabel.width ? self.activityIndicatorView.width : self.statusLabel.width)) + self.margin * 2
                case .message:
                    width = self.statusLabel.width + self.margin * 2
                case .image:
                    width = (self.statusLabel.isHidden ? self.imageView.width : (self.imageView.width > self.statusLabel.width ? self.imageView.width : self.statusLabel.width)) + self.margin * 2
                default: break
                }
                
                var height: CGFloat = 0
                switch self.hudType! {
                case .activityIndicator:
                    height = (self.statusLabel.isHidden ? self.activityIndicatorView.height : (self.activityIndicatorView.height + self.margin + self.statusLabel.height)) + self.margin * 2
                case .message:
                    height = self.statusLabel.height + self.margin * 2
                case .image:
                    height = (self.statusLabel.isHidden ? self.imageView.height : (self.imageView.height + self.margin + self.statusLabel.height)) + self.margin * 2
                default: break
                }
                
                return CGSize(width: width, height: height)
            }()
            
            switch self.hudType! {
            case .activityIndicator:
                self.activityIndicatorView.frame.origin = {
                    let x = (self.contentView.width - self.activityIndicatorView.width) / 2
                    let y = self.margin
                    return CGPoint(x: x, y: y)
                }()
                self.statusLabel.frame.origin = {
                    let x = (self.contentView.width - self.statusLabel.width) / 2
                    let y = self.activityIndicatorView.y + self.activityIndicatorView.height + self.margin
                    return CGPoint(x: x, y: y)
                }()
            case .message:
                self.statusLabel.frame.origin = {
                    let x = (self.contentView.width - self.statusLabel.width) / 2
                    let y = self.margin
                    return CGPoint(x: x, y: y)
                }()
            case .image:
                self.imageView.frame.origin = {
                    let x = (self.contentView.width - self.imageView.width) / 2
                    let y = self.margin
                    return CGPoint(x: x, y: y)
                }()
                self.statusLabel.frame.origin = {
                    let x = (self.contentView.width - self.statusLabel.width) / 2
                    let y = self.imageView.y + self.imageView.height + self.margin
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
        if self.contentView.alpha == 0 {
            UIView.animate(withDuration: 0.4, animations: {
                self.contentView.alpha = 1
            })
        }
    }
    /// 移除
    fileprivate func dismiss(delay: Int) {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(delay), execute: {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.4, animations: {
                    self.contentView.alpha = 0
                }, completion: { (finished) in
                    if self.contentView.superview != nil {
                        self.contentView.removeFromSuperview()
                    }
                    if self.maskView.superview != nil {
                        self.maskView.removeFromSuperview()
                    }
                })
            }
        })
    }
}
// MARK: - 计算属性
extension ZKProgressHUD {
    fileprivate var frontWindow: UIWindow? {
        get {
            let window = UIApplication.shared.windows.reversed().first(where: {
                $0.screen == UIScreen.main &&
                !$0.isHidden && $0.alpha > 0 &&
                $0.windowLevel >= UIWindowLevelNormal
            })
            return window
        }
    }
    
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
            return self.screenWidht - self.margin * 2
        }
    }
    
    fileprivate var maxContentViewChildWidth: CGFloat {
        get {
            return self.screenWidht - self.margin * 4
        }
    }
}
// MARK: - ZKProgressHUD 暴露的接口
extension ZKProgressHUD {
    // 显示加载
    public static func show() {
        ZKProgressHUD.show(nil)
    }
    public static func show(_ status: String?) {
        ZKProgressHUD.show(status: status, maskStyle: nil)
    }
    public static func show(status: String?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.show(hudType: .activityIndicator, status: status, image: nil, isAutoDismiss: nil, maskStyle: maskStyle)
    }
    // 显示进度
    public static func showProgress(_ progress: CGFloat?) {
        ZKProgressHUD.showProgress(progress: progress, maskStyle: nil)
    }
    public static func showProgress(progress: CGFloat?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.progress = progress
        shared.show(hudType: .progress, status: nil, image: nil, isAutoDismiss: nil, maskStyle: maskStyle)
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
    // 显示普通信息
    public static func showInfo(_ status: String?) {
        ZKProgressHUD.showInfo(status: status, maskStyle: nil)
    }
    public static func showInfo(status: String?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.show(hudType: .image, status: status, image: shared.infoImage, isAutoDismiss: true, maskStyle: maskStyle)
    }
    // 显示成功信息
    public static func showSuccess(_ status: String?) {
        ZKProgressHUD.showSuccess(status: status, maskStyle: nil)
    }
    public static func showSuccess(status: String?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.show(hudType: .image, status: status, image: shared.successImage, isAutoDismiss: true, maskStyle: maskStyle)
    }
    // 显示失败信息
    public static func showError(_ status: String?) {
        ZKProgressHUD.showError(status: status, maskStyle: nil)
    }
    public static func showError(status: String?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.show(hudType: .image, status: status, image: shared.errorImage, isAutoDismiss: true, maskStyle: maskStyle)
    }
    // 显示消息
    public static func showMessage(_ message: String?) {
        ZKProgressHUD.showMessage(message: message, maskStyle: nil)
    }
    public static func showMessage(message: String?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.show(hudType: .message, status: message, image: nil, isAutoDismiss: true, maskStyle: maskStyle)
    }
    // 移除
    public static func dismiss(delay: Int? = nil) {
        shared.dismiss(delay: delay ?? 0)
    }
    
    // 设置遮罩样式
    public static func setMaskStyle (_ maskStyle : ZKProgressHUDMaskStyle ) {
        shared.maskStyle  = maskStyle
    }
    // 设置遮罩背景色
    public static func setMaskBackgroundColor(_ color: UIColor) {
        shared.maskBackgroundColor = color
    }
    // 设置前景色
    public static func setForegroundColor(_ color: UIColor) {
        shared.foregroundColor = color
    }
    // 设置背景色
    public static func setBackgroundColor(_ color: UIColor) {
        shared.backgroundColor = color
    }
    // 设置字体
    public static func setFont(_ font: UIFont) {
        shared.font = font
    }
    // 设置圆角
    public static func setCornerRadius(_ cornerRadius: CGFloat) {
        shared.cornerRadius = cornerRadius
    }
    // 设置加载动画样式动画样式
    public static func setAnimationStyle(_ animationStyle : ZKProgressHUDAnimationStyle ) {
        shared.animationStyle  = animationStyle
    }
    // 设置自动隐藏延时秒数
    public static func setAutoDismissDelay(_ autoDismissDelay: Int) {
        shared.autoDismissDelay = autoDismissDelay
    }
}

// MARK: - String，获取字符串尺寸
fileprivate extension String {
    func size(font: UIFont, size: CGSize) -> CGSize {
        let attribute = [ NSFontAttributeName: font ]
        let conten = NSString(string: self)
        return conten.boundingRect(with: CGSize(width: size.width, height: size.height), options: .usesLineFragmentOrigin, attributes: attribute, context: nil).size
    }
}

// MARK: - UIView，便捷获取 frame 值
fileprivate extension UIView {
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
    }
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
    }
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
    }
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
    }
}

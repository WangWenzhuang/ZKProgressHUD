//
//  ViewController.swift
//  ZKProgressHUD
//
//  Created by 王文壮 on 2017/3/10.
//  Copyright © 2017年 WangWenzhuang. All rights reserved.
//

import UIKit

fileprivate extension String {
    func size(font: UIFont, size: CGSize) -> CGSize {
        let attribute = [ NSFontAttributeName: font ]
        let conten = NSString(string: self)
        return conten.boundingRect(with: CGSize(width: size.width, height: size.height), options: .usesLineFragmentOrigin, attributes: attribute, context: nil).size
    }
}

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

// HUD 样式
public enum ZKProgressHUDAnimationStyle {
    case chrysanthemum
    case circle
}

// 遮罩样式
public enum ZKProgressHUDMaskStyle {
    case hide
    case visible
}

// 显示类型
fileprivate enum ShowType {
    case activityIndicator
    case message
    case image
    case progress
}

public final class ZKProgressHUD {
    fileprivate typealias AnimationStyle = ZKProgressHUDAnimationStyle
    
    fileprivate typealias MaskStyle = ZKProgressHUDMaskStyle
    
    fileprivate let margin: CGFloat = 20
    fileprivate var showType: ShowType!
    fileprivate var image: UIImage?
    private var _status: String?
    fileprivate var status: String? {
        get {
            return self._status
        }
        set {
            if let text = newValue {
                self._status = text.isEmpty ? nil : text
            } else {
                self._status = nil
            }
        }
    }
    fileprivate var progress: CGFloat?
    
    // 配置
    private var _maskStyle : MaskStyle = .visible
    fileprivate var maskStyle : MaskStyle  {
        get {
            return self._maskStyle
        }
        set {
            self._maskStyle = newValue
        }
    }
    
    private var _maskBackgroundColor: UIColor = .black
    fileprivate var maskBackgroundColor: UIColor {
        get {
            return self._maskBackgroundColor
        }
        set {
            self._maskBackgroundColor = newValue
            self.maskView.backgroundColor = self._maskBackgroundColor
        }
    }
    
    private var _foregroundColor: UIColor = .white
    fileprivate var foregroundColor: UIColor {
        get {
            return self._foregroundColor
        }
        set {
            self._foregroundColor = newValue
            self.statusLabel.textColor = self._foregroundColor
            self.imageView.tintColor = self._foregroundColor
            self.progressView.progressColor = self._foregroundColor
            self.hudChrysanthemumView.color = self._foregroundColor
            if self._hudCircleView != nil {
                if self._hudCircleView.superview != nil {
                    self._hudCircleView.removeFromSuperview()
                }
                self._hudCircleView = nil
            }
        }
    }
    
    private var _backgroundColor: UIColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.6)
    fileprivate var backgroundColor: UIColor {
        get {
            return self._backgroundColor
        }
        set {
            self._backgroundColor = newValue
            self.contentView.backgroundColor = self._backgroundColor
        }
    }
    
    private var _font: UIFont = UIFont.boldSystemFont(ofSize: 15)
    fileprivate var font: UIFont {
        get {
            return self._font
        }
        set {
            self._font = newValue
            self.statusLabel.font = self._font
        }
    }
    
    private var _cornerRadius: CGFloat = 6
    fileprivate var cornerRadius: CGFloat {
        get {
            return self._cornerRadius
        }
        set {
            self._cornerRadius = newValue
            self.contentView.layer.cornerRadius = self.cornerRadius
        }
    }
    
    private var _animationStyle: AnimationStyle = .circle
    fileprivate var animationStyle: AnimationStyle {
        get {
            return self._animationStyle
        }
        set {
            self._animationStyle = newValue
        }
    }
    
    private var _infoImage: UIImage!
    fileprivate var infoImage: UIImage {
        get {
            return self._infoImage
        }
        set {
            self._infoImage = newValue.withRenderingMode(.alwaysTemplate)
        }
    }
    
    private var _successImage: UIImage!
    fileprivate var successImage: UIImage {
        get {
            return self._successImage
        }
        set {
            self._successImage = newValue.withRenderingMode(.alwaysTemplate)
        }
    }
    
    private var _errorImage: UIImage!
    fileprivate var errorImage: UIImage {
        get {
            return self._errorImage
        }
        set {
            self._errorImage = newValue.withRenderingMode(.alwaysTemplate)
        }
    }
    
    private var _hideDelay: Int = 2
    fileprivate var hideDelay: Int {
        get {
            return self._hideDelay
        }
        set {
            self._hideDelay = newValue
        }
    }
    
    // UI
    private var _maskView: UIView!
    fileprivate var maskView: UIView {
        get {
            if self._maskView == nil {
                self._maskView = UIView(frame: UIScreen.main.bounds)
                self._maskView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self._maskView.alpha = 0.3
                self._maskView.backgroundColor = self.maskBackgroundColor
            }
            return self._maskView
        }
    }
    
    private var _contentView: UIView!
    fileprivate var contentView: UIView {
        get {
            if self._contentView == nil {
                self._contentView = UIView()
                self._contentView.layer.masksToBounds = true
                self._contentView.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
                self._contentView.layer.cornerRadius = self.cornerRadius
                self._contentView.backgroundColor = self.backgroundColor
                self._contentView.alpha = 0
            }
            return self._contentView
        }
    }
    
    private var _hudChrysanthemumView: UIActivityIndicatorView!
    fileprivate var hudChrysanthemumView: UIActivityIndicatorView {
        get {
            if self._hudChrysanthemumView == nil {
                self._hudChrysanthemumView = UIActivityIndicatorView()
                self._hudChrysanthemumView.activityIndicatorViewStyle = .whiteLarge
                self._hudChrysanthemumView.sizeToFit()
            }
            return self._hudChrysanthemumView
        }
    }
    
    private var _hudCircleView: UIView!
    fileprivate var hudCircleView: UIView {
        get {
            if self._hudCircleView == nil {
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
                
                self._hudCircleView = UIView()
                self._hudCircleView.frame.size = CGSize(width: 30 + self.margin * 2, height: 30 + self.margin * 2)
                self._hudCircleView.layer.addSublayer(layer)
                
            }
            return self._hudCircleView
        }
    }
    
    private var _hudView: UIView!
    fileprivate var hudView: UIView {
        get {
            return self._animationStyle == .chrysanthemum ? self.hudChrysanthemumView : self.hudCircleView
        }
    }
    
    private var _imageView: UIImageView!
    fileprivate var imageView: UIImageView {
        get {
            if self._imageView == nil {
                self._imageView = UIImageView()
                self._imageView.contentMode = .scaleToFill
                self._imageView.tintColor = self._foregroundColor
            }
            return self._imageView
        }
    }
    
    private var _progressView: ZKProgressView!
    fileprivate var progressView: ZKProgressView {
        get {
            if self._progressView == nil {
                self._progressView = ZKProgressView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                self._progressView.progressColor = self.foregroundColor
                self._progressView.backgroundColor = .clear
            }
            return self._progressView
        }
    }
    
    private var _statusLabel: UILabel!
    fileprivate var statusLabel: UILabel {
        get {
            if self._statusLabel == nil {
                self._statusLabel = UILabel()
                self._statusLabel.textAlignment = .center
                self._statusLabel.numberOfLines = 0
                self._statusLabel.font = self.font
                self._statusLabel.textColor = self.foregroundColor
            }
            return self._statusLabel
        }
    }
    
    private init() {
        let bundle = Bundle(for: ZKProgressHUD.self)
        let url = bundle.url(forResource: "ZKProgressHUD", withExtension: "bundle")
        let imageBundle = Bundle(url: url!)
        self.infoImage = UIImage(contentsOfFile: (imageBundle?.path(forResource: "info", ofType: "png"))!)!
        self.successImage = UIImage(contentsOfFile: (imageBundle?.path(forResource: "success", ofType: "png"))!)!
        self.errorImage = UIImage(contentsOfFile: (imageBundle?.path(forResource: "error", ofType: "png"))!)!
    }
    
    fileprivate static let shared = ZKProgressHUD()
}
extension ZKProgressHUD {
    fileprivate func show(showType: ShowType, status: String? = nil, image: UIImage? = nil, isHide: Bool? = nil, maskStyle: MaskStyle? = nil) {
        DispatchQueue.main.async {
            self.showType = showType
            self.status = status
            self.image = image
            self.updateView(maskStyle: maskStyle)
            self.updateFrame()
            if showType == .activityIndicator {
                self.beginLoadingAnimation()
            }
            if let hide = isHide {
                if hide {
                    self.hideView(delay: self.hideDelay)
                }
            }
        }
    }
    
    fileprivate func updateView(maskStyle: MaskStyle?) {
        let _maskStyle = maskStyle ?? self.maskStyle
 
        if _maskStyle == .hide {
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
        
        if self.hudChrysanthemumView.superview != nil {
            self.hudChrysanthemumView.removeFromSuperview()
        }
        if self.hudCircleView.superview != nil {
            self.hudCircleView.removeFromSuperview()
        }
        if self.imageView.superview != nil {
            self.imageView.removeFromSuperview()
        }
        if self.progressView.superview != nil {
            self.progressView.removeFromSuperview()
        }
        if self.statusLabel.superview != nil {
            self.statusLabel.removeFromSuperview()
        }
        
        switch self.showType! {
        case .activityIndicator:
            self.contentView.addSubview(self.hudView)
        case .image:
            self.contentView.addSubview(self.imageView)
        case .progress:
            self.contentView.addSubview(self.progressView)
        default: break
        }
        
        if self.showType! != .progress {
            self.contentView.addSubview(self.statusLabel)
        }
    }
    
    fileprivate func updateFrame() {
        if self.showType! == .progress {
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
            if self.showType! == .image {
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
                switch self.showType! {
                case .activityIndicator:
                    width = (self.statusLabel.isHidden ? self.hudView.width : (self.hudView.width > self.statusLabel.width ? self.hudView.width : self.statusLabel.width)) + self.margin * 2
                case .message:
                    width = self.statusLabel.width + self.margin * 2
                case .image:
                    width = (self.statusLabel.isHidden ? self.imageView.width : (self.imageView.width > self.statusLabel.width ? self.imageView.width : self.statusLabel.width)) + self.margin * 2
                default: break
                }
                
                var height: CGFloat = 0
                switch self.showType! {
                case .activityIndicator:
                    height = (self.statusLabel.isHidden ? self.hudView.height : (self.hudView.height + self.margin + self.statusLabel.height)) + self.margin * 2
                case .message:
                    height = self.statusLabel.height + self.margin * 2
                case .image:
                    height = (self.statusLabel.isHidden ? self.imageView.height : (self.imageView.height + self.margin + self.statusLabel.height)) + self.margin * 2
                default: break
                }
                
                return CGSize(width: width, height: height)
            }()
            
            switch self.showType! {
            case .activityIndicator:
                self.hudView.frame.origin = {
                    let x = (self.contentView.width - self.hudView.width) / 2
                    let y = self.margin
                    return CGPoint(x: x, y: y)
                }()
                self.statusLabel.frame.origin = {
                    let x = (self.contentView.width - self.statusLabel.width) / 2
                    let y = self.hudView.y + self.hudView.height + self.margin
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
    
    fileprivate func beginLoadingAnimation() {
        switch self.animationStyle {
        case .chrysanthemum:
            self.hudChrysanthemumView.startAnimating()
        case .circle: break
        }
    }
    
    fileprivate func stoploadingAnimation() {
        switch self.animationStyle {
        case .chrysanthemum:
            self.hudChrysanthemumView.stopAnimating()
        case .circle: break
        }
    }
    
    fileprivate func hideView(delay: Int? = nil) {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(delay ?? 0), execute: {
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
                    if self.showType == .activityIndicator {
                        self.stoploadingAnimation()
                    }
                })
                
            }
        })
    }
}
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
extension ZKProgressHUD {
    // 显示加载
    public static func show() {
        ZKProgressHUD.show(nil)
    }
    public static func show(_ status: String?) {
        ZKProgressHUD.show(status: status, maskStyle: nil)
    }
    public static func show(status: String?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.show(showType: .activityIndicator, status: status, image: nil, isHide: nil, maskStyle: maskStyle)
    }
    // 显示进度
    public static func showProgress(_ progress: CGFloat?) {
        ZKProgressHUD.showProgress(progress: progress, maskStyle: nil)
    }
    public static func showProgress(progress: CGFloat?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.progress = progress
        shared.show(showType: .progress, status: nil, image: nil, isHide: nil, maskStyle: maskStyle)
    }
    // 显示图片
    public static func showImage(_ image: UIImage?) {
        ZKProgressHUD.showImage(image: image, status: nil)
    }
    public static func showImage(image: UIImage?, status: String?) {
        ZKProgressHUD.showImage(image: image, status: status, maskStyle: nil)
    }
    public static func showImage(image: UIImage?, status: String?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.show(showType: .image, status: status, image: image, isHide: true, maskStyle: maskStyle)
    }
    // 显示普通信息
    public static func showInfo(_ status: String?) {
        ZKProgressHUD.showInfo(status: status, maskStyle: nil)
    }
    public static func showInfo(status: String?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.show(showType: .image, status: status, image: shared.infoImage, isHide: true, maskStyle: maskStyle)
    }
    // 显示成功信息
    public static func showSuccess(_ status: String?) {
        ZKProgressHUD.showSuccess(status: status, maskStyle: nil)
    }
    public static func showSuccess(status: String?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.show(showType: .image, status: status, image: shared.successImage, isHide: true, maskStyle: maskStyle)
    }
    // 显示失败信息
    public static func showError(_ status: String?) {
        ZKProgressHUD.showError(status: status, maskStyle: nil)
    }
    public static func showError(status: String?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.show(showType: .image, status: status, image: shared.errorImage, isHide: true, maskStyle: maskStyle)
    }
    // 显示消息
    public static func showMessage(_ message: String?) {
        ZKProgressHUD.showMessage(message: message, maskStyle: nil)
    }
    public static func showMessage(message: String?, maskStyle: ZKProgressHUDMaskStyle?) {
        shared.show(showType: .message, status: message, image: nil, isHide: true, maskStyle: maskStyle)
    }
    // 隐藏
    public static func hide(delay: Int? = nil) {
        shared.hideView(delay: delay ?? 0)
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
    // 设置 HUD 动画样式
    public static func setAnimationStyle(_ animationStyle : ZKProgressHUDAnimationStyle ) {
        shared.animationStyle  = animationStyle
    }
    // 设置隐藏延时秒数
    public static func setHideDelay(_ hideDelay: Int) {
        shared.hideDelay = hideDelay
    }
}

//
//  ViewController.swift
//  ZKProgressHUD
//
//  Created by 王文壮 on 2017/3/10.
//  Copyright © 2017年 WangWenzhuang. All rights reserved.
//

import UIKit

public class ZKProgressHUD {
    fileprivate enum HudType {
        case loading
        case message
        case image
        case imageAndMessage
        case process
    }
    fileprivate let margin:CGFloat = 20
    fileprivate var loadingImage: UIImage = UIImage(named: "loading")!
    
    fileprivate var maskBackgroundColor: UIColor = .clear
    fileprivate var foregroundColor: UIColor = .white
    fileprivate var backgroundColor: UIColor = .black
    fileprivate var font: UIFont = UIFont.boldSystemFont(ofSize: 15)
    fileprivate var dismissDelay: Int = 2
    
    fileprivate var maskView: UIView!
    fileprivate var contentView: UIView!
    fileprivate var imageView: UIImageView!
    
    private var statusLabel: UILabel!
    
    fileprivate static let shared = ZKProgressHUD()
    
    private init() {
        self.maskView = UIView(frame: UIScreen.main.bounds)
        self.maskView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.maskView.backgroundColor = self.maskBackgroundColor

        self.contentView = UIView()
        self.contentView.layer.masksToBounds = true
        self.contentView.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        self.contentView.layer.cornerRadius = 14
        self.contentView.backgroundColor = self.backgroundColor
        
        self.imageView = UIImageView()
        self.imageView.contentMode = .scaleToFill
        self.contentView.addSubview(self.imageView)
        
        self.statusLabel = UILabel()
        self.statusLabel.textAlignment = .center
        self.statusLabel.numberOfLines = 0
        self.statusLabel.font = self.font
        self.statusLabel.textColor = self.foregroundColor
        self.contentView.addSubview(self.statusLabel)
        
        self.maskView.addSubview(self.contentView)
    }
    
    fileprivate func updateView() {
        if self.maskView.superview == nil {
            self.frontWindow?.addSubview(self.maskView)
        } else {
            self.maskView.superview?.bringSubview(toFront: maskView)
        }
    }
    
    fileprivate func updateFrame(hudType: HudType = .loading, image: UIImage? = nil, status: String? = nil) {
        if hudType != .message {
            self.imageView.isHidden = false
            self.imageView.image = image
            self.imageView.sizeToFit()
            if self.imageView.width > self.maxContentViewChildWidth {
                self.imageView.frame.size = CGSize(width: self.maxContentViewChildWidth, height: self.maxContentViewChildWidth)
            }
        } else {
            self.imageView.isHidden = true
        }
        
        if let text = status {
            self.statusLabel.isHidden = false
            self.statusLabel.text = text
            self.statusLabel.frame.size = text.size(font: self.font, size: CGSize(width: self.maxContentViewChildWidth, height: 200))
            self.statusLabel.sizeToFit()
        } else {
            self.statusLabel.isHidden = true
        }
        self.contentView.frame.size = {
            var contentViewWidth: CGFloat = 0
            if self.imageView.isHidden {
                contentViewWidth = self.statusLabel.isHidden ? 0 : self.statusLabel.width + self.margin * 2
            } else {
                contentViewWidth = (self.imageView.width > self.statusLabel.width ? self.imageView.width : self.statusLabel.width) + self.margin * 2
            }
            var contentViewHeight: CGFloat = 0
            if self.imageView.isHidden {
                contentViewHeight = self.statusLabel.isHidden ? 0 : self.statusLabel.height + self.margin * 2
            } else {
                contentViewHeight = (self.statusLabel.isHidden ? self.imageView.height : (self.margin + self.imageView.height + self.statusLabel.height)) + self.margin * 2
            }
            return CGSize(width: contentViewWidth, height: contentViewHeight)
        }()
        if !self.imageView.isHidden {
            self.imageView.frame.origin = {
                let imageViewX = (self.contentView.width - self.imageView.width) / 2
                let imageViewY = self.margin
                return CGPoint(x: imageViewX, y: imageViewY)
            }()
        }
        if !self.statusLabel.isHidden {
            self.statusLabel.frame.origin = {
                let statusLabelX = (self.contentView.width - self.statusLabel.width) / 2
                let statusLabelY = (self.imageView.isHidden ? 0 : self.imageView.y + self.imageView.height) + self.margin
                return CGPoint(x: statusLabelX, y: statusLabelY)
            }()
        }
        self.contentView.frame.origin = {
            let contentViewX = (self.screenWidht - self.contentView.width) / 2
            let contentViewY = (self.screenHeight - self.contentView.height) / 2
            return CGPoint(x: contentViewX, y: contentViewY)
        }()
    }
}
extension ZKProgressHUD {
    fileprivate var frontWindow: UIWindow? {
        get {
            return UIApplication.shared.windows.reversed().first(where: {
            $0.screen == UIScreen.main &&
                !$0.isHidden && $0.alpha > 0 &&
                $0.windowLevel >= UIWindowLevelNormal})
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
    public static func loading(_ status: String? = nil) {
        DispatchQueue.main.async {
            shared.updateView()
            shared.updateFrame(hudType: .loading, image: shared.loadingImage, status: status)
        }
    }
    
    public static func message(_ message: String) {
        DispatchQueue.main.async {
            shared.updateView()
            shared.updateFrame(hudType: .message, status: message)
            ZKProgressHUD.hide(delay: shared.dismissDelay)
        }
    }
    
    public static func image(_ image: UIImage) {
        DispatchQueue.main.async {
            shared.updateView()
            shared.updateFrame(hudType: .image, image: image)
            ZKProgressHUD.hide(delay: shared.dismissDelay)
        }
    }
    
    public static func hide(delay: Int? = nil) {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(delay ?? 0), execute: {
            DispatchQueue.main.async {
                shared.maskView.removeFromSuperview()
            }
        })
    }
}
extension String {
    func size(font: UIFont, size: CGSize) -> CGSize {
        let attribute = [ NSFontAttributeName: font ]
        let conten = NSString(string: self)
        return conten.boundingRect(with: CGSize(width: size.width, height: size.height), options: .usesLineFragmentOrigin, attributes: attribute, context: nil).size
    }
}
extension UIView {
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

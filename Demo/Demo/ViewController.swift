//
//  ViewController.swift
//  Demo
//
//  Created by 王文壮 on 2017/3/10.
//  Copyright © 2017年 WangWenzhuang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var screenWidth: CGFloat {
        get {
            return UIScreen.main.bounds.size.width
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.backgroundColor = .white
        
        let loadingButton = UIButton(frame: CGRect(x: 0, y: 40, width: screenWidth, height: 25))
        loadingButton.setTitle("loading", for: .normal)
        loadingButton.setTitleColor(.blue, for: .normal)
        loadingButton.autoresizingMask = [.flexibleWidth]
        loadingButton.addTarget(self, action: #selector(ViewController.loadingAction(_:)), for: .touchUpInside)
        
        let messageButton = UIButton(frame: CGRect(x: 0, y: loadingButton.frame.origin.y + 45, width: screenWidth, height: 25))
        messageButton.setTitle("message", for: .normal)
        messageButton.setTitleColor(.blue, for: .normal)
        messageButton.autoresizingMask = [.flexibleWidth]
        messageButton.addTarget(self, action: #selector(ViewController.messageAction(_:)), for: .touchUpInside)
        
        let imageButton = UIButton(frame: CGRect(x: 0, y: messageButton.frame.origin.y + 45, width: screenWidth, height: 25))
        imageButton.setTitle("image", for: .normal)
        imageButton.setTitleColor(.blue, for: .normal)
        imageButton.autoresizingMask = [.flexibleWidth]
        imageButton.addTarget(self, action: #selector(ViewController.imageAction(_:)), for: .touchUpInside)
        
        let hideButton = UIButton(frame: CGRect(x: 0, y: imageButton.frame.origin.y + 45, width: screenWidth, height: 25))
        hideButton.setTitle("hide", for: .normal)
        hideButton.setTitleColor(.blue, for: .normal)
        hideButton.autoresizingMask = [.flexibleWidth]
        hideButton.addTarget(self, action: #selector(ViewController.hideAction(_:)), for: .touchUpInside)
        
        self.view.addSubview(loadingButton)
        self.view.addSubview(messageButton)
        self.view.addSubview(imageButton)
        self.view.addSubview(hideButton)
    }

    @IBAction func loadingAction(_ sender: UIButton) {
        ZKProgressHUD.loading("loading...")
        ZKProgressHUD.hide(delay: 2)
    }

    @IBAction func messageAction(_ sender: UIButton) {
        ZKProgressHUD.message("Hello World")
    }
    
    @IBAction func imageAction(_ sender: UIButton) {
        ZKProgressHUD.image(UIImage(named: "image")!)
        ZKProgressHUD.hide(delay: 2)
    }

    @IBAction func hideAction(_ sender: UIButton) {
        ZKProgressHUD.hide()
    }
}


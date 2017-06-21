//
//  ViewController.swift
//  Demo
//
//  Created by 王文壮 on 2017/3/10.
//  Copyright © 2017年 WangWenzhuang. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var screenWidth: CGFloat {
        get {
            return UIScreen.main.bounds.size.width
        }
    }
    
    let cellIdentifier = "cell"
    
    lazy var actionTexts = ["show", "show with status", "showProgress", "showProgress with status", "shwoImage", "showImage with status", "showInfo", "showSuccess", "showError", "showMessage", "showGif", "showGif with status"]
    lazy var headerTexts = ["动画显示/隐藏样式","遮罩样式", "加载样式", "方法"]
    
    var progressValue: CGFloat = 0
    
    lazy var animationShowStyles = [(text: "fade", animationShowStyle: ZKProgressHUDAnimationShowStyle.fade), (text: "zoom", animationShowStyle: ZKProgressHUDAnimationShowStyle.zoom), (text: "flyInto", animationShowStyle: ZKProgressHUDAnimationShowStyle.flyInto)]
    var currentAnimationShowStyleIndex = 0
    
    lazy var maskStyles = [(text: "visible", maskStyle: ZKProgressHUDMaskStyle.visible), (text: "hide", maskStyle: ZKProgressHUDMaskStyle.hide)]
    var currentMaskStyleIndex = 0
    
    lazy var animationStyles = [(text: "circle", animationStyle: ZKProgressHUDAnimationStyle.circle), (text: "system", animationStyle: ZKProgressHUDAnimationStyle.system)]
    var currentAnimationStyleIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = ""
        self.navigationItem.backBarButtonItem = backBarButtonItem
        self.title = "ZKProgressHUD"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 3 {
            return 1
        }
        return self.actionTexts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier)
        cell?.accessoryType = .none
        if indexPath.section == 0 {
            cell?.textLabel?.text = self.animationShowStyles[self.currentAnimationShowStyleIndex].text
            cell?.accessoryType = .disclosureIndicator
        } else if indexPath.section == 1 {
            cell?.textLabel?.text = self.maskStyles[self.currentMaskStyleIndex].text
            cell?.accessoryType = .disclosureIndicator
        } else if indexPath.section == 2 {
            cell?.textLabel?.text = self.animationStyles[self.currentAnimationStyleIndex].text
            cell?.accessoryType = .disclosureIndicator
        } else {
            cell?.textLabel?.text = self.actionTexts[indexPath.row]
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 0 {
            self.pushSelectView(tag: 0, title: "选择动画显示/隐藏样式", data: self.animationShowStyles)
        } else if indexPath.section == 1 {
            self.pushSelectView(tag: 1, title: "选择遮罩样式", data: self.maskStyles)
        } else if indexPath.section == 2 {
            self.pushSelectView(tag: 2, title: "选择加载样式", data: self.animationStyles)
        } else if indexPath.section == 3 {
            if indexPath.row > 9 {
                ZKProgressHUD.setEffectStyle(.extraLight)
            } else {
                ZKProgressHUD.setEffectStyle(.dark)
            }
            if indexPath.row == 0 {
                ZKProgressHUD.show()
                ZKProgressHUD.dismiss(2.5)
            } else if indexPath.row == 1 {
                ZKProgressHUD.show("正在拼命的加载中🏃🏃🏃")
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(2), execute: {
                    DispatchQueue.main.async {
                        ZKProgressHUD.dismiss()
                        ZKProgressHUD.showInfo("加载完成😁😁😁")
                    }
                })
            } else if indexPath.row == 2 {
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.showProgressTimerHandler(timer:)), userInfo: nil, repeats: true)
            } else if indexPath.row == 3 {
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.showProgressTimerHandler(timer:)), userInfo: "上传中...", repeats: true)
            } else if indexPath.row == 4 {
                ZKProgressHUD.showImage(UIImage(named: "image"))
            } else if indexPath.row == 5 {
                ZKProgressHUD.showImage(image: UIImage(named: "image"), status: "图片会自动消失😏😏😏")
            } else if indexPath.row == 6 {
                ZKProgressHUD.showInfo("Star 一下吧😙😙😙")
            } else if indexPath.row == 7 {
                ZKProgressHUD.showSuccess("操作成功👏👏👏")
            } else if indexPath.row == 8 {
                ZKProgressHUD.showError("出现错误了😢😢😢")
            } else if indexPath.row == 9 {
                ZKProgressHUD.showMessage("开始使用 ZKProgressHUD 吧")
            } else if indexPath.row == 10 {
                ZKProgressHUD.showGif(gifUrl: Bundle.main.url(forResource: "loding", withExtension: "gif"), gifSize: 80)
                ZKProgressHUD.dismiss(2)
            } else if indexPath.row == 11 {
                ZKProgressHUD.showGif(status: "没有找到好的透明图，所以设置背景色为白色😆😆😆", gifUrl: Bundle.main.url(forResource: "loding", withExtension: "gif"), gifSize: 80)
                ZKProgressHUD.dismiss(2)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headerTexts[section]
    }
    
    func showProgressTimerHandler(timer: Timer) {
        if self.progressValue >= 100 {
            if timer.isValid {
                timer.invalidate()
            }
            ZKProgressHUD.dismiss()
            self.progressValue = 0
        } else {
            self.progressValue += 5
            if let status = timer.userInfo {
                ZKProgressHUD.showProgress(self.progressValue / 100, status: status as? String)
            } else {
                ZKProgressHUD.showProgress(self.progressValue / 100)
            }
            
        }
    }
    
    func pushSelectView(tag: Int, title: String, data: [Any]) {
        let selectViewController = SelectViewController()
        selectViewController.tag = tag
        selectViewController.title = title
        selectViewController.data = data
        selectViewController.delegate = self
        self.navigationController?.pushViewController(selectViewController, animated: true)
    }
}

extension ViewController: SelectViewControllerDelegate {
    func selected(selectViewController: SelectViewController, selectIndex: Int) {
        if selectViewController.tag == 0 {
            self.currentAnimationShowStyleIndex = selectIndex
            ZKProgressHUD.setAnimationShowStyle(self.animationShowStyles[self.currentAnimationShowStyleIndex].animationShowStyle)
        } else if selectViewController.tag == 1 {
            self.currentMaskStyleIndex = selectIndex
            ZKProgressHUD.setMaskStyle(self.maskStyles[self.currentMaskStyleIndex].maskStyle)
        } else {
            self.currentAnimationStyleIndex = selectIndex
            ZKProgressHUD.setAnimationStyle(self.animationStyles[self.currentAnimationStyleIndex].animationStyle)
        }
        self.tableView.reloadData()
    }
    func tableViewCellValue(selectViewController: SelectViewController, obj: Any) -> (text: String, isCheckmark: Bool) {
        if selectViewController.tag == 0 {
            let animationShowStyle = obj as! (text: String, animationShowStyle: ZKProgressHUDAnimationShowStyle)
            return (text: animationShowStyle.text, isCheckmark: animationShowStyle.text == self.animationShowStyles[self.currentAnimationShowStyleIndex].text)
        } else if selectViewController.tag == 1 {
            let maskStyle = obj as! (text: String, maskStyle: ZKProgressHUDMaskStyle)
            return (text: maskStyle.text, isCheckmark: maskStyle.text == self.maskStyles[self.currentMaskStyleIndex].text)
        } else {
            let animationStyle = obj as! (text: String, animationStyle: ZKProgressHUDAnimationStyle)
            return (text: animationStyle.text, isCheckmark: animationStyle.text == self.animationStyles[self.currentAnimationStyleIndex].text)
        }
    }
}


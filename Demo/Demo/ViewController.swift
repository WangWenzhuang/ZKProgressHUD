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
    
    lazy var actionTexts = ["show", "show with status", "showProgress", "shwoImage", "showImage with status", "showInfo", "showSuccess", "showError", "showMessage"]
    lazy var headerTexts = ["MaskStyle", "AnimationStyle", "actions"]
    
    var progressValue: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ZKProgressHUD"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        }
        return self.actionTexts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier)
        if indexPath.section == 0 {
            cell?.textLabel?.text = "visible"
        } else if indexPath.section == 1 {
            cell?.textLabel?.text = "circle"
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
            
        } else if indexPath.section == 1 {
            
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                ZKProgressHUD.show()
                ZKProgressHUD.hide(delay: 3)
            } else if indexPath.row == 1 {
                ZKProgressHUD.show("loading...")
                ZKProgressHUD.hide(delay: 3)
            } else if indexPath.row == 2 {
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.timerHandler(timer:)), userInfo: nil, repeats: true)
            } else if indexPath.row == 3 {
                ZKProgressHUD.showImage(UIImage(named: "image"))
            } else if indexPath.row == 4 {
                ZKProgressHUD.showImage(image: UIImage(named: "image"), status: "Hello world")
            } else if indexPath.row == 5 {
                ZKProgressHUD.showInfo("Hello world")
            } else if indexPath.row == 6 {
                ZKProgressHUD.showSuccess("Hello world")
            } else if indexPath.row == 7 {
                ZKProgressHUD.showError("Hello world")
            } else if indexPath.row == 8 {
                ZKProgressHUD.showMessage("Hello world")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headerTexts[section]
    }
    
    func timerHandler(timer: Timer) {
        if self.progressValue > 100 {
            if timer.isValid {
                timer.invalidate()
            }
            ZKProgressHUD.hide()
            self.progressValue = 0
        } else {
            self.progressValue += 1
            ZKProgressHUD.showProgress(self.progressValue / 100)
        }
    }

}


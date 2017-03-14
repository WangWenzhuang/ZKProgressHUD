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
    
    lazy var actionTexts = ["loading", "loading and status", "message", "image", "image and status", "info", "success", "error"]
    lazy var headerTexts = ["MaskStyle", "AnimationStyle", "actions"]
    
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
                ZKProgressHUD.loading()
                ZKProgressHUD.hide(delay: 3)
            } else if indexPath.row == 1 {
                ZKProgressHUD.loading("loading...")
                ZKProgressHUD.hide(delay: 3)
            } else if indexPath.row == 2 {
                ZKProgressHUD.message("Hello World")
            } else if indexPath.row == 3 {
                ZKProgressHUD.image(UIImage(named: "image")!)
            } else if indexPath.row == 4 {
                ZKProgressHUD.image(UIImage(named: "image")!, status: "Hello World")
            } else if indexPath.row == 5 {
                ZKProgressHUD.showInfo("Hello World")
            } else if indexPath.row == 6 {
                ZKProgressHUD.image(UIImage(named: "image")!, status: "Hello World")
                ZKProgressHUD.showSuccess("Hello World")
            } else if indexPath.row == 7 {
                ZKProgressHUD.image(UIImage(named: "image")!, status: "Hello World")
                ZKProgressHUD.showError("Hello World")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headerTexts[section]
    }
}


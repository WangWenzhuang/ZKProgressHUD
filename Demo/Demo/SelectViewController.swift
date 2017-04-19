//
//  SelectViewController.swift
//  Demo
//
//  Created by 王文壮 on 2017/4/19.
//  Copyright © 2017年 WangWenzhuang. All rights reserved.
//

import UIKit

protocol SelectViewControllerDelegate {
    func selected(selectViewController: SelectViewController, selectIndex: Int)
    func tableViewCellValue(selectViewController: SelectViewController, obj: Any) -> (text : String, isCheckmark : Bool)
}

class SelectViewController: UITableViewController {
    let cellIdentifier = "cell"
    var data: [Any]!
    var delegate: SelectViewControllerDelegate?
    var tag: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier)
        cell?.textLabel?.text = "未实现 SelectViewControllerDelegate"
        guard (self.delegate != nil) else {
            return cell!
        }
        let cellValue = self.delegate?.tableViewCellValue(selectViewController: self, obj: data[indexPath.row])
        cell?.textLabel?.text = cellValue?.text
        if (cellValue?.isCheckmark)! {
            cell?.accessoryType = .checkmark
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard (self.delegate != nil) else {
            return
        }
        self.delegate?.selected(selectViewController: self, selectIndex: indexPath.row)
        _ = self.navigationController?.popViewController(animated: true)
    }
}

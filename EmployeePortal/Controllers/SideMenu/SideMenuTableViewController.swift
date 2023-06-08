//
//  SideMenuTableViewController.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/22/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit

protocol SideMenuNavigatable {
    func controller<T: UIViewController>() -> T?
}

class SideMenuTableViewController: UITableViewController {

    private let menuOptionCellId = "Cell"
    var selectedMenuItem : Int = 0
    
    var customFooterView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsets(top: 64.0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        clearsSelectionOnViewWillAppear = false
        
        // Preselect a menu option
        tableView.selectRow(at: IndexPath(row: selectedMenuItem, section: 0), animated: false, scrollPosition: .middle)
        setupFooterView()
        tableView.tableFooterView = customFooterView
        
        NotificationCenter.default.addObserver(self, selector: #selector(flushOutData), name: Notification.Name(rawValue: "SessionTokenExpired"), object: nil)
        
    }
    
    
    func setupFooterView() {
        customFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
        let button = UIButton(frame: CGRect(x: 45, y: 0, width: 200, height: 150))
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(logOutButtonAction), for: .touchUpInside)
        customFooterView?.addSubview(button)
    }
    
    @objc func logOutButtonAction(_ sender: UIButton!) {
        flushOutData()
        Employee.logout(userId: Employee.cached().id) { _ in}
    }
    
    @objc func flushOutData() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "SessionTokenExpired"), object: nil)
        ServiceManager.shared.token = nil
        UserDefaults.standard.set(nil, forKey: "LoginToken")
        UserDefaults.standard.set(nil, forKey: "CachedImageData")
        DispatchQueue.main.async { [weak self] in
            self?.view.endEditing(true)
            if !(UIViewController.topMostViewController() is DashboardViewController) {
               self?.sideMenuController()?.setContentViewController(DashboardViewController())
            }
            self?.sideMenuController()?.setContentViewController(LoginViewController())
        }

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ClassType.sideMenuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: menuOptionCellId)
        
        if (cell == nil) {
            cell = UITableViewCell(style:.default, reuseIdentifier: menuOptionCellId)
            cell!.backgroundColor = .clear
            cell?.selectionStyle = .none
            cell!.textLabel?.textColor = .darkGray
            cell?.indentationLevel = 3
            let selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell!.frame.size.width, height: cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        
        cell!.textLabel?.text = ClassType.sideMenuItems[indexPath.row].sideMenuTitle//"ViewController #\(indexPath.row+1)"
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {        
        let extraButtonSpace = UIView()
           extraButtonSpace.backgroundColor = .clear
           return extraButtonSpace
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

         let tableViewHeight = tableView.bounds.size.height
         let varticalMargin: CGFloat
         if #available(iOS 11.0, *) {
             varticalMargin = tableView.directionalLayoutMargins.bottom + tableView.directionalLayoutMargins.top
         } else {
             varticalMargin = tableView.layoutMargins.bottom + tableView.layoutMargins.top
         }

         let verticalInset: CGFloat
         if #available(iOS 11.0, *) {
             verticalInset = tableView.adjustedContentInset.bottom + tableView.adjustedContentInset.top
         } else {
             verticalInset = tableView.contentInset.bottom + tableView.contentInset.top
         }
         let tableViewContentHeight = tableView.contentSize.height - varticalMargin


         let height: CGFloat
         if #available(iOS 11.0, *) {
             let verticalSafeAreaInset = tableView.safeAreaInsets.bottom + tableView.safeAreaInsets.top
             height = tableViewHeight - tableViewContentHeight - verticalInset - verticalSafeAreaInset
         } else {
             height = tableViewHeight - tableViewContentHeight - verticalInset
         }

         if (height < 0) {
             return 0
         } else {
             return height
         }
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("did select row: \(indexPath.row)")
        
//        if (indexPath.row == selectedMenuItem) {
//            return
//        }
        
        selectedMenuItem = indexPath.row
        
        guard let destViewController = ClassType.sideMenuItems[indexPath.row].controller() else { return }
        sideMenuController()?.setContentViewController(destViewController)
    }

}

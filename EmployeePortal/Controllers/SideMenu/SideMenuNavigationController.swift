//
//  SideMenuNavigationController.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/22/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit

class SideMenuNavigationController: ENSideMenuNavigationController {

    lazy var blurView = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a table view controller
        let tableViewController = SideMenuTableViewController()

        // Create side menu
        sideMenu = ENSideMenu(sourceView: view, menuViewController: tableViewController, menuPosition:.left)
        
        // Set a delegate
        sideMenu?.delegate = self
        
        // Configure side menu
        sideMenu?.menuWidth = 300.0
        
        // Show navigation bar above side menu
        view.bringSubviewToFront(navigationBar)
        
    }
}

extension SideMenuNavigationController: ENSideMenuDelegate {
    public func sideMenuWillOpen() {
        blurView.setTitle("", for: .normal)
        
        // tap blur view to toggle side menu
        blurView.addTarget(self, action: #selector(toggleSideMenu), for: .touchUpInside)

        // add background black view
        blurView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
        viewControllers.last?.view.addSubview(blurView)
        blurView.fillInSuperView()
    }
    
    public func sideMenuWillClose() {
        // remove background black view
        blurView.removeFromSuperview()
    }
    
    @objc public func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
    
    public func sideMenuDidOpen() {
        print("sideMenuDidOpen")

    }
    
    public func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
}


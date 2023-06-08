//
//  NavigationBarOptions.swift
//  EmployeePortal
//
//  Created by sajeev Raj on 1/11/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import UIKit

enum NavigationLeftItem {
   case menu
   case back
}

protocol NavigationBarOptions {
    var shouldHideMenuOption: Bool { get }
    
    var shouldShowBackButton: Bool { get }
    
    var isFormEditable: Bool { get }
    
    func addNavigationButton(option: NavigationLeftItem)
}

extension NavigationBarOptions where Self: UIViewController {
    
    var shouldHideMenuOption: Bool {
        return false
    }
    
    var shouldShowBackButton: Bool {
        return false
    }
    
    var isFormEditable: Bool {
        return true
    }
    
    func addNavigationButton(option: NavigationLeftItem) {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        switch option {
        case .back:
            button.setImage(UIImage(named: "backArrow"), for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            button.contentHorizontalAlignment = .left
            button.addTarget(self, action:#selector(backAction), for: .touchUpInside)
        case .menu :
            button.setImage(UIImage(named: "menuIcon"), for: .normal)
            button.addTarget(self, action:#selector(toggleSideMenu), for: .touchUpInside)
        }
        let barButton = UIBarButtonItem(customView: button)
        
        // set bar buttons
        var barButtons = self.navigationItem.leftBarButtonItems ?? []
        barButtons.append(barButton)
        self.navigationItem.leftBarButtonItems = barButtons
    }
    
    func addNavigationLockButton() {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.setImage(UIImage(named: "lock"), for: .normal)
        button.addTarget(self, action:#selector(toggleSideMenu), for: .touchUpInside)

        let barButton = UIBarButtonItem(customView: button)
        
        // set bar buttons
        var barButtons = self.navigationItem.rightBarButtonItems ?? []
        barButtons.append(barButton)
        self.navigationItem.rightBarButtonItems = barButtons
    }
}

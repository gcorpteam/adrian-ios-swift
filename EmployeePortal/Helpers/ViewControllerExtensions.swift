//
//  ViewControllerExtensions.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/20/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import Foundation
import UIKit

protocol Navigatable where Self: UIViewController {
    static func show()
}

extension Navigatable {
    
    static func topMostViewController() -> UIViewController {
        var topViewController: UIViewController? = UIApplication.shared.windows.first?.rootViewController
        while ((topViewController?.presentedViewController) != nil) {
            topViewController = topViewController?.presentedViewController
        }
        return topViewController!
    }
}

extension UIViewController: Navigatable {
    static func show() {
        let viewcontroller = Self()
        if let navigation = topMostViewController() as? UINavigationController {
            navigation.pushViewController(viewcontroller, animated: true)
            return
        }
        DispatchQueue.main.async {
            topMostViewController().navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
}

extension UIViewController {
    @objc func toggleSideMenu() {
       toggleSideMenuView()
    }
    
    @objc func backAction() {
        if navigationController?.viewControllers.count ?? 0 > 1 {
            navigationController?.popViewController(animated: true)
        } else {
            navigationController?.setViewControllers([DashboardViewController()], animated: false)
        }
    }
    
    func goToDashboard() {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.setViewControllers([DashboardViewController()], animated: true)
        }
    }
}

//
//  LoginViewController.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/9/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class LoginViewController: BaseFormViewController {
    
    override var shouldHideMenuOption: Bool {
        return true
    }
    
    override var shouldShowBackButton: Bool {
        return false
    }
    
    var isRemembered: Bool {
        return UserDefaults.standard.bool(forKey: "RememberMe")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfRememberedMe()

    }
    
    func checkIfRememberedMe() {
        guard let token = UserDefaults.standard.value(forKey: "LoginToken") as? String,
            UserDefaults.standard.bool(forKey: "RememberMe") else { return }
        ServiceManager.shared.token = token
        navigationController?.pushViewController(DashboardViewController(), animated: false)
    }
    
    override func createForm() {
        form +++ Section("")
            <<< LoginHeaderRow("Row1") { row in
            
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
        
            <<< BasicTextRow(RowIdentifier.username) { row in
                row.add(rule: RuleRequired())
//                #if DEBUGA
//                row.rowValue = "AppTest1@elcom.com.au"
//                #endif
                row.placeholder = "Username"
                
                if isRemembered, let username = UserDefaults.standard.value(forKey: "Username") as? String {
                    row.rowValue = username
                }
                
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
        
            <<< BasicTextRow(RowIdentifier.password) { row in
                row.add(rule: RuleRequired())
                row.isSecureText = true
//                #if DEBUG
//                row.rowValue = "y7N2EL"
//                #endif
                row.placeholder = "Password"
                
                if isRemembered, let password = UserDefaults.standard.value(forKey: "Password") as? String {
                    row.rowValue = password
                }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
        
            <<< RememberMeRow("Row4") { row in
                row.value = isRemembered
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
        
            <<< SubmitButtonRow("Row5") { row in
                row.actionHandler = { [weak self] in
                    self?.navigateToDashboard()
                }
            }
        
            <<< ForgotPasswordButtonRow("Row6") { row in
                row.actionHandler = { [weak self] in
                    self?.navigateToForgotPassword()
                }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
        
            <<< BottomFooterViewRow("Row7") { row in
                row.imageName = "logo_powered_by"
                
                row.cell.height = {
                    return 100
                }
                
                row.actionHandler = {
                    if let url = URL(string: Configuration.current.websiteUrl) {
                        UIApplication.shared.open(url)
                    }
                }
        }
    }
    
    private func navigateToForgotPassword() {
        if let url = URL(string: Configuration.current.forgotPasswordURL) {
            UIApplication.shared.open(url)
        }
    }

    private func navigateToDashboard() {
        let usernameRow: BasicTextRow? = row(tag: RowIdentifier.username)
        let passwordRow: BasicTextRow? = row(tag: RowIdentifier.password)
        let rememberRow: RememberMeRow? = row(tag: "Row4")

        let employee = Employee()
        employee.username = usernameRow?.value ?? ""
        employee.password = passwordRow?.value ?? ""
        
        showLoader()
        
        Employee.authenticate(employee: employee) { [weak self] (response) in
            switch response {
            case .success(_):
                self?.login(employee: employee, isRemembered: rememberRow?.value ?? false)
            case .failure(let error):
                AlertController.show(type: .serviceError, error: error, successHandler: nil, cancelHandler: nil)
            case .finally:
                self?.hideLoader()
            }
        }
    }
    
    func login(employee: Employee, isRemembered: Bool) {
        showLoader()
        Employee.login(employee: employee) { [weak self] (response) in
            switch response {
            case .success(let data):
                print(data)
                
                self?.handleRememberMeData(isRemembered: isRemembered, username: employee.username, password: employee.password)
                
                // save data to DB
                data.save()
                
                self?.showDashboard()
            case .failure(let error):
                AlertController.show(type: .serviceError, error: error, successHandler: nil, cancelHandler: nil)
            case .finally:
                self?.hideLoader()
            }
        }
    }
    
    func handleRememberMeData(isRemembered: Bool, username: String, password: String) {
        UserDefaults.standard.set(isRemembered, forKey: "RememberMe")
        UserDefaults.standard.set(nil, forKey: "CachedImageData")

        if isRemembered {
            UserDefaults.standard.set(ServiceManager.shared.token, forKey: "LoginToken")
            UserDefaults.standard.set(username, forKey: "Username")
            UserDefaults.standard.set(password, forKey: "Password")
        }
        else {
            UserDefaults.standard.set(nil, forKey: "LoginToken")
            UserDefaults.standard.set(nil, forKey: "Username")
            UserDefaults.standard.set(nil, forKey: "Password")
        }
    }
    
    private func showDashboard() {
        DispatchQueue.main.async {
            DashboardViewController.show()
        }
    }
}

extension LoginViewController {
    func validateForm() {
        if form.validate().count == 0 {
            
        }
    }
}

extension LoginViewController {
    struct RowIdentifier {
        static let username = "username"
        static let password = "password"
    }
}

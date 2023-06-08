//
//  UpdatePasswordViewController.swift
//  EmployeePortal
//
//  Created by Sajeev on 2/7/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class UpdatePasswordViewController: BaseFormViewController {
    override var shouldHideMenuOption: Bool {
        return true
    }
    
    override var shouldShowBackButton: Bool {
        return true
    }
    
     override func createForm() {
        form +++ Section("")
            
            <<< BasicTextRow(UpdatePasswordViewController.Keys.oldPassword) { row in
                row.placeholder = "Old password"
                row.add(rule: RuleRequired())
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow(UpdatePasswordViewController.Keys.newPassword) { row in
                row.placeholder = "New password"
                row.add(rule: RuleRequired())
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow(UpdatePasswordViewController.Keys.confirmpassword) { [weak self] row in
                guard let welf = self else { return }
                row.add(rule: RuleRequired())
                row.add(rule: RuleEqualsToRow(form: welf.form, tag: UpdatePasswordViewController.Keys.newPassword))
                row.placeholder = "Confirm your password"
            }
        
            <<< EmptyRow() { $0.cell.height = {22} }
        
            <<< SubmitButtonRow("Row4") { row in
                row.name = "Update"

                row.actionHandler = { [weak self] in
                    self?.update()
                }
            }
    }
    
    private func update() {
        let oldPassword = row(tag: UpdatePasswordViewController.Keys.oldPassword) ?? ""
        let newPassword = row(tag: UpdatePasswordViewController.Keys.newPassword) ?? ""

        showLoader()
        Employee.updatePassword(userId: "", oldPass: oldPassword, newPass: newPassword) { [weak self] (response) in
            switch response {
            case .success(_):
                return
            case .failure(let error):
                AlertController.show(type: .serviceError, error: error)
            case .finally:
                self?.hideLoader()
            }
        }
    }
}

extension UpdatePasswordViewController {
    struct Keys {
        static let oldPassword = "oldPassword"
        static let newPassword = "newPassword"
        static let confirmpassword = "confirmpassword"
    }
}


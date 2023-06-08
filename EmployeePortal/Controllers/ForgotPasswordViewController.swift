//
//  ForgotPasswordViewController.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/16/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class ForgotPasswordViewController: BaseFormViewController {
    
     override var shouldHideMenuOption: Bool {
         return true
     }
     
     override var shouldShowBackButton: Bool {
         return true
     }
    
    override func createForm() {
        form +++ Section("")
            
            <<< EmptyRow() { $0.cell.height = {40} }
            
            <<< BasicTextRow("Row2") { row in
                row.placeholder = "Your email"
            }
            
            <<< EmptyRow() { $0.cell.height = {30} }
            
            <<< SubmitButtonRow("Row5") { row in
                row.name = "Send"
                row.actionHandler = { [weak self] in}
        }
    }
}

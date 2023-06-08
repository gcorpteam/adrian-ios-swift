//
//  ContactHRViewController.swift
//  EmployeePortal
//
//  Created by Sajeev on 2/7/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class ContactHRViewController: BaseFormViewController {
    
    override func createForm() {
        form +++ Section("")
        
        <<< LabelRow() { row in
            row.cell.textLabel?.numberOfLines = 0
            row.title = " General Enquiries \n\n Call 1300 659 563 \n\n HR & Employment Law Advice Call 1300 781299 between 9am and 5pm (AEST) on any business day. \n\n HR TEAM - Bob Smith, HR Manager, Phone 123, Email: xyz, PAYROLL TEAM: Adrian White, Payroll Coordinator"
        }
        
    }
    
}

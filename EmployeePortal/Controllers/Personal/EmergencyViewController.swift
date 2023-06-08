//
//  EmergencyViewController.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/20/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class EmergencyViewController: BaseFormViewController {
    override var shouldHideMenuOption: Bool {
        return true
    }
    
    override var shouldShowBackButton: Bool {
        return true
    }
    
    var emergencyContact: EmergencyContact? {
        return Employee.cached().emergencyContact
    }
    
    override func createForm() {
        form +++ Section("")
            
            <<< BasicTextRow(EmergencyViewController.Keys.name) { row in
                if let fullName = emergencyContact?.fullName {
                    row.rowValue = fullName
                }
                row.placeholder = "Name"
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow(EmergencyViewController.Keys.number) { row in
                row.keyboardType = .phonePad
                row.placeholder = "Contact  number"
                if let phone = emergencyContact?.contactNumber {
                    row.rowValue = phone
                }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow(EmergencyViewController.Keys.relationship) { row in
                row.placeholder = "Relationship"
                if let relation = emergencyContact?.relation {
                      row.rowValue = relation
                  }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow(EmergencyViewController.Keys.condition) { row in
                row.placeholder = "Disclosed medical condition"
                
                if let condition = emergencyContact?.disclosedMedicalCondition {
                      row.rowValue = condition
                  }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
        
            <<< SubmitButtonRow("Row5") { row in
                row.name = "Update"
                row.actionHandler = { [weak self] in
                    self?.handleValidation()
                }
        }
    }
    
    override func handleValidationSuccess() {
        updateDetails()
    }
    
    private func updateDetails() {
        
        let firstNameRow: BasicTextRow? = row(tag: EmergencyViewController.Keys.name)
        let disclosedMedicalConditionRow: BasicTextRow? = row(tag: EmergencyViewController.Keys.condition)
        let phoneNumberRow: BasicTextRow? = row(tag: EmergencyViewController.Keys.number)
        let relationRow: BasicTextRow? = row(tag: EmergencyViewController.Keys.relationship)
        
       let contact = EmergencyContact()
        contact.fullName = firstNameRow?.value ?? ""
        contact.contactNumber = phoneNumberRow?.value ?? ""
        contact.relation = relationRow?.value ?? ""
        contact.disclosedMedicalCondition = disclosedMedicalConditionRow?.value ?? ""
        
        showLoader()
        contact.update { [weak self] (response) in
            switch response {
            case .success(_):
                DispatchQueue.main.async {
                    Employee.cached().emergencyContact?.update(updateHandler: { (emergencyContact) in
                        emergencyContact.fullName = contact.fullName
                        emergencyContact.contactNumber = contact.contactNumber
                        emergencyContact.relation = contact.relation
                        emergencyContact.disclosedMedicalCondition = contact.disclosedMedicalCondition
                    })
                    AlertController.show(type: .dataSubmit, error: nil, successHandler: {
                        self?.goToDashboard()
                    }, cancelHandler: nil)
                }
            case .failure(let error):
                AlertController.show(type: .serviceError, error: error)
            case .finally:
                self?.hideLoader()
            }
        }
    }
}

extension EmergencyViewController {
    struct Keys {
        static let name = "name"
        static let number = "number"
        static let relationship = "relationship"
        static let condition = "condition"
    }
}

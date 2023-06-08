//
//  ContactDetailsViewController.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/20/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

enum ContactKeys: String {
    case salutation
    case firstName
    case lastName
    case phone
    case mobile
    case email
    case street
    case suburb
    case postcode
}

class ContactDetailsViewController: BaseFormViewController {
    
    override var shouldHideMenuOption: Bool {
        return true
    }
    
    override var shouldShowBackButton: Bool {
        return true
    }
    
    var contact: Contact? {
        return Employee.cached().contact
    }
    
    override func createForm() {
        form +++ Section("")
            
            <<< BasicTextRow(ContactKeys.salutation.rawValue) { row in
                row.isMandatory = true
                row.placeholder = "Salutation"
                row.add(rule: RuleRequired(msg: "Please enter Salutation"))
                if let salutation = contact?.salutation {
                    row.rowValue = salutation
                }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow(ContactKeys.firstName.rawValue) { row in
                row.isMandatory = true
                
                row.placeholder = "First Name"
                row.add(rule: RuleRequired(msg: "Please enter First Name"))
                if let firstName = contact?.firstName {
                    row.rowValue = firstName
                }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow(ContactKeys.lastName.rawValue) { row in
                row.isMandatory = true
                
                row.placeholder = "Last Name"
                row.add(rule: RuleRequired(msg: "Please enter Last Name"))
                
                if let lastName = contact?.lastName {
                    row.rowValue = lastName
                }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow(ContactKeys.phone.rawValue) { row in
                row.placeholder = "Phone Number"
                row.keyboardType = .numberPad
                if let phoneNumber = contact?.phoneNumber {
                    row.rowValue = phoneNumber
                }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow(ContactKeys.mobile.rawValue) { row in
                row.placeholder = "Mobile Number"
                row.keyboardType = .numberPad
                
                if let mobileNumber = contact?.mobileNumber {
                    row.rowValue = mobileNumber
                }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow(ContactKeys.email.rawValue) { row in
                row.isNonEditable = true
                row.placeholder = "Email"
                if let email = contact?.email {
                    row.rowValue = email
                }
            }
            
            <<< SectionHeaderViewRow() { row in
                
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow(ContactKeys.street.rawValue) { row in
                row.placeholder = "Street Address"
                if let street = contact?.physicalAddress?.street {
                    row.rowValue = street
                }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow(ContactKeys.suburb.rawValue) { row in
                row.placeholder = "Suburb"
                if let suburb = contact?.physicalAddress?.suburb {
                    row.rowValue = suburb
                }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow(ContactKeys.postcode.rawValue) { row in
                row.keyboardType = .numberPad
                
                row.placeholder = "Postcode"
                if let postcode = contact?.physicalAddress?.postcode {
                    row.rowValue = postcode
                }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< SubmitButtonRow("Row10") { row in
                row.name = "Update"
                
                row.actionHandler = { [weak self] in
                    self?.handleValidation()
                }
        }
    }
    
    override func handleValidationSuccess() {
        submitContactDetails()
    }
    
    private func submitContactDetails() {
        
        let salutationRow: BasicTextRow?    = row(tag: ContactKeys.salutation.rawValue)
        let firstNameRow: BasicTextRow?     = row(tag: ContactKeys.firstName.rawValue)
        let lastNameRow: BasicTextRow?      = row(tag: ContactKeys.lastName.rawValue)
        let phoneNumberRow: BasicTextRow?   = row(tag: ContactKeys.phone.rawValue)
        let mobileNumberRow: BasicTextRow?  = row(tag: ContactKeys.mobile.rawValue)
        let emailRow: BasicTextRow?         = row(tag: ContactKeys.email.rawValue)
        let streetRow: BasicTextRow?        = row(tag: ContactKeys.street.rawValue)
        let suburbRow: BasicTextRow?        = row(tag: ContactKeys.suburb.rawValue)
        let postcodeRow: BasicTextRow?      = row(tag: ContactKeys.postcode.rawValue)
        
        let updatedContact = Contact()
        updatedContact.salutation               = salutationRow?.value ?? ""
        updatedContact.firstName                = firstNameRow?.value ?? ""
        updatedContact.lastName                 = lastNameRow?.value ?? ""
        updatedContact.phoneNumber              = phoneNumberRow?.value ?? ""
        updatedContact.mobileNumber             = mobileNumberRow?.value ?? ""
        updatedContact.email                    = emailRow?.value ?? ""
        updatedContact.physicalAddress = PhysicalAddress()
        updatedContact.physicalAddress?.street  = streetRow?.value ?? ""
        updatedContact.physicalAddress?.suburb  = suburbRow?.value ?? ""
        updatedContact.physicalAddress?.postcode = postcodeRow?.value ?? ""
        
        showLoader()
        updatedContact.update {[weak self] (response) in
            switch response {
            case .success(_):
                DispatchQueue.main.async {
                    Employee.cached().contact?.update(updateHandler: { (newContact) in
                        newContact.salutation = updatedContact.salutation
                        newContact.firstName = updatedContact.firstName
                        newContact.lastName = updatedContact.lastName
                        newContact.phoneNumber = updatedContact.phoneNumber
                        newContact.mobileNumber = updatedContact.mobileNumber
                        newContact.email = updatedContact.email
                        newContact.physicalAddress?.street = updatedContact.physicalAddress?.street ?? ""
                        newContact.physicalAddress?.suburb = updatedContact.physicalAddress?.suburb ?? ""
                        newContact.physicalAddress?.postcode = updatedContact.physicalAddress?.postcode ?? ""
                    })
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateProfile"), object: nil)
                }
                AlertController.show(type: .dataSubmit, error: nil, successHandler: {
                    self?.goToDashboard()
                }, cancelHandler: nil)
            case .failure(let error):
                AlertController.show(type: .serviceError, error: error)
            case .finally:
            self?.hideLoader()
        }
    }
}
}



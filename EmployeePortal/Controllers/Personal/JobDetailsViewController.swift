//
//  JobDetailsViewController.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/22/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class JobDetailsViewController: BaseFormViewController {
    override var shouldHideMenuOption: Bool {
        return true
    }
    
    override var shouldShowBackButton: Bool {
        return true
    }
    
    override var isFormEditable: Bool {
        return false
    }
    
    var job: Job? {
        return Employee.cached().jobdetail
    }

    override func createForm() {
        form +++ Section("")
            
//            <<< ProfilePhotoViewRow("Row0") { [weak self] row in
//
//                row.actionHandler = {
//                    self?.showImagePicker()
//                }
//            }
            
//            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow("Row1") { row in
//                row.isMandatory = true
                row.placeholder = "Status"
                row.rowValue = job?.status ?? ""
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow("Row2") { row in
//                row.isMandatory = true
                row.placeholder = "Job Title"
                row.rowValue = job?.jobTitle

            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow("Row3") { row in
//                row.isMandatory = true
                row.placeholder = "Employment Type"
                row.rowValue = "Contract"
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow("Row4") { row in
                row.placeholder = "Name of Award"
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow("Row5") { row in
                row.placeholder = "Classification"
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow("Row6") { row in
                row.placeholder = "Name of Manager"
                row.rowValue = "Amy Samsung"

            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow("Row7") { row in
                row.placeholder = "Manager Job Title"
                row.rowValue = "Tewchnical Manager"

            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow("Row8") { row in
                row.placeholder = "Location"
                row.rowValue = "North Sydney"

            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow("Row9") { row in
                row.placeholder = "Team"
                row.rowValue = "Technical Team"

            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
    }
    
    func showImagePicker() {
        ImagePickerManager.shared.pickImage { [weak self] (imageAsset) in
            let photoRow = self?.form.allRows.filter{ $0.tag == "Row0" }.first
            guard let imageRow = photoRow as? ProfilePhotoViewRow else { return }
            imageRow.image = imageAsset?.image
        }
    }
}

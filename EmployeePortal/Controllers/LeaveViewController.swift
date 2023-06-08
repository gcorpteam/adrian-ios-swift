//
//  LeaveViewController.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/23/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class LeaveViewController: BaseFormViewController {
    
    override var shouldHideMenuOption: Bool {
        return true
    }
    
    override var shouldShowBackButton: Bool {
        return true
    }
    
    override func createForm() {
        form +++ Section("")
            
            <<< OptionsViewRow(LeaveViewController.Keys.options) { row in
                row.header = "Select a type"
                row.placeholder = "Leave Type"
                row.options = LookUp.leaveTypes.values()
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< DatePickerRow(LeaveViewController.Keys.fromDate) { row in
                row.isMandatory = true
                
                row.placeholder = "Date From"
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< DatePickerRow(LeaveViewController.Keys.toDate) { row in
                row.isMandatory = true
                
                row.placeholder = "Date To"
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow(LeaveViewController.Keys.totalHours) { row in
                row.placeholder = "Total Hours"
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< AttachRecordView(LeaveViewController.Keys.attachment) { [weak self] row in
                row.actionHandler = {
                    self?.getFile(completion: { (url) in
                        DispatchQueue.main.async {
                            row.file = File(url: url, name: url.lastPathComponent)
                        }
                    })
                }
                row.photoActionHandler = {
                    self?.getPhoto(completion: { (fileName) in
                        DispatchQueue.main.async {
                            row.fileName = fileName
                        }
                    })
                }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow(LeaveViewController.Keys.notes) { row in
                row.placeholder = "Notes"
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< SubmitButtonRow("Row7") { row in
                row.name = "Submit"
                row.actionHandler = { [weak self] in
                    self?.submit()
                }
        }
    }
    
    func getFile(completion: @escaping (URL) -> Void) {
        FileBrowserManager.shared.pickFile(viewController: self) { (url) in
            completion(url)
        }
    }
    
    func getPhoto(completion: @escaping (String) -> Void) {
        ImagePickerManager.shared.pickImage(type: .camera) { (imageAsset) in
            completion(imageAsset?.fileName ?? "")
        }
    }
    
    private func submit() {
        let optionsRow: OptionsViewRow? = row(tag: LeaveViewController.Keys.options)
        let fromDateRow: DatePickerRow? = row(tag: LeaveViewController.Keys.fromDate)
        let toDateRow: DatePickerRow? = row(tag: LeaveViewController.Keys.toDate)
        let totalHoursRow: BasicTextRow? = row(tag: LeaveViewController.Keys.totalHours)
        let attachmentRow: AttachRecordView? = row(tag: LeaveViewController.Keys.attachment)
        let notesRow: BasicTextRow? = row(tag: LeaveViewController.Keys.notes)

        let options = optionsRow?.value ?? ""
        let fromDate = fromDateRow?.value ?? ""
        let toDate = toDateRow?.value ?? ""
        let totalHours = totalHoursRow?.value ?? ""
        let notes = notesRow?.value ?? ""
        var attachment = ""
        var fileName = ""
        
        if let from = fromDate.date(of: .yyyyMMddhhmmss), let to = toDate.date(of: .yyyyMMddhhmmss) {
            if from.isGreater(date: to) {
                AlertController.show(type: .inCorrectDate)
                return
            }
        }
                
        if let url = attachmentRow?.file?.url, let data = try? Data(contentsOf: url).compress() {
            fileName = url.lastPathComponent
            attachment = data.base64EncodedString()
        }
        var leaveTypeId = ""
        if let id = LookUp.getId(type: .leave, name: options) {
            leaveTypeId = String(id)
        }
        
        showLoader()
        Employee.submitLeave(fileName: fileName, leaveType: options, leaveTypeID: leaveTypeId, dateFrom: fromDate, dateTo: toDate, totalHours: totalHours, notes: notes, attachment: attachment) { [weak self] (response) in
            switch response {
            case .success(_):
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

extension LeaveViewController {
    struct Keys {
        static let options = "options"
        static let fromDate = "fromDate"
        static let toDate = "toDate"
        static let totalHours = "totalHours"
        static let notes = "notes"
        static let attachment = "attachment"
    }
}

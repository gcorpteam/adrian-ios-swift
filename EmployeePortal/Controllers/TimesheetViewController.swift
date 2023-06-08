//
//  TimesheetViewController.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/23/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class TimesheetViewController: BaseFormViewController {
    
    override var shouldHideMenuOption: Bool {
        return true
    }
    
    override var shouldShowBackButton: Bool {
        return true
    }
    
    var timesheet: TimeSheet?
    
    override func createForm() {
        form +++ Section("")
            
            <<< DatePickerRow(TimesheetViewController.Keys.dateWorked) { row in
                row.isMandatory = true
                
                row.placeholder = "Date Worked"
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< TimePickerRow(TimesheetViewController.Keys.startTime) { row in
                row.isMandatory = true
                
                row.placeholder = "Start Time"
                
                row.actionHandler = { [weak self] in
                    self?.updateTimeWorked()
                }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< TimePickerRow(TimesheetViewController.Keys.endTime) { row in
                row.isMandatory = true
                
                row.placeholder = "End Time"
                
                row.actionHandler = { [weak self] in
                    self?.updateTimeWorked()
                }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow(TimesheetViewController.Keys.breakTime) { row in
                row.keyboardType = .numberPad
                row.placeholder = "Break Time"
                row.cell.basicTextField?.placeholder = "Minutes"
                row.actionHandler = { [weak self] in
                    self?.updateTimeWorked()
                }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow(TimesheetViewController.Keys.timeWorked) { row in
                row.keyboardType = .numberPad
                row.disabled = true
                row.placeholder = "Time Worked"
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< OptionsViewRow(TimesheetViewController.Keys.hourType) { row in
                row.header = "Select a type"
                row.placeholder = "Type of hours"
                row.options = LookUp.timesheetTypes.values()
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow(TimesheetViewController.Keys.notes) { row in
                row.placeholder = "Notes"
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< SubmitButtonRow("Row10") { row in
                row.name = "Submit"
                row.actionHandler = { [weak self] in
                    self?.handleValidation()
                }
        }
    }
    
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    override func handleValidationSuccess() {
        update()
    }
    
    func updateTimeWorked() {
        let startTimeRow: TimePickerRow?   = row(tag: TimesheetViewController.Keys.startTime)
        let endTimeRow: TimePickerRow?     = row(tag: TimesheetViewController.Keys.endTime)

        let startTime = startTimeRow?.value?.date(of: .yyyyMMddhhmmss)
        let endTime = endTimeRow?.value?.date(of: .yyyyMMddhhmmss)
        
        guard let start = startTime, let end = endTime else { return }
        
        var differenceMinutes = end.minutes(from: start)
        
        var hourAndMinutes = minutesToHoursMinutes(minutes: differenceMinutes)

        let breakTimeRow: BasicTextRow?   = row(tag: TimesheetViewController.Keys.breakTime)
        let timeWorkedRow: BasicTextRow?  = row(tag: TimesheetViewController.Keys.timeWorked)

        if let breakTime = breakTimeRow?.value, let breakValue = Float(breakTime) {
            let value = Float(hourAndMinutes.hours) - (breakValue/100)
            timeWorkedRow?.rowValue = "\(value)"
        }
        else {
            timeWorkedRow?.rowValue = "\(Float(hourAndMinutes.hours))"
        }
        
        if let breakTime = breakTimeRow?.value {
            differenceMinutes -= Int(breakTime) ?? 0
        }
        
        // updated hour and minutes
        hourAndMinutes = minutesToHoursMinutes(minutes: differenceMinutes)
        
        var text = "\(hourAndMinutes.hours)" + " hours"
        if hourAndMinutes.leftMinutes > 0 {
            text += " \(hourAndMinutes.leftMinutes)" + " minutes"
        }
        
        timeWorkedRow?.cell.basicTextField?.text = text
    }
    
    private func update() {
        let dateWorkedRow: DatePickerRow?  = row(tag: TimesheetViewController.Keys.dateWorked)
        let startTimeRow: TimePickerRow?   = row(tag: TimesheetViewController.Keys.startTime)
        let endTimeRow: TimePickerRow?     = row(tag: TimesheetViewController.Keys.endTime)
        let breakTimeRow: BasicTextRow?   = row(tag: TimesheetViewController.Keys.breakTime)
        let timeWorkedRow: BasicTextRow?  = row(tag: TimesheetViewController.Keys.timeWorked)
        let hourTypeRow: OptionsViewRow?         = row(tag: TimesheetViewController.Keys.hourType)
        let notesRow: BasicTextRow?        = row(tag: TimesheetViewController.Keys.notes)
        
        let newTimesheet = TimeSheet()
        newTimesheet.dateWorked = dateWorkedRow?.value ?? ""
        newTimesheet.startTime = startTimeRow?.value ?? ""
        newTimesheet.endTime = endTimeRow?.value ?? ""
        newTimesheet.breakTime = breakTimeRow?.value ?? ""
        newTimesheet.timeWorked = timeWorkedRow?.value ?? ""
        newTimesheet.hourType = hourTypeRow?.value ?? ""
        newTimesheet.notes = notesRow?.value ?? ""
        
        showLoader()
        Employee.submitTimesheet(timesheet: newTimesheet) { [weak self] (response) in
            switch response {
            case .success(_):
                self?.timesheet = newTimesheet
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

extension TimesheetViewController {
    struct Keys {
        static let dateWorked = "dateWorked"
        static let startTime = "startTime"
        static let endTime = "endTime"
        static let breakTime = "breakTime"
        static let timeWorked = "timeWorked"
        static let hourType = "hourType"
        static let notes = "notes"
    }
}

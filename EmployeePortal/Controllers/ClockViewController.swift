//
//  ClockViewController.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/20/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class ClockViewController: BaseFormViewController {
    override var shouldHideMenuOption: Bool {
        return true
    }
    
    override var shouldShowBackButton: Bool {
        return true
    }
    
    var clockState: ClockState = .on
    
    override func createForm() {
        form +++ Section("")
            
            <<< ShiftTimeViewRow() { row in
            }
            
            <<< ClockOnTimeViewRow("time") { row in
            }
            
            <<< SubmitButtonRow("break") { row in
                // row.tag = "break"
                row.name = "Add Break time"
                row.color = ThemeManager.Color.green
                
                row.hidden = Condition.function([""], { [weak self] form in
                    let shouldHide = (self?.clockState == .on)
                    return shouldHide
                })
                
                row.actionHandler = { [weak self] in
                    self?.showBreakAlert()
                }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< SubmitButtonRow("clock") { [weak self] row in
                guard let welf = self else { return }
                let state = welf.clockState
                row.name = state.rawValue
                
                row.actionHandler = {
                    (welf.clockState == .on) ? self?.setClockStartTime() : self?.setClockStopTime()
                    welf.clockState = (welf.clockState == .on) ? .off : .on
                    row.name = welf.clockState.rawValue
                    let breakRow = welf.form.allRows.filter{ $0.tag == "break" }.first
                    breakRow?.evaluateHidden()
                }
        }
    }
    
    func setClockStartTime() {
        let clockTimeRow = form.allRows.filter{ $0.tag == "time" }.first
        guard let clockRow =  clockTimeRow as? ClockOnTimeViewRow else { return }
        clockRow.startTime = Date()
        
    }

    func setClockStopTime() {
        let clockTimeRow = form.allRows.filter{ $0.tag == "time" }.first
        guard let clockRow =  clockTimeRow as? ClockOnTimeViewRow else { return }
        clockRow.stopTime = Date()
    }
    
    func setBreakTime(time: String) {
        let clockTimeRow = form.allRows.filter{ $0.tag == "time" }.first
        guard let clockRow =  clockTimeRow as? ClockOnTimeViewRow else { return }
        clockRow.breakTime = Int(time)
    }
    
    func showBreakAlert(){
        let alertController = UIAlertController(title: "Add break time", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Time in minutes"
        }

        let saveAction = UIAlertAction(title: "Add", style: .default, handler: { [weak self] alert -> Void in
            if let textField = alertController.textFields?[0] {
                if textField.text!.count > 0 {
                    print("Text :: \(textField.text ?? "")")
                    self?.setBreakTime(time: textField.text ?? "")
                }
            }
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        alertController.preferredAction = saveAction

        self.present(alertController, animated: true, completion: nil)
    }
}

enum ClockState: String, CaseIterable {
    case on = "Clock On"
    case off = "Clock Off"
}

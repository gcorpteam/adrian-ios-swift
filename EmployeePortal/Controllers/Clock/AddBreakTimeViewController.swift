//
//  AddBreakTimeViewController.swift
//  EmployeePortal
//
//  Created by Sajeev on 2/8/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class AddBreakTimeViewController: BaseFormViewController {
    
    override var shouldHideMenuOption: Bool {
        return true
    }
    
    override var shouldShowBackButton: Bool {
        return false
    }
    
    var clock: Clock?
    
    override func createForm() {
        form +++ Section("")
            <<< BottomFooterViewRow("Row1") { row in
                row.imageName = "clockTime"
                
                row.cell.height = {
                    return 200
                }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< LabelRow() {
                
                $0.title = Date().toString("dd MMM YYYY")
                $0.cellStyle = .default
                
            }
            .cellUpdate({ (cell, row) in
                cell.textLabel?.textAlignment = .center
            })
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< LabelRow() {
                $0.title = "Add Break Time:"
                $0.cellStyle = .default
                
            }
            .cellUpdate({ (cell, row) in
                cell.textLabel?.textAlignment = .center
            })
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< ClockNoteViewRow("break") { row in
                row.placeholder = "Minutes"
                row.keyboardType = .numberPad
            }
            .cellUpdate({ (cell, row) in
                cell.textLabel?.textAlignment = .center
            })
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< ClockNoteViewRow("note") { row in
                row.placeholder = "Add Notes"
                row.keyboardType = .default
            }
            .cellUpdate({ (cell, row) in
                cell.textLabel?.textAlignment = .center
            })
            
            <<< EmptyRow() { $0.cell.height = {40} }
            
            <<< SubmitButtonRow("Row5") { row in
                row.name = "Next"
                row.actionHandler = { [weak self] in
                    self?.navigateToSummaryScreen()
                }
        }
    }
    
    private func navigateToSummaryScreen() {
        let noteRow = form.allRows.filter{ $0.tag == "note"}.first
        if let clockNoteRow = noteRow as? ClockNoteViewRow {
            clock?.note = clockNoteRow.value ?? ""
        }
        
        let breakRow = form.allRows.filter{ $0.tag == "break"}.first
        if let clockBreakRow = breakRow as? ClockNoteViewRow {
            clock?.breakTime = clockBreakRow.value ?? ""
        }
        
        let controller = ClockSummaryViewController()
        controller.clock = clock
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

//
//  ClockSummaryViewController.swift
//  EmployeePortal
//
//  Created by Sajeev on 2/8/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

enum ClockSummaryKeys: String {
    case shiftDate
    case shiftTime
}

class ClockSummaryViewController: BaseFormViewController {    

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
                $0.title = "Summary Of Shift"
                $0.cellStyle = .default
            }
            .cellUpdate({ (cell, row) in
                cell.textLabel?.textAlignment = .center
            })
            
        <<< EmptyRow() { $0.cell.height = {22} }
             
            <<< LabelRow(ClockSummaryKeys.shiftDate.rawValue) {

                 $0.title = Date().toString("dd MMM YYYY")
                 $0.cellStyle = .default

             }
             .cellUpdate({ (cell, row) in
                 cell.textLabel?.textAlignment = .center
             })
        
        <<< LabelRow(ClockSummaryKeys.shiftTime.rawValue) {
            if let newclock = clock {
                $0.title = newclock.clockOnTime.convertDateFormater(with: "yyyy-MM-dd HH:mm:ss", toMask: "hh:mm a") + " - " + newclock.clockOffTime.convertDateFormater(with: "yyyy-MM-dd HH:mm:ss", toMask: "hh:mm a")
            }
            $0.cellStyle = .default

        }
        .cellUpdate({ (cell, row) in
            cell.textLabel?.textAlignment = .center
        })
        
        <<< LabelRow("break") {
            if let newclock = clock {
                $0.title = (newclock.breakTime.isEmpty) ? "No Breaks" : ("Break time:" + newclock.breakTime)
            }
            $0.cellStyle = .default

        }
        .cellUpdate({ (cell, row) in
            cell.textLabel?.textAlignment = .center
        })
        
        <<< EmptyRow() { $0.cell.height = {22} }

            <<< LabelRow("totalTimeHeader") {
                $0.title = "Total Time Worked:"
                $0.cellStyle = .default
                
            }
        .cellUpdate({ (cell, row) in
            cell.textLabel?.textAlignment = .center
        })
        
            <<< LabelRow("workedTime") {
                guard let newClock = clock else { return }
                
                let timeDiff = newClock.workTime
                $0.title = timeDiff.hour + " hr " + timeDiff.minutes + " min"
                $0.cellStyle = .default
                
            }
        .cellUpdate({ (cell, row) in
            cell.textLabel?.textAlignment = .center
        })
        
            <<< EmptyRow() { $0.cell.height = {30} }
            
            <<< SubmitButtonRow("Row5") { row in
                row.name = "Submit Timesheet"
                row.actionHandler = { [weak self] in
                    self?.submitShiftDetails()
                }
        }
        
//            <<< EmptyRow() { $0.cell.height = {30} }
//            
//            <<< SubmitButtonRow("Row5") { row in
//                row.name = "Edit Timesheet"
//                row.actionHandler = { [weak self] in
//                    self?.navigationController?.popViewController(animated: true)
//                }
//        }
    }
    
    func submitShiftDetails() {
        showLoader()
        clock?.submit(completion: { [weak self] (response) in
            switch response {
            case .success:
                
                // set in progress value
                UserDefaults.standard.set(false, forKey: "ClockInProgress")
                
                AlertController.show(type: .dataSubmit, error: nil, successHandler: {
                    self?.goToDashboard()
                }, cancelHandler: nil)
                
            case .failure(let error):
                AlertController.show(type: .serviceError, error: error)
            case .finally:
                self?.hideLoader()
            }
        })
    }

}


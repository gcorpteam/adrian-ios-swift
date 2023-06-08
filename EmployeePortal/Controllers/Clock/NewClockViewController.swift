//
//  NewClockViewController.swift
//  EmployeePortal
//
//  Created by Sajeev on 2/7/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

enum Mode: String {
    case on = "Add Clock On Time:"
    case off = "Add Clock Off Time:"
    
    var buttonTitle: String {
        switch self {
        case .on: return "Clock On"
        case .off: return "Clock Off"
        }
    }
}

class NewClockViewController: BaseFormViewController {
    
    override var shouldHideMenuOption: Bool {
        return true
    }
    
    override var shouldShowBackButton: Bool {
        return true
    }
    
    var clock: Clock?
    
    var viewMode: Mode? = .on
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0);

        LocationManager.shared.requestWhenInUseAuthorization { (status) in

        }
    }

    override func createForm() {
        form +++ Section("")
            <<< BannerViewRow("Row0") { row in
                row.header = "Clock on active"
                row.cell.height = {
                    return 40
                }
                row.hidden = Condition.function(["Row0"], { [weak self] form in
                    self?.viewMode == .on
                })
            }
            
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
                $0.title = viewMode?.rawValue
                $0.cellStyle = .default

            }
            .cellUpdate({ (cell, row) in
                cell.textLabel?.textAlignment = .center
            })
            
            <<< EmptyRow() { $0.cell.height = {25} }
        
            <<< TimeViewRow("time") { row in
                
            }
            
            <<< EmptyRow() { $0.cell.height = {40} }

            <<< SubmitButtonRow("Row5") { row in
                row.name = viewMode?.buttonTitle
                row.actionHandler = { [weak self] in
                    switch self?.viewMode {
                    case .on:
                        self?.clockOn()
                    case .off:
                        self?.goToBreakTimeView(clock: self?.clock)
                    case .none:
                        break
                    }
                }
        }

    }
    
    func goToBreakTimeView(clock: Clock?) {
        let timeRow: TimeViewRow?    = row(tag: "time")
        clock?.clockOffTime = timeRow?.value ?? ""
        
        let controller = AddBreakTimeViewController()
        controller.clock = clock
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func clockOn() {
        let timeRow: TimeViewRow? = row(tag: "time")
        
        let newClock = Clock()
        clock = newClock
        clock?.shiftDate = Date().toString("yyyy-MM-dd HH:mm:ss")
        clock?.clockOnTime = timeRow?.value ?? ""
        
        if !LocationManager.shared.isLocationServicesEnabled {
            AlertController.show(type: .locationSettings, error: nil, successHandler: {
                LocationManager.shared.showLocationSettings()
            }, cancelHandler: nil)
            return
        }
        
        showLoader()
        
        LocationManager.shared.fetchCurrentLocation { [weak self] (location, error) in
            guard let location = location else { return }
            let locationString = String(location.coordinate.latitude) + "," + String(location.coordinate.longitude)
            self?.clock?.location = locationString
            self?.addClockOn(clock: self?.clock)
        }
    }
    
    func addClockOn(clock: Clock?) {
        var newClock = clock
        clock?.on { [weak self] (response) in
            switch response {
            case .success(let data):
                newClock = data
                
                // save to database
                newClock?.save()
                
                // set in progress value
                UserDefaults.standard.set(true, forKey: "ClockInProgress")
                
                DispatchQueue.main.async {
                    self?.navigateToNextScreen(clock: newClock)
                }
            case .failure(let error):
                AlertController.show(type: .serviceError, error: error)
            case .finally:
                self?.hideLoader()
            }
        }
    }
    
    private func navigateToNextScreen(clock: Clock?) {
        let controller = NewClockViewController()
        controller.viewMode = .off
        controller.clock = clock
        navigationController?.pushViewController(controller, animated: true)
    }

}

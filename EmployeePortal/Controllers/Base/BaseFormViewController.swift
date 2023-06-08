//
//  BaseFormViewController.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/15/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import Foundation
import Eureka

protocol Validatable {
    func handleValidation()
    func handleError(error: EmpError)
    func handleValidationSuccess()
}

class BaseFormViewController: FormViewController, NavigationBarOptions, ActivityIndicatorPresenter, Validatable {
    var activityIndicator = UIActivityIndicatorView()

    var shouldHideMenuOption: Bool {
        return false
    }
    
    var shouldShowBackButton: Bool {
        return false
    }
    
    var isFormEditable: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .white
        
        tableView.separatorColor = .clear
        
        navigationController?.navigationBar.topItem?.title = " "
                
        if shouldShowBackButton {
            addNavigationButton(option: .back)
         }
        
        if !shouldHideMenuOption {
            addNavigationButton(option: .menu)
        }
        
        createForm()
        
        if !isFormEditable {
            addNavigationLockButton()
            
            form.allRows.forEach { (row) in
                row.baseCell.isUserInteractionEnabled = false
            }
        }
        
    }
    
    func validate() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = ClassType.type(className: Self.identifier)?.title
    }

    func createForm() {}
    
    func handleValidation() {
        if !form.isValid, let error = form.validate().first {
            handleError(error: EmpError(error: error))
        }
        else {
            handleValidationSuccess()
        }
    }
    
    func handleError(error: EmpError) {
        AlertController.show(type: .dataIncomplete, error: error)
    }
    
    func handleValidationSuccess() {}
    
}

enum ClassType: String, CaseIterable, SideMenuNavigatable {
    
    case LoginView          = "LoginViewController"
    case DashboardView      = "DashboardViewController"
    case ForgotPasswordView = "ForgotPasswordViewController"
    case PersonalFilesView  = "PersonalFilesViewController"
    case EmergencyView      = "EmergencyViewController"
    case ContactDetailsView = "ContactDetailsViewController"
    case TimesheetView      = "TimesheetViewController"
    case LeaveView          = "LeaveViewController"
    case RecordsView        = "RecordsViewController"
    case JobDetailsView     = "JobDetailsViewController"
    case RosterView         = "CalendarViewController"
    case ContactHRView      = "ContactHRViewController"
    case PasswordView       = "UpdatePasswordViewController"
    case NewClockView       = "NewClockViewController"
    case NewClockBreakView  = "AddBreakTimeViewController"
    case NewClockSummaryView = "ClockSummaryViewController"

    static func type(className: String) -> Self? {
        return ClassType.allCases.filter{ $0.rawValue == className }.first
    }
    
    static var sideMenuItems: [ClassType] {
        return [.DashboardView, .PersonalFilesView, .RosterView, .NewClockView, .TimesheetView, .LeaveView, .RecordsView, .ContactHRView]
    }
    
    var title: String {
        switch self {
        case .LoginView:          return "Login"
        case .ForgotPasswordView: return "Forgot Password"
        case .PersonalFilesView:  return "Personnel Files"
        case .NewClockView:      return "Clock On/ Off"
        case .EmergencyView:      return "Emergencies"
        case .ContactDetailsView: return "Contact Details"
        case .LeaveView:          return "Leaves"
        case .RecordsView:        return "HR Records"
        case .TimesheetView:      return "Timesheets"
        case .JobDetailsView:     return "Job Details"
        case .RosterView:         return "Roster"
        case .ContactHRView:      return "Contact HR"
        case .PasswordView:       return "Update password"
        case .NewClockView, .NewClockBreakView, .NewClockSummaryView: return "Clock On/ Off"
        default:
            return ""
        }
    }
    
    var sideMenuTitle: String {
        switch self {
        case .DashboardView:      return "Home"
        case .PersonalFilesView:  return "Personal Files"
        case .NewClockView:      return "Clock on clock Off"
        case .TimesheetView:      return "Add Timesheets"
        case .LeaveView:          return "Add Leave Requests"
        case .RecordsView:        return "Add HR Records"
        case .LoginView:          return "Logout"
        case .RosterView:         return "Roster"
        case .ContactHRView:      return "Contact HR"

        default:
            return ""
        }
    }
    
    func controller<T>() -> T? where T : UIViewController {
        switch self {
        case .DashboardView:      return DashboardViewController() as? T
        case .PersonalFilesView:  return PersonalFilesViewController() as? T
        case .TimesheetView:      return TimesheetViewController() as? T
        case .LeaveView:          return LeaveViewController() as? T
        case .RecordsView:        return RecordsViewController() as? T
        case .LoginView:          return LoginViewController() as? T
        case .ContactHRView:      return ContactHRViewController() as? T
        case .NewClockView:
            let newClockView = NewClockViewController()
            let allDates = Clock.allCaches().map{ $0.shiftDate.convertDateFormater(with: "yyyy-MM-dd HH:mm:ss", toMask: "yyyy-MM-dd") }
            let isClockLoggedOn = allDates.contains(Date().toString("yyyy-MM-dd"))
            newClockView.viewMode = isClockLoggedOn ? .off : .on
            newClockView.clock = Clock.cached()
            return newClockView as? T
        case .NewClockBreakView:  return AddBreakTimeViewController() as? T
        case .NewClockSummaryView:return ClockSummaryViewController() as? T

        case .RosterView:
            guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: CalendarViewController.identifier) as? CalendarViewController else { return CalendarViewController() as? T}
            return viewController as? T
            
        default:
            return nil
        }
    }
}

extension BaseFormViewController: Formable {}

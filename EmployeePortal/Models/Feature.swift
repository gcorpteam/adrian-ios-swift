//
//  Feature.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/9/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import Foundation
import UIKit

protocol Feature {
    var icon: UIImage? {get}
    var name: String {get}
}

enum DashboardFeatures: String, Feature, CaseIterable {
    case personal   = "Personnel Files"
    case roster     = "Roster"
    case clock      = "Clock on/ Off"
    case timesheets = "Add Timesheets"
    case leave      = "Add Leave Requests"
    case records    = "Add HR Records"
    case contact    = "Contact HR"
    
    var icon: UIImage? {
        switch self {
        case .personal:
            return UIImage(named: "personal")
        case .roster:
            return UIImage(named: "roster")
        case .clock:
            return UIImage(named: "clock")
        case .timesheets:
            return UIImage(named: "timesheets")
        case .leave:
            return UIImage(named: "leave")
        case .records:
            return UIImage(named: "records")
        case .contact:
            return UIImage(named: "contactHr")
        }
    }
    
    var name: String {
        return rawValue
    }
}

enum PersonalFileFeatures: String, Feature, CaseIterable {
    case contact   = "Contact Details"
    case emergency = "Emergencies"
    case job       = "Job Details"
    case password  = "Update password"
    
    var icon: UIImage? {
        switch self {
        case .contact:
            return UIImage(named: "contact")
        case .emergency:
            return UIImage(named: "emergency")
        case .job:
            return UIImage(named: "job")
        case .password:
            return UIImage(named: "password")
        }
    }
    
    var name: String {
        return rawValue
    }
}

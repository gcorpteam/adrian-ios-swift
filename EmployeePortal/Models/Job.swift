//
//  Job.swift
//  EmployeePortal
//
//  Created by Sajeev on 1/9/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import Foundation

class Job: BaseObject, Codable {
    @objc dynamic var status          = ""
    @objc dynamic var jobTitle        = ""
    @objc dynamic var employmentType  = ""
    @objc dynamic var nameOfAward     = ""
    @objc dynamic var classification  = ""
    @objc dynamic var nameOfManager   = ""
    @objc dynamic var managerJobTitle = ""
    @objc dynamic var location        = ""
    @objc dynamic var team            = ""
}



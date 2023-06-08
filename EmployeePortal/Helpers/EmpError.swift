//
//  EmpError.swift
//  EmployeePortal
//
//  Created by Sajeev on 3/17/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import Eureka

class EmpError: Error {
    var code = ""
    var message = ""
    
    init(error: ValidationError) {
        self.code = "401"
        self.message = error.msg
    }
}

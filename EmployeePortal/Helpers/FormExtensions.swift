//
//  FormExtensions.swift
//  EmployeePortal
//
//  Created by Sajeev on 2/11/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import Foundation
import Eureka

protocol Formable {
    func row<T>(tag: String) -> T
}

extension Formable where Self: BaseFormViewController {
    func row<T>(tag: String) -> T {
        return self.form.rowBy(tag: tag) as!
        T
    }
    
}

extension Form {
    var isValid: Bool {
        return validate().count == 0
    }
}


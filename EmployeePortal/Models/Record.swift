//
//  Record.swift
//  EmployeePortal
//
//  Created by Sajeev on 2/13/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import Foundation

class Record {
    var name: String = ""
    var fileName = ""
    var file = ""
    var type = ""
    
    init(name: String, type: String, fileName: String) {
        self.name = name
        self.type = type
        self.fileName = fileName
    }
}

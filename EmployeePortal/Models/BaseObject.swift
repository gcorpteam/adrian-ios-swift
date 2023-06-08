//
//  BaseObject.swift
//  EmployeePortal
//
//  Created by Sajeev on 2/14/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import Foundation
import RealmSwift

class BaseObject: Object, Caching {}

class BaseResponse: Codable {
    var Message: String?
    var tokenValid: Bool?
    var status: Bool?
}

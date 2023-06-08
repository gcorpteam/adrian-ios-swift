//
//  ResponderExtension.swift
//  SeatGeek
//
//  Created by sajeev Raj on 10/26/19.
//  Copyright © 2019 SeatGeek. All rights reserved.
//

import Foundation
import UIKit

extension UIResponder {
    static var identifier: String {
        return "\(self)"
    }
}

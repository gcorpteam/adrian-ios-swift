//
//  DataExtension.swift
//  EmployeePortal
//
//  Created by Sajeev on 3/17/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import Foundation

extension Data {
    func compress() -> Data? {
        do {
            if #available(iOS 13.0, *) {
                let compressedData = try (self as NSData).compressed(using: .lzfse)
                return compressedData as Data
            } else {
                // Fallback on earlier versions
                return self
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

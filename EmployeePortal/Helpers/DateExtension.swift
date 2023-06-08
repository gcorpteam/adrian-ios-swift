//
//  DateExtension.swift
//  EmployeePortal
//
//  Created by sajeev Raj on 12/24/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import Foundation

extension Date {
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    func toString(_ mask:String?) -> String {
        let dateFormatter = DateFormatter()
        if mask != nil {
            dateFormatter.dateFormat = mask
        } else {
            dateFormatter.timeStyle = .medium
            dateFormatter.dateStyle = .medium
        }
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        return dateFormatter.string(from: self)
    }
    
    func string(of dateFormatType: DateFormatType) -> String {
        return DateFormatter.dateFormatter(of: dateFormatType).string(from: self)
    }
}

extension Date {
    func startOfMonth() -> Date? {
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month, .hour], from: Calendar.current.startOfDay(for: self))
        return Calendar.current.date(from: comp)!
    }

    func endOfMonth() -> Date? {
        var comp: DateComponents = Calendar.current.dateComponents([.month, .day, .hour], from: Calendar.current.startOfDay(for: self))
        comp.month = 1
        comp.day = -1
        return Calendar.current.date(byAdding: comp, to: self.startOfMonth()!)
    }
    
    func startOfDay() -> Date {
        let stringDate = string(of: .ddMMyyyySlash)
        return stringDate.date(of: .ddMMyyyySlash)!
    }
    
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    func isGreater(date: Date) -> Bool {
        switch self.compare(date) {
        case .orderedAscending:
            return false
        case .orderedDescending:
            return true
        case .orderedSame:
            return false
        }
    }
}

enum DateFormatType: String {
    case ddMMyyyySlash = "dd/MM/yyyy"
    case MMMddyyyy = "MMM dd yyyy"
    case ddMMyyyyHyphen = "dd-MM-yyyy"
    case MMMddyyyhhmma = "MMM dd yyyy hh:mma"
    case yyyyMMddhhmmssz = "yyyy-MM-dd HH:mm:SS.Z"
    case yyyyMMddhhmmss = "yyyy-MM-dd HH:mm:ss"
}

extension DateFormatter {
    static func dateFormatter(of dateFormatType: DateFormatType) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatType.rawValue
        formatter.calendar = Calendar.current
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        return formatter
    }
}

extension String {
    func date(of dateFormatType: DateFormatType) -> Date? {
        return DateFormatter.dateFormatter(of: dateFormatType).date(from: self)
    }
}

extension String {
    func toDateFormat(_ mask:String? = "hh:mm a") -> String {
        let formatter = DateFormatter()
         formatter.dateFormat = mask
        
        let date = formatter.date(from: self)
        return date?.toString(mask) ?? ""
    }
    
    func convertDateFormater(with mask: String, toMask: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = mask
        guard let date = dateFormatter.date(from: self) else {
            assert(false, "no date from string")
            return ""
        }

        dateFormatter.dateFormat = toMask
        let timeStamp = dateFormatter.string(from: date)

        return timeStamp
    }
}

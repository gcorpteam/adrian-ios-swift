//
//  Roster.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/27/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit

protocol CalendarDateRepresentable {
    var message: String { get }
}

// MARK: - RosterList
class Roster: Codable {
    var notes = ""
    var startTime = ""
    var endTime = ""
    var totalHour = ""
    var status = ""

    var type = RosterType.shift
    var date = Date()
    var totalDay = ""
    var typeOfHour = ""
    var breakTime = ""                   
         
    enum CodingKeys: String, CodingKey {
        case notes          = "notes"
        case startTime      = "startTime"
        case endTime        = "endTime"
        case totalHour      = "totalHour"
        case status         = "rosterStatus"
        case type           = "recordType"
        case date           = "rosterDate"
        case totalDay       = "totalDay"
        case typeOfHour     = "TypeOfHour"
        case breakTime      = "BreakTime"
    }
        
    required init(from decoder: Decoder) throws {
        func getDateValue(dateString: String) -> Date {
            return dateString.date(of: .MMMddyyyy) ?? Date()
        }
        // for date formatting
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date        = getDateValue(dateString: try container.decode(String.self, forKey: .date))
        endTime     = try container.decode(String.self, forKey: .endTime)
        startTime   = try container.decode(String.self, forKey: .startTime)
        
        // all others for usual mapping
        notes       = try container.decode(String.self, forKey: .notes)
        totalHour   = try container.decode(String.self, forKey: .totalHour)
        status      = try container.decode(String.self,forKey: .status)
        type        = try container.decode(RosterType.self, forKey: .type)
        totalDay    = try container.decode(String.self, forKey: .totalDay)
        typeOfHour  = try container.decode(String.self, forKey: .typeOfHour)
        breakTime   = try container.decode(String.self, forKey: .breakTime )
    }
}

extension Roster {
    class MyRoster: Codable {
        var status: String = ""
        var message: String = ""
        var tokenValid: String = ""
        var rosterList = [Roster]()
    }
}

extension Roster: CalendarDateRepresentable {
    var message: String {
        switch type {
        case .shift : return "\(startTime) - \(endTime)"
        case .leave : return "Leave"
        }
    }
}

extension Roster {
    enum RosterType: String, Codable {
        case shift = "Timesheet"
        case leave = "Leave"
        
        var color : UIColor {
            switch self {
            case .shift : return ThemeManager.Color.green
            case .leave : return ThemeManager.Color.blue
            }
        }
        
        var textColor: UIColor {
            return ThemeManager.Color.white
        }
    }
}

extension Roster.RosterType: CalendarDateRepresentable {
    var message: String {
        switch self {
        case .shift : return "Work"
        case .leave : return "Leave"
        }
    }
}


extension Roster {
    enum Router: Requestable {
        case calendarDetails(from:Date,to:Date)
        
        var path: String { "Roster/myRoster" }
        
        var method: HTTPMethod { .post }

        var parameters: [String : Any] {
            switch self {
            case .calendarDetails(let fromDate,let toDate):
                
                return ["startDate": fromDate.string(of: .yyyyMMddhhmmssz) ,
                        "endDate": toDate.string(of: .yyyyMMddhhmmssz)
                ]
            }
        }
    }
    
    class func getRosters(from fromDate:Date?,to toDate:Date?,completion: @escaping (ServiceResponse<[Roster]>) -> ()) {
        guard let fromDate = fromDate, let toDate = toDate else {
            completion(.failure(error: NSError(domain: "error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Range Provided"])))
            return
        }
        Roster.Router.calendarDetails(from:  fromDate,to: toDate).request { (response: ServiceResponse<MyRoster>) in
            switch response {
            case .success(let results):
                completion(.success(data: results.rosterList))
            case .failure(let error):
                completion(.failure(error: error))
            case .finally:
                completion(.finally)
            }
        }
    }
}

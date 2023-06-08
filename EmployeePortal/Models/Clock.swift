//
//  Clock.swift
//  EmployeePortal
//
//  Created by Sajeev on 1/9/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import Foundation

class Clock: BaseObject, Codable {
    
    override static func primaryKey() -> String?
    {
        return "id"
    }
    
    @objc dynamic var id            = ""
    @objc dynamic var shiftDate     = ""
    @objc dynamic var clockOnTime   = ""
    var clockOffTime  = ""
    var breakTime     = ""
    var note          = ""
    var location      = ""
    
    var workTime: (hour: String, minutes: String) {
          let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

          guard let date1 = formatter.date(from: clockOnTime) else { return ("","") }
          guard let date2 = formatter.date(from: clockOffTime) else { return ("","")}

           let elapsedTime = date2.timeIntervalSince(date1)

           // convert from seconds to hours, rounding down to the nearest hour
           let hours = floor(elapsedTime / 60 / 60)

           // we have to subtract the number of seconds in hours from minutes to get
           // the remaining minutes, rounding down to the nearest minute (in case you
           // want to get seconds down the road)
           let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
          
          let totalMinutes = (hours * 60) + minutes
        let workedMinutes = Int(totalMinutes) - (Int(breakTime) ?? 0)
          let tuple = minutesToHoursMinutes(minutes: workedMinutes)

          return(String(tuple.hours), String(tuple.leftMinutes))
    }
    
    convenience init(date: String, onTime: String, offTime: String, breakTime: String, note: String) {
        self.init()
        self.shiftDate      = date
        self.clockOnTime    = onTime
        self.clockOffTime   = offTime
        self.breakTime      = breakTime
        self.note           = note
    }
    
    func submit(completion: @escaping (ServiceResponse<ClockResponse?>) -> ()) {
        Router.add(clock: self).request { (response: ServiceResponse<ClockResponse>) in
            switch response {
            case .success(let results):
                completion(.success(data: results))
            case .failure(let error):
                completion(.failure(error: error))
            case .finally:
                completion(.finally)
            }
        }
    }
    
    func on(completion: @escaping (ServiceResponse<Clock?>) -> ()) {
        Router.on(clock: self).request { [weak self] (response: ServiceResponse<ClockResponse>) in
            guard let welf = self else { return }
            switch response {
            case .success(let results):
                welf.id = results.timesheetID
                completion(.success(data: welf))
            case .failure(let error):
                completion(.failure(error: error))
            case .finally:
                completion(.finally)
            }
        }
    }
    
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
}

extension Clock {
    enum Router: Requestable {
        case add(clock: Clock)
        case on(clock: Clock)
        
        var path: String {
            switch self {
            case .add: return "Timesheet/AddClockOff"
            case .on: return "Timesheet/AddClockOn"
            }
        }
        
        var method: HTTPMethod {
            return .post
        }
        
        var parameters: [String : Any] {
            switch self {
            case .add(let clock):
                return ["timesheetID": clock.id,
                        "dateWorked": clock.shiftDate,
                        "clockTime": clock.clockOffTime,
                        "breaktime": clock.breakTime,
                        "Location": clock.location,
                        "timePosted": clock.clockOffTime,
                        "note": clock.note]
            case .on(let clock):
                return [
                        "dateWorked": clock.shiftDate,
                        "timePosted": clock.clockOnTime,
                        "clockTime": clock.clockOnTime,
                        "location": clock.location]
            }
        }
    }
}

extension Clock {
    class ClockResponse: Codable {
        var timesheetID = ""
        var status = ""
        var message = ""
        
        enum CodingKeys: String, CodingKey {
            case timesheetID   = "timesheetID"
            case status = "status"
            case message = "message"
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let id = try container.decode(Int.self, forKey: .timesheetID)
            timesheetID = String(id)
            status = try container.decode(String.self, forKey: .status)
            message = try container.decode(String.self, forKey: .message)
        }
    }
}


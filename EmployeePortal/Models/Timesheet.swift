//
//  Timesheet.swift
//  EmployeePortal
//
//  Created by Sajeev on 2/29/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import Foundation
import Realm

class TimeSheet: Codable {
    var dateWorked = ""
    var startTime = ""
    var endTime = ""
    var breakTime =  ""
    var timeWorked =  ""
    var hourType = ""
    var notes = ""
    
    var userId: String {
        Employee.cached().id
    }
}

class LookUp: BaseObject, Codable {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var typeValue = ""
    
    var type: LookUpType? {
        didSet {
            typeValue = type?.rawValue ?? ""
        }
    }
    
    override static func primaryKey() -> String?
    {
        return "name"
    }
    
    static var leaveTypes: [LookUp] {
        return LookUp.allCaches().filter { (lookup) -> Bool in
            let type = LookUpType(rawValue: lookup.typeValue)
            switch type {
            case .leave: return true
            default: return false
            }
        }
    }
    
    static var timesheetTypes: [LookUp] {
        return LookUp.allCaches().filter { (lookup) -> Bool in
            let type = LookUpType(rawValue: lookup.typeValue)

            switch type {
            case .timesheet: return true
            default: return false
            }
        }
    }
    
    static var recordTypes: [LookUp] {
        return LookUp.allCaches().filter { (lookup) -> Bool in
            let type = LookUpType(rawValue: lookup.typeValue)

            switch type {
            case .record: return true
            default: return false
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id   = "LookupValueID"
        case name = "LookupDescription"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)

        super.init()
    }
    
    required init(value: Any, schema: RLMSchema)
     {
         super.init(value: value, schema: schema)
     }
     
     required init(realm: RLMRealm, schema: RLMObjectSchema)
     {
         super.init(realm: realm, schema: schema)
     }
    
    required init()
      {
          super.init()
      }
    
    static func getLookUp(type: LookUpType, completion: @escaping (ServiceResponse<[LookUp]>) -> ()) {
        Router.lookUp(type: type).request { (response: ServiceResponse<LookUpResponse>) in
            switch response {
            case .success(let result):
                completion(.success(data: result.lookupType))
            case .failure(let error):
                completion(.failure(error: error))
            case .finally:
                completion(.finally)
            }
        }
    }
    
    static func getId(type: LookUpType, name: String) -> Int? {
        if type == .leave {
            return leaveTypes.filter{ $0.name == name }.first?.id
        }
        return timesheetTypes.filter{ $0.name == name }.first?.id
    }
    
    enum LookUpType: String {
        case leave = "leave"
        case timesheet = "WGWorkHourType"
        case record = "WGCompanyDocumentType"
    }

}

extension LookUp {
    enum Router: Requestable {
        case lookUp(type: LookUpType)
        
        var path: String {
            switch self {
            case .lookUp:
                return "Element/GetType"
            }
        }
        
        var parameters: [String : Any] {
            switch self {
            case .lookUp(let type):
                return ["Lookuptype": type.rawValue]
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .lookUp:
                return .post
            }
        }
    }
}

class LookUpResponse: BaseObject, Codable {
    var status = ""
    var lookupItem = ""
    var message = ""
    var lookupType = [LookUp]()
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case lookupItem = "LookupItem"
        case lookupType = "elementType"
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(String.self, forKey: .status)
        message = try container.decode(String.self, forKey: .message)
        lookupItem = try container.decode(String.self, forKey: .lookupItem)
        lookupType = try container.decode([LookUp].self, forKey: .lookupType)
        
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema)
    {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema)
    {
        super.init(realm: realm, schema: schema)
    }
    
    required init()
    {
        super.init()
    }
}

private struct CustomCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    var intValue: Int?
    init?(intValue: Int) {
        return nil
    }
}

extension Array where Element: LookUp {
    func values() -> [String] {
        return map{ $0.name }
    }
}


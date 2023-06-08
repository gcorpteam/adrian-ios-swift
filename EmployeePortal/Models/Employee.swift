//
//  Employee.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/9/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import Foundation
import Realm

class Employee: BaseObject, Codable {
    
      override static func primaryKey() -> String?
      {
          return "id"
      }
        
    @objc dynamic var id      = ""
    @objc dynamic var type    = ""
    @objc dynamic var designation = ""
    @objc dynamic var username = ""
    var password = ""
    @objc dynamic var fullname = ""
    @objc dynamic var imageUrlString = ""
    @objc dynamic var contact: Contact?
    @objc dynamic var emergencyContact: EmergencyContact?
    @objc dynamic var jobdetail: Job?
    var clock: Clock?
    
    enum CodingKeys: String, CodingKey {
        case id   = "userID"
        case type = "userType"
        case fullname = "fullName"
        case username = "userName"
        case designation = "role"
        case imageUrlString = "profilePicture"
        case contact = "contactDetails"
        case emergencyContact = "emergencycontact"
        case jobdetail = "jobDetails"

    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        fullname = try container.decode(String.self, forKey: .fullname)
        username = try container.decode(String.self, forKey: .username)
        designation = try container.decode(String.self, forKey: .designation)
        imageUrlString = try container.decode(String.self, forKey: .imageUrlString)
        contact = try container.decode(Contact.self, forKey: .contact)
        emergencyContact = try container.decode(EmergencyContact.self, forKey: .emergencyContact)
        jobdetail = try container.decode(Job.self, forKey: .jobdetail)

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
    
    static func login(employee: Employee, completion: @escaping (ServiceResponse<Employee>) -> ()) {
        Router.login(user: employee).request { (response: ServiceResponse<ProfileResponse<Employee>>) in
            switch response {
            case .success(let results):
                completion(.success(data: results.userDetail))
            case .failure(let error):
                completion(.failure(error: error))
            case .finally:
                completion(.finally)
            }
        }
    }
    
    static func authenticate(employee: Employee, completion: @escaping (ServiceResponse<String>) -> ()) {
        Router.authenticate(user: employee).request { (response: ServiceResponse<String>) in
            switch response {
            case .success(let results):
                ServiceManager.shared.token = results.replacingOccurrences(of: "\"", with: "")
                completion(.success(data: results ))
            case .failure(let error):
                completion(.failure(error: error))
            case .finally:
                completion(.finally)
            }
        }
    }
    
    static func forgotPassword(username: String, completion: @escaping (ServiceResponse<Bool>) -> ()) {
        Router.forgotPassword(userName: username).request { (response: ServiceResponse<StatusResponse>) in
            switch response {
            case .success(let results):
                completion(.success(data: results.status))
            case .failure(let error):
                completion(.failure(error: error))
            case .finally:
                completion(.finally)
            }
        }
    }
    
    static func logout(userId: String, completion: @escaping (ServiceResponse<Bool>) -> ()) {
        Router.logout(userId: userId).request { (response: ServiceResponse<StatusResponse>) in
            switch response {
            case .success(let results):
                completion(.success(data: results.status))
            case .failure(let error):
                completion(.failure(error: error))
            case .finally:
                completion(.finally)
            }
        }
    }
    
    static func submitRecord(record: Record, dataUri: String, completion: @escaping (ServiceResponse<Bool>) -> ()) {
        Router.submitRecord(record: record, dataUri: dataUri).request { (response: ServiceResponse<StatusResponse>) in
            switch response {
            case .success(let results):
                completion(.success(data: results.status))
            case .failure(let error):
                completion(.failure(error: error))
            case .finally:
                completion(.finally)
            }
        }
    }
    
    static func updatePassword(userId: String, oldPass: String, newPass: String, completion: @escaping (ServiceResponse<Bool>) -> ()) {
        Router.updatePassword(userId: userId, oldPass: oldPass, newPass: newPass).request { (response: ServiceResponse<StatusResponse>) in
            switch response {
            case .success(let results):
                completion(.success(data: results.status))
            case .failure(let error):
                completion(.failure(error: error))
            case .finally:
                completion(.finally)
            }
        }
    }
    
    static func submitTimesheet(timesheet: TimeSheet, completion: @escaping (ServiceResponse<Bool>) -> ()) {
        Router.updateTimesheet(timesheet: timesheet).request { (response: ServiceResponse<StatusResponse>) in
            switch response {
            case .success(let results):
                completion(.success(data: results.status))
            case .failure(let error):
                completion(.failure(error: error))
            case .finally:
                completion(.finally)
            }
        }
    }
    
    static func submitLeave(fileName: String, leaveType: String, leaveTypeID: String, dateFrom: String,dateTo: String, totalHours: String, notes: String, attachment: String, completion: @escaping (ServiceResponse<Bool>) -> ()) {
        Router.submitLeave(fileNameAs: fileName, leaveType: leaveType, leaveTypeID: leaveTypeID, dateFrom: dateFrom, dateTo: dateTo, totalHours: totalHours, notes: notes, attachment: attachment).request { (response: ServiceResponse<StatusResponse>) in
            switch response {
            case .success(let results):
                completion(.success(data: results.status))
            case .failure(let error):
                completion(.failure(error: error))
            case .finally:
                completion(.finally)
            }
        }
    }
    
    static func updateProfilePic(imageName: String, dataUri: String, completion: @escaping (ServiceResponse<Bool>) -> ()) {
        Router.updatePicture(imageName: imageName, dataUri: dataUri).request { (response: ServiceResponse<StatusResponse>) in
            switch response {
            case .success(let results):
                completion(.success(data: results.status))
            case .failure(let error):
                completion(.failure(error: error))
            case .finally:
                completion(.finally)
            }
        }
    }
    
}

extension Employee {
    enum Router: Requestable {
        case authenticate(user: Employee)
        case login(user: Employee)
        case forgotPassword(userName: String)
        case logout(userId: String)
        case submitRecord(record: Record, dataUri: String)
        case updatePassword(userId: String, oldPass: String, newPass: String)
        case updateTimesheet(timesheet: TimeSheet)
        case submitLeave(fileNameAs: String, leaveType: String, leaveTypeID: String, dateFrom: String,dateTo: String, totalHours: String, notes: String, attachment: String)
        case updatePicture(imageName: String, dataUri: String)
        
        var path: String {
            switch self {
            case .authenticate:
                return "authentication"
            case .login:
                return "Employee/Profile"
            case .forgotPassword:
                return ""
            case .logout:
                return "Employee/Logout"
            case .submitRecord:
                return "Record/Upload"
            case .updatePassword:
                return ""
            case .updateTimesheet:
                return "Timesheet/AddTimesheet"
            case .submitLeave:
                return "Leave/AddLeave"
            case .updatePicture:
                return "Employee/UploadPicture"
            }
        }

        var parameters: [String : Any] {
            switch self {
            case .authenticate(let user):
                return ["UserName": user.username, "Password": user.password]
            case .login(let user):
                return ["logon": user.username]
            case .forgotPassword(let userName):
                return ["username": userName]
            case .logout(let userId):
                return ["Logon": userId]
            case .submitRecord(let record, let dataUri):
                return ["recordname": record.name, "recordType": record.type, "filename": record.fileName, "DataURI": dataUri]
            case .updatePassword(let userId, let oldPass, let newPass):
                return ["userID":userId,"oldPassword":oldPass,"newPassword":newPass,"confirmPassword":newPass]
            case .updateTimesheet(let timesheet):
                return ["userID":timesheet.userId,"dateWorked":timesheet.dateWorked,"startTime":timesheet.startTime,"endTime":timesheet.endTime,"breakTime":timesheet.breakTime,"totalHours":timesheet.timeWorked,"typeOfHours":timesheet.hourType,"notes":timesheet.notes]
            case .submitLeave(let fileNameAs, let leaveType, let leaveTypeID, let dateFrom, let dateTo, let totalHours, let notes, let attachment):
                return ["fileNameAs":fileNameAs,"leaveType":leaveType,"leaveTypeID":leaveTypeID,"dateFrom":dateFrom,"dateTo":dateTo,"totalHours":totalHours,"notes":notes, "DataURI": attachment]
            case .updatePicture(let imageName, let dataUri):
                return ["fileName": imageName, "DataURI": dataUri]
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .login, .authenticate, .updateTimesheet, .submitLeave, .submitRecord, .updatePicture:
                return .post
            default:
                return .get
            }
        }
        
        var responseParserType: ResponseParserType {
            switch self {
            case .authenticate:
                return .string
            default:
                return .json
            }
        }
    }
}

class ProfileResponse<T: Codable>: Codable {
    var status: Bool = false
    var tokenValid: Bool = true
    var userDetail: T
    
    enum CodingKeys: CodingKey {
        case status, userDetail, tokenValid
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(String.self, forKey: .status) == "true"
        tokenValid = try container.decodeIfPresent(String.self, forKey: .tokenValid) == "true"
        if !tokenValid {
            NotificationCenter.default.post(name: Notification.Name("SessionTokenExpired"), object: nil)
            throw NSError(domain: "com.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Session expired. Login again"])
        }
        userDetail = try container.decode(T.self, forKey: .userDetail)
    }
}

class StatusResponse: Codable {
    var status: Bool = false
    var tokenValid: Bool = true
    var message = ""
    
    enum CodingKeys: CodingKey {
        case status, message, tokenValid
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(String.self, forKey: .status) == "true"
        tokenValid = try container.decodeIfPresent(String.self, forKey: .tokenValid) == "true"
        if !tokenValid {
            NotificationCenter.default.post(name: Notification.Name("SessionTokenExpired"), object: nil)
            throw NSError(domain: "com.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Session expired. Login again"])
        }
        message = try container.decode(String.self, forKey: .message)
    }
}

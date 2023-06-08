//
//  Contact.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/9/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import Foundation

class Contact: BaseObject, Codable {
    
    override static func primaryKey() -> String?
    {
        return "id"
    }
    
    @objc dynamic var id  = "1"
    @objc dynamic var salutation  = ""
    @objc dynamic var firstName   = ""
    @objc dynamic var lastName    = ""
    @objc dynamic var phoneNumber = ""
    @objc dynamic var mobileNumber = ""
    @objc dynamic var email       = ""
    @objc dynamic var physicalAddress: PhysicalAddress?
    
    var userID: String {
        Employee.cached().id
    }
    enum CodingKeys: String, CodingKey {
        case salutation
        case firstName
        case lastName
        case phoneNumber
        case mobileNumber
        case email
        case physicalAddress
    }
    
    func update(completion: @escaping (ServiceResponse<Bool>) -> ()) {
        Router.submit(contact: self).request { (response: ServiceResponse<StatusResponse>) in
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

extension Contact {
    enum Router: Requestable {
        case submit(contact: Contact)
        
        var path: String { "Employee/Update" }
        
        var method: HTTPMethod { .post }

        var parameters: [String : Any] {
            switch self {
            case .submit(let contact):
                guard let physicalAddress = contact.physicalAddress else { return ["":""] }
                return ["userID":contact.userID,"salutation":contact.salutation,"firstName":contact.firstName,"lastName":contact.lastName,"phoneNumber":contact.phoneNumber,"mobileNumber":contact.mobileNumber,"streetAddress":physicalAddress.street,"suburb":physicalAddress.suburb,"postCode":physicalAddress.postcode]
            }
        }
        
    }
}

class PhysicalAddress: BaseObject, Codable {
    
    override static func primaryKey() -> String?
    {
        return "id"
    }
    
    @objc dynamic var id      = ""
    @objc dynamic var street      = ""
    @objc dynamic var suburb      = ""
    @objc dynamic var postcode    = ""
    
    enum CodingKeys: String, CodingKey {
        case street
        case suburb
        case postcode
    }
}

class EmergencyContact: BaseObject, Codable {
    
    override static func primaryKey() -> String?
    {
        return "id"
    }
    @objc dynamic var id      = ""
    @objc dynamic var fullName   = ""
    @objc dynamic var contactNumber = ""
    @objc dynamic var relation = ""
    @objc dynamic var disclosedMedicalCondition = ""
    
    var userId: String {
        Employee.cached().id
    }
    
    enum CodingKeys: String, CodingKey {
        case fullName = "fullname"
        case contactNumber = "contactNumber"
        case relation = "relation"
        case disclosedMedicalCondition = "disclosedMedicalCondition"
    }
    
    func update(completion: @escaping (ServiceResponse<Bool>) -> ()) {
        Router.update(contact: self).request { (response: ServiceResponse<StatusResponse>) in
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

extension EmergencyContact {
    enum Router: Requestable {
        case update(contact: EmergencyContact)
        
        var path: String { "Employee/UpdateEmergency" }
        
        var method: HTTPMethod { .post }
        
        var parameters: [String : Any] {
            switch self {
            case .update(let contact):
                return ["userID":contact.userId,"name":contact.fullName,"contactNumber":contact.contactNumber,"relation":contact.relation,"disclosedMedicalCondition":contact.disclosedMedicalCondition]
            }
        }
    }
}

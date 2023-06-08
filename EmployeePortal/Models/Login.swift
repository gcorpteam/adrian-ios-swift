//
//  Login.swift
//  EmployeePortal
//
//  Created by Sajeev on 1/9/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import Foundation

class Login {
    var username = ""
    var password = ""
}

extension Login {
    enum Router: Requestable {
        case login(login: Login)
        
        var path: String {
            return ""
        }
        
        var parameters: [String: Any] {
            switch self {
            case .login(let login):
                return ["username": login.username, "password": login.password]
            }
        }
    }
}

extension Login {
    static func login(login: Login,completion: @escaping (ServiceResponse<Employee>) -> ()) {
        Router.login(login: login).request {  (response: ServiceResponse<Employee>) in
            switch response {
            case .success(let result):
                    completion(.success(data: result))
            case .failure(let error):
                completion(.failure(error: error))
            case .finally:
                completion(.finally)
            }
        }
    }
}

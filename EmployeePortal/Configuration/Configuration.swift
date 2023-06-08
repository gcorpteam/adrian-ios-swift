//
//  Configuration.swift
//  EmployeePortal
//
//  Created by Sajeev on 2/13/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import Foundation

class Configuration {
    static let current = Configuration()
    let httpsProtocol = "https://"
    typealias JSON = [String: Any]

    private init() {
           // load all configurations one time
           all = Bundle.main.infoDictionary?["Configuration"] as? JSON ?? [:]
    }
    
    // All configuration keys from info Plist
    var all = JSON()

    var websiteUrl: String {
        guard let urlString = all["websiteUrl"] as? String else {
            fatalError("Couldn't load websiteUrl from configuration file")
        }
        return httpsProtocol + urlString
    }
    
    var forgotPasswordURL: String {
        guard let forgotPasswordURLString = all["forgotPasswordURL"] as? String else {
            fatalError("Couldn't load forgotPasswordURL from configuration file")
        }
        return httpsProtocol + forgotPasswordURLString
    }
    
    var baseUrl: String {
        guard let baseUrlString = all["baseUrl"] as? String else {
            fatalError("Couldn't load baseUrl from configuration file")
        }
        return httpsProtocol + baseUrlString
    }
    
    var authenticationUrl: String {
        guard let authenticationUrlString = all["authenticationUrl"] as? String else {
            fatalError("Couldn't load authenticationUrl from configuration file")
        }
        return httpsProtocol + authenticationUrlString
    }
}

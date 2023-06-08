//
//  Requestable.swift
//  CurrencyConverter
//
//  Created by sajeev Raj on 7/18/19.
//  Copyright © 2019 Sajeev. All rights reserved.
//

import Foundation

enum ServiceResponse<T: Codable> {
    case success(data: T)
    case failure(error: Error)
    case finally
}

// protocol for parameters and path
protocol Requestable {
    
    // url path
    var path: String { get }
    
    // required parameters
    var parameters: [String: Any] { get }
    
    // http method
    var method: HTTPMethod { get }
    
    // type of parsing required
    var responseParserType: ResponseParserType { get }
    
    // url query items
    var queryParameters: [(queryName: String, queryValue: String)]? { get }
    
    // request
    func request<T: Codable>(completion: ServiceResponseBlock<T>?)
}

extension Requestable {
    
    // setting GET by default
    var method: HTTPMethod {
        .get
    }
    
    var responseParserType: ResponseParserType {
        .json
    }

    
    var queryParameters: [(queryName: String, queryValue: String)]? {
        nil
    }
    
    var parameters: [String: Any] {
        [:]
    }
}

extension Requestable {
    func request<T: Codable>(completion: ServiceResponseBlock<T>?) {
        
        var baseUrl: URL?
        if let token = ServiceManager.shared.token, !token.isEmpty, responseParserType == .json {
            baseUrl = ServiceManager.API.baseUrl
        }
        else {
            baseUrl = ServiceManager.API.authenticationUrl
        }
        guard var components = URLComponents(string: baseUrl?.appendingPathComponent(path).absoluteString ?? "") else { return }
        
        // add query items if present
        if (queryParameters?.count ?? 0) > 0 {
            let urlQueryItems = queryParameters!.map{ return URLQueryItem(name: $0.0, value: $0.1) }
            components.queryItems = urlQueryItems
        }
        guard let url = components.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
    
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        // add parameters as body if service has paramters
        if parameters.count > 0 {
            var allParameters = [String: Any]()
            allParameters = parameters
            if let defaultParameter = defaultParameters {
                allParameters = allParameters.merged(with: defaultParameter)
            }
//            print("************************************")
//            print("URL: \(url)")
//
//            print("PARAMETERS: \(allParameters)")
//            print("************************************")

            guard let httpBody = try? JSONSerialization.data(withJSONObject: allParameters, options: [.fragmentsAllowed]) else { return }
            request.httpBody = httpBody
        }
        
        // if services are to be discarded, donot request
        if !ServiceManager.shared.shouldDiscardServices {
            if responseParserType == .json {
                ServiceManager.shared.request(request: request, completion: completion)
            }
            else {
                ServiceManager.shared.requestStringResponse(request: request, completion: completion as? ServiceResponseBlock<String>)
            }
        }
        
    }
    
    var defaultParameters: [String: String]? {
        if let token = ServiceManager.shared.token {
            return ["token": token]
        }
        return nil
    }
}

extension Dictionary {

    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }

    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}



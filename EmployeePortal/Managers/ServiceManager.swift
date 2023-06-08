//
//  ServiceManager.swift
//  CurrencyConverter
//
//  Created by sajeev Raj on 7/18/19.
//  Copyright © 2019 Sajeev. All rights reserved.
//

import Foundation

typealias ServiceResponseBlock<T: Codable> = (ServiceResponse<T>) -> ()

extension String {
    static func response(data: Data) -> String {
        return String(data: data, encoding: .utf8)!
    }
}


class ServiceManager {
    
    static let shared = ServiceManager()
    var dataTask: URLSessionDataTask?
    var shouldDiscardServices: Bool = false
    var token: String? = nil

    private init() {}
    
    func request<T>(request: URLRequest, completion: ServiceResponseBlock<T>?) where T: Codable {
    
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion?(.finally)

            if let error = error {
                completion?(.failure(error: error))
                return
            }
            guard let _ = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                completion?(.failure(error: error))
                return
            }
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]) as? [String: Any] {
                    // try to read out a string array
                    print("************RESPONSE STARTS**************")

                    print(json)

                    print("************RESPONSE ENDS**********")

                }
                
                    let decoder = JSONDecoder()
                    let responseData = try decoder.decode(T.self, from: data)
                    completion?(.success(data: responseData))
            } catch let err {
                print("Err", err)
                completion?(.failure(error: err))
            }
        }.resume()
    }
    
    func requestStringResponse(request: URLRequest, completion: ServiceResponseBlock<String>?) {
        URLCache.shared.removeAllCachedResponses()
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion?(.finally)

            if let error = error {
                completion?(.failure(error: error))
                return
            }
            guard let _ = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                completion?(.failure(error: error))
                return
            }
            
            // Try mapping to json for error scenario
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(json)
                let decoder = JSONDecoder()
                if let responseData = try? decoder.decode(BaseResponse.self, from: data) {
                    let errorString = responseData.Message ?? "Service not responding"
                    let error = NSError(domain: errorString, code: 0, userInfo: [NSLocalizedDescriptionKey: errorString])
                    completion?(.failure(error: error))
                }
            } else {
                do {
                    // if string then accept as token
                    let responseData = String.response(data: data)
                    print(responseData)
                    completion?(.success(data: responseData))
                }
            }
        }.resume()
        
    }
    
    
    func cancelAllRequests() {
        shouldDiscardServices = true
    }
    
    func resume() {
        shouldDiscardServices = false
    }
}

extension ServiceManager {
    struct API {
        static var baseUrl: URL? {
            return URL(string: Configuration.current.baseUrl)
        }
        
        static var authenticationUrl: URL? {
            return URL(string: Configuration.current.authenticationUrl)
          }
    }
}

enum HTTPMethod: String {
    case get
    case post
    case update
    case delete
}

enum ResponseParserType {
    case json
    case string
}

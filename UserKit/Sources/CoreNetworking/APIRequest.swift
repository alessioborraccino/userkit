//
//  APIRequest.swift
//  UserKit
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case get = "GET"
    case delete = "DELETE"
}

protocol APIRequest {
    var endpoint: APIEndpoint { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
}

extension APIRequest {
    var body: Data? {
        return nil
    }
}

extension APIRequest {
    
    var jsonUrlRequest: URLRequest? {
        guard let url = endpoint.url else {
            fatalError("It should always create a url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

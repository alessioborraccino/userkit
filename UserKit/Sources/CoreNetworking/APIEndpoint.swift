//
//  APIEndpoint.swift
//  UserKit
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

protocol APIEndpoint {
    var scheme: String { get }
    var baseUrl: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

extension APIEndpoint {
    
    var scheme: String {
        return "https"
    }
    
    var baseUrl: String {
        return "jsonplaceholder.typicode.com"
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}

extension APIEndpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = baseUrl
        components.path = "/" + path
        components.queryItems = queryItems
        return components.url
    }
}


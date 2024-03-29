//
//  APIClient.swift
//  UserKit
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import Foundation

enum APIError: Error, Equatable {
    case noResourceFound
    case couldNotParseResult
    case connectionError(NSError)
}

protocol APIClient {
    func start<Model: Decodable>(_ request: APIRequest, resource: Model.Type, completion: @escaping (Result<Model, APIError>) -> Void) -> CancellableToken
}

final class UserKitAPIClient: APIClient {
    
    private let session: URLSessionProtocol
    
    convenience init() {
        self.init(session: URLSession.shared)
    }
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    @discardableResult func start<Model: Decodable>(_ request: APIRequest, resource: Model.Type = Model.self, completion: @escaping (Result<Model, APIError>) -> Void) -> CancellableToken {
        
        guard let urlRequest = request.jsonUrlRequest else {
            fatalError("Should always get a urlRequest")
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            switch (data, response, error) {
            case (let data?, let response?, nil):
                
                guard let response = response as? HTTPURLResponse else {
                    fatalError("Should always be a httpUrlResponse")
                }
                
                guard response.statusCode != 404 else {
                    completion(.failure(APIError.noResourceFound))
                    return
                }
                
                guard let model = try? Model.decodeAsJson(from: data) else {
                    completion(.failure(APIError.couldNotParseResult))
                    return
                }
                completion(.success(model))
                
            case (nil, _, let error?):
                completion(.failure(APIError.connectionError(error as NSError)))
            default:
                break
            }
        }
        task.resume()
        return task
    }
}

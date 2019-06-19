//
//  APIClientMock.swift
//  UserKitTests
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

@testable import UserKit

final class APIClientMock {
    private(set) var didCallStart = false
    private(set) var lastRequest: APIRequest?
    private(set) var lastCompletion: Any?
}

// MARK: - ClientProtocol

extension APIClientMock: APIClient {
    
    func start<Model>(_ request: APIRequest, resource: Model.Type, completion: @escaping (Result<Model, APIError>) -> Void) -> CancellableToken where Model : Decodable  {
        didCallStart = true
        lastRequest = request
        lastCompletion = completion
        return CancellableTokenMock()
    }
}

//
//  UserRepository.swift
//  UserKit
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import Foundation

public final class UserRepository {
    
    private let apiClient: APIClient
    
    init(client: APIClient) {
        self.apiClient = client
    }
    
    public convenience init() {
        self.init(client: UserKitAPIClient())
    }
}

public extension UserRepository {
    func getUsers(completion: @escaping (_ result: Result<[User], UserKitError>) -> Void) {
        return apiClient.start(GetUsersRequest(), resource: [User].self) { result in
            let result = result.mapError({UserKitError.make(from: $0)})
            completion(result)
        }
    }
    
    func getUser(identifiedBy identifier: Int, completion: @escaping (_ result: Result<User, UserKitError>) -> Void) {
        return apiClient.start(GetUserRequest(userIdentifier: identifier), resource: User.self) { result in
            let result = result.mapError({UserKitError.make(from: $0)})
            completion(result)
        }
    }
}

// MARK: - Requests
extension UserRepository {
    struct GetUsersRequest: APIRequest {
        let endpoint: APIEndpoint = UserEndpoint()
        let method = HTTPMethod.get
    }
    
    struct GetUserRequest: APIRequest {
        let userIdentifier: Int
        var endpoint: APIEndpoint {
            return UserEndpoint(userIdentifier: userIdentifier)
        }
        let method = HTTPMethod.get
    }
}

// MARK: - Resource
private extension UserRepository {
    
    struct UserEndpoint: APIEndpoint {
        
        private static let path = "users"
        
        let userIdentifier: Int?
        
        var path: String {
            var path = UserEndpoint.path
            if let userIdentifier = userIdentifier {
                path.append("/\(userIdentifier)")
            }
            return path
        }
        
        init(userIdentifier: Int? = nil) {
            self.userIdentifier = userIdentifier
        }
    }
}

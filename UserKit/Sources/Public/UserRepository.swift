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
}

// MARK: - Requests
extension UserRepository {
    struct GetUsersRequest: APIRequest {
        typealias Resource = [User]
        let resource: APIEndpoint = UserResource()
        let method = HTTPMethod.get
    }
}

// MARK: - Resource
private extension UserRepository {
    
    struct UserResource: APIEndpoint {
        
        private static let path = "users"
        
        var path: String {
            return UserResource.path
        }
    }
}

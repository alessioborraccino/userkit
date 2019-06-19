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

// MARK: - Public Methods
public extension UserRepository {
    func getUsers(completion: @escaping (_ result: Result<[User], UserKitError>) -> Void) {
        apiClient.start(GetUsersRequest(), resource: [User].self) { result in
            let result = result.mapError({UserKitError.make(from: $0)})
            completion(result)
        }
    }
    
    func getUser(identifiedBy identifier: Int, completion: @escaping (_ result: Result<User, UserKitError>) -> Void) {
        apiClient.start(GetUserRequest(userIdentifier: identifier), resource: User.self) { result in
            let result = result.mapError({UserKitError.make(from: $0, forUserIdentifiedBy: identifier)})
            completion(result)
        }
    }
    
    func deleteUser(identifiedBy identifier: Int, completion: @escaping (_ result: Result<Void, UserKitError>) -> Void) {
        apiClient.start(DeleteUserRequest(userIdentifier: identifier), resource: CodableVoid.self) { result in
            let result = result
                .map { $0.void }
                .mapError {UserKitError.make(from: $0, forUserIdentifiedBy: identifier)}
            completion(result)
        }
    }
    
    func createUser(like newUser: User, completion: @escaping (_ result: Result<User, UserKitError>) -> Void)  {
        apiClient.start(CreateUserRequest(newUser: newUser), resource: User.self) { result in
            let result = result.mapError({UserKitError.make(from: $0)})
            completion(result)
        }
    }
    
    func updateUser(identifiedBy identifier: Int, to updatedUser: User, completion: @escaping (_ result: Result<User, UserKitError>) -> Void) {
        
        let identifiedUser = updatedUser.identified(by: identifier)
        apiClient.start(UpdateUserRequest(updatedUser: identifiedUser), resource: User.self) { result in
            let result = result.mapError({UserKitError.make(from: $0, forUserIdentifiedBy: identifier)})
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
    
    struct DeleteUserRequest: APIRequest {
        let userIdentifier: Int
        var endpoint: APIEndpoint {
            return UserEndpoint(userIdentifier: userIdentifier)
        }
        let method = HTTPMethod.delete
    }
    
    struct CreateUserRequest: APIRequest {
        typealias Resource = User
        
        let newUser: User
        let endpoint: APIEndpoint = UserEndpoint()
        let method = HTTPMethod.post
        var body: Data? {
            return try? newUser.encodeAsJson()
        }
    }
    
    struct UpdateUserRequest: APIRequest {
        typealias Resource = User
        
        let updatedUser: User
        var endpoint: APIEndpoint {
            return UserEndpoint(userIdentifier: updatedUser.identifier)
        }
        let method = HTTPMethod.put
        var body: Data? {
            return try? updatedUser.encodeAsJson()
        }
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

// MARK: - Void Helper
struct CodableVoid: Codable {
    var void: Void { return () }
}

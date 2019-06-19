//
//  UserRepository.swift
//  UserKit
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import Foundation

/// Class used to access all the user related functions in UserKit service
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
    
    /**
     Returns all the users registered from the UserKit Service.
     
     - Parameters:
        - completion: The completion handler to call when the request is complete. This handler is executed on a background thread.
        - result: Either contains an array of Users, or a UserKitError. Error is either .connectionError or .generic.
     - Returns:
        A token which can be used to cancel the request, by calling cancel().
     */
    @discardableResult func getUsers(completion: @escaping (_ result: Result<[User], UserKitError>) -> Void) -> CancellableToken {
        return apiClient.start(GetUsersRequest(), resource: [User].self) { result in
            let result = result.mapError({UserKitError.make(from: $0)})
            completion(result)
        }
    }
    
    /**
     Returns the user with the given identifier from the UserKit Service.
     
     - Parameters:
        - identifier: The identifier of the User to retrieve
        - completion: The completion handler to call when the request is complete. This handler is executed on a background thread
        - result: Either contains the retrieved User, or a UserKitError. Error could be .generic, .connectionError or .userNotFound
     - Returns:
        A token which can be used to cancel the request, by calling cancel().
     */
    @discardableResult func getUser(identifiedBy identifier: Int, completion: @escaping (_ result: Result<User, UserKitError>) -> Void) -> CancellableToken {
        return apiClient.start(GetUserRequest(userIdentifier: identifier), resource: User.self) { result in
            let result = result.mapError({UserKitError.make(from: $0, forUserIdentifiedBy: identifier)})
            completion(result)
        }
    }
    
    /**
     Delete the user with the given identifier from the UserKit Service.
     
     - Parameters:
        - completion: The completion handler to call when the request is complete. This handler is executed on a background thread.
        - result: Returns Void when successful, or a UserKitError. Error is either .generic, .connectionError or .userNotFound
     - Returns:
        A token which can be used to cancel the request, by calling cancel().
     */
    @discardableResult func deleteUser(identifiedBy identifier: Int, completion: @escaping (_ result: Result<Void, UserKitError>) -> Void) -> CancellableToken {
        return apiClient.start(DeleteUserRequest(userIdentifier: identifier), resource: CodableVoid.self) { result in
            let result = result
                .map { $0.void }
                .mapError {UserKitError.make(from: $0, forUserIdentifiedBy: identifier)}
            completion(result)
        }
    }
    
    /**
     Creates and register a new user to the UserKit Service, and returns it with a newly assigned identifier.
     
     - Parameters:
        - newUser: The user which needs to be created
        - completion: The completion handler to call when the request is complete. This handler is executed on a background thread.
        - result: Either contains the new user, or a UserKitError. Error is either .generic, .connectionError, .userIdentifierShouldNotBePresent (Not implemented).
     - Returns:
        A token which can be used to cancel the request, by calling cancel().
     - Attention:
        This call is meant to be used with newly created user from the client, any user with already identifier will return an error (not implemented)
     */
    @discardableResult func createUser(like newUser: User, completion: @escaping (_ result: Result<User, UserKitError>) -> Void) -> CancellableToken {
        return apiClient.start(CreateUserRequest(newUser: newUser), resource: User.self) { result in
            let result = result.mapError({UserKitError.make(from: $0)})
            completion(result)
        }
    }
    
    /**
     Updates the user with the given identifier, if found, mirroring all the data from the updatedUser.
     If successful, the updated user will then have the same data as the updatedUser.
     
     - Parameters:
        - identifier: The identifier of the User to update
        - updatedUser: Contains all the data to update
        - completion: The completion handler to call when the request is complete. This handler is executed on a background thread
        - result: Either contains the updated User, or a UserKitError. Error could be .generic, .offline or .userNotFound
     - Returns:
        A token which can be used to cancel the request.
     - Attention:
        As Implemented now, the call is not able to delete fields, only to add them. (To be implemented)
     */
    @discardableResult func updateUser(identifiedBy identifier: Int, to updatedUser: User, completion: @escaping (_ result: Result<User, UserKitError>) -> Void) -> CancellableToken {
        
        let identifiedUser = updatedUser.identified(by: identifier)
        return apiClient.start(UpdateUserRequest(updatedUser: identifiedUser), resource: User.self) { result in
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

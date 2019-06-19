//
//  UserRepositoryTests.swift
//  UserKitTests
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import XCTest
@testable import UserKit

class UserRepositoryTests: XCTestCase {
    
    private lazy var apiClient = APIClientMock()
    private lazy var userRepository = UserRepository(client: apiClient)
    
    func testGetUserStartsAndReturnsSuccessfully() {
        let expectation = XCTestExpectation(description: "users")
        
        userRepository.getUser(identifiedBy: 1) { [unowned self] (result) in
            XCTAssert(self.apiClient.lastRequest is UserRepository.GetUserRequest, "It uses the right request")
            do {
                let user = try result.get()
                XCTAssertEqual(user.identifier, 1, "It returns the correct identifier")
                XCTAssertEqual(user.name, "Leanne Graham", "It returns the correct name")
                expectation.fulfill()
            } catch {
                XCTFail()
            }
        }
        
        let clientCompletion = apiClient.lastCompletion as? (Result<User, APIError>) -> Void
        clientCompletion?(.success(UserFixtureFactory.usersFromFile[0]))
        let waiterResult = XCTWaiter.wait(for: [expectation], timeout: 3)
        XCTAssert(waiterResult == .completed)
    }
    
    func testGetUserStartsAndReturnsWithFailure() {
        let expectation = XCTestExpectation(description: "users")
        userRepository.getUser(identifiedBy: 1) { [unowned self] (result) in
            XCTAssert(self.apiClient.lastRequest is UserRepository.GetUserRequest)
            do {
                _ = try result.get()
            } catch {
                XCTAssert((error as? UserKitError) == UserKitError.noUserFound(identifier: 1))
                expectation.fulfill()
            }
        }
        
        let clientCompletion = apiClient.lastCompletion as? (Result<User, APIError>) -> Void
        clientCompletion?(.failure(APIError.noResourceFound))
        let waiterResult = XCTWaiter.wait(for: [expectation], timeout: 3)
        XCTAssert(waiterResult == .completed)
    }
}

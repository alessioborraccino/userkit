//
//  UserKitTests.swift
//  UserKitTests
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import XCTest
@testable import UserKit

class _UserRepositoryPlaygroundTests: XCTestCase {

    private let userRepository = UserRepository()
    
    func testGetUsers() {
        let expectation = XCTestExpectation(description: "get-users")
        userRepository.getUsers { (result) in
            switch result {
            case .success(let users):
                XCTAssertEqual(users.count, 10, "It retrieves and parses all the users")
                expectation.fulfill()
            case .failure:
                XCTFail("Should work")
            }
        }
        let waiterResult = XCTWaiter.wait(for: [expectation], timeout: 2)
        XCTAssert(waiterResult == .completed)
    }
    
    func testGetExistingUser() {
        let expectation = XCTestExpectation(description: "get-user-2")
        userRepository.getUser(identifiedBy: 2) { (result) in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Should work")
            }
        }
        let waiterResult = XCTWaiter.wait(for: [expectation], timeout: 3)
        XCTAssert(waiterResult == .completed)
    }
    
    func testGetNonExistingUser() {
        let expectation = XCTestExpectation(description: "users")
        userRepository.getUser(identifiedBy: 23) { (result) in
            switch result {
            case .success:
                XCTFail("Should return no found error")
            case .failure(let error):
                XCTAssert(error == UserKitError.noUserFound(identifier: 23))
                expectation.fulfill()
            }
        }
        let waiterResult = XCTWaiter.wait(for: [expectation], timeout: 3)
        XCTAssert(waiterResult == .completed)
    }
    
    func testDeleteExistingUser() {
        let expectation = XCTestExpectation(description: "delete-user-3")
        userRepository.deleteUser(identifiedBy: 3) { (result) in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Should work")
            }
        }
        let waiterResult = XCTWaiter.wait(for: [expectation], timeout: 3)
        XCTAssert(waiterResult == .completed)
    }
    
    func testCreateNewUser() {
        let expectation = XCTestExpectation(description: "users")
        let user = User(name: "Alessio Borraccino", email: "email@email.com", userName: "mm")
        userRepository.createUser(like: user) { (result) in
            switch result {
            case .success(let user):
                XCTAssert(user.name == "Alessio Borraccino")
                XCTAssert(user.email == "email@email.com")
                XCTAssert(user.identifier != nil)
                expectation.fulfill()
            case .failure:
                XCTFail("Should work")
            }
        }
        let waiterResult = XCTWaiter.wait(for: [expectation], timeout: 3)
        XCTAssert(waiterResult == .completed)
    }
    
    func testUpdateExistingUser() {
        let expectation = XCTestExpectation(description: "users")
        let user = User(name: "Alessio Borraccino", email: "email@email.com", userName: "Samantha")
        userRepository.updateUser(identifiedBy: 3, to: user) { (result) in
            switch result {
            case .success(let user):
                XCTAssert(user.identifier == 3)
                XCTAssert(user.name == "Alessio Borraccino")
                XCTAssert(user.email == "email@email.com")
                expectation.fulfill()
            case .failure:
                XCTFail("Should work")
            }
        }
        let waiterResult = XCTWaiter.wait(for: [expectation], timeout: 3)
        XCTAssert(waiterResult == .completed)
    }
    
    func testUpdateNonExistingUser() {
        let expectation = XCTestExpectation(description: "users")
        let user = User(name: "Alessio Borraccino", email: "email@email.com", userName: "Samantha")
        userRepository.updateUser(identifiedBy: 23, to: user) { (result) in
            switch result {
            case .success:
                XCTFail("Should return error")
            case .failure(let error):
                //Updating a non existing user returns generic error because the backend crashes 
                XCTAssert(error == UserKitError.generic)
                expectation.fulfill()
            }
        }
        let waiterResult = XCTWaiter.wait(for: [expectation], timeout: 3)
        XCTAssert(waiterResult == .completed)
    }
}

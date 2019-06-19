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
        let expectation = XCTestExpectation(description: "users")
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
        let expectation = XCTestExpectation(description: "users")
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
}

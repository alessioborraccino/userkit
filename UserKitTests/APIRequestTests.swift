//
//  APIRequestTests.swift
//  UserKitTests
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import XCTest
@testable import UserKit

final class APIRequestTest: XCTestCase {
    
    func testGetUsersRequest() {
        let request = UserRepository.GetUsersRequest()
        
        let jsonUrlRequest = request.jsonUrlRequest
        XCTAssertNotNil(jsonUrlRequest, "It generates a url Request")
        XCTAssertEqual(jsonUrlRequest?.url?.absoluteString, "https://jsonplaceholder.typicode.com/users", "It has the correct url")
        XCTAssertEqual(jsonUrlRequest?.httpMethod, "GET", "It has the correct method")
        XCTAssertNil(jsonUrlRequest?.httpBody, "It has no body")
    }
    
    func testGetUserRequest() {
        let request = UserRepository.GetUserRequest(userIdentifier: 5)
        
        let jsonUrlRequest = request.jsonUrlRequest
        XCTAssertNotNil(jsonUrlRequest, "It generates a url Request")
        XCTAssertEqual(jsonUrlRequest?.url?.absoluteString, "https://jsonplaceholder.typicode.com/users/5", "It has the correct url")
        XCTAssertEqual(jsonUrlRequest?.httpMethod, "GET", "It has the correct method")
        XCTAssertNil(jsonUrlRequest?.httpBody, "It has no body")
    }
    
    func testCreateUserRequest() {
        let newUser = User(name: "Alessio", email: "alessio@email.com", userName: "alessio")
        let request = UserRepository.CreateUserRequest(newUser: newUser)
        
        let jsonUrlRequest = request.jsonUrlRequest
        XCTAssertNotNil(jsonUrlRequest, "It generates a url Request")
        
        XCTAssertEqual(jsonUrlRequest?.url?.absoluteString, "https://jsonplaceholder.typicode.com/users", "It has the correct url")
        XCTAssertEqual(jsonUrlRequest?.httpMethod, "POST", "It has the correct method")
        XCTAssertNotNil(jsonUrlRequest?.httpBody, "It has a body")
        
        let json = try? JSONSerialization.jsonObject(with: jsonUrlRequest!.httpBody!, options: .allowFragments) as? [String: Any]
        XCTAssertEqual(json?["name"] as? String, "Alessio", "It has correct name parameter in the body")
        XCTAssertEqual(json?["email"]  as? String, "alessio@email.com", "It has correct email parameter in the body")
        XCTAssertEqual(json?["username"]  as? String, "alessio", "It has correct username parameter in the body")
    }
}

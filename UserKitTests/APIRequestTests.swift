//
//  APIRequestTests.swift
//  UserKitTests
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import XCTest
@testable import UserKit
import CoreLocation.CLLocation

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
        let address = Address(street: "Street",
                              suite: "Suite",
                              city: "City",
                              zipCode: "00138",
                              coordinates: CLLocationCoordinate2D(latitude: 45.55,
                                                                  longitude: 50.55))
        let company = Company(name: "Company",
                              catchPhrase: "Catchy",
                              bs: "What bs")
        let newUser = User(name: "Alessio",
                           email: "alessio@email.com",
                           userName: "alessio",
                           address: address,
                           company: company)
        let request = UserRepository.CreateUserRequest(newUser: newUser)
        
        let jsonUrlRequest = request.jsonUrlRequest
        XCTAssertNotNil(jsonUrlRequest, "It generates a url Request")
        
        XCTAssertEqual(jsonUrlRequest?.url?.absoluteString, "https://jsonplaceholder.typicode.com/users", "It has the correct url")
        XCTAssertEqual(jsonUrlRequest?.httpMethod, "POST", "It has the correct method")
        XCTAssertNotNil(jsonUrlRequest?.httpBody, "It has a body")
        
        let json = try? JSONSerialization.jsonObject(with: jsonUrlRequest!.httpBody!, options: .allowFragments) as? [String: Any]
        XCTAssertEqual(json?["name"] as? String, "Alessio", "It has correct name parameter in the body")
        XCTAssertEqual(json?["email"]  as? String, "alessio@email.com", "It has correct email parameter in the body")
        XCTAssertEqual(json?["username"] as? String, "alessio", "It has correct username parameter in the body")
        
        let addressJson = json?["address"] as? [String: Any]
        XCTAssertNotNil(addressJson, "It has an address parameter in the body")
        XCTAssertEqual(addressJson?["street"] as? String, "Street", "It has correct street parameter in the address body")
        XCTAssertEqual(addressJson?["suite"]  as? String, "Suite", "It has correct suite parameter in the address body")
        XCTAssertEqual(addressJson?["city"] as? String, "City", "It has correct city parameter in the address body")
        XCTAssertEqual(addressJson?["zipcode"] as? String, "00138", "It has correct zipcode parameter in the address body")
        
        let geoJson = addressJson?["geo"] as? [String: Any]
        XCTAssertNotNil(geoJson, "It has a coordinates parameter in the address body")
        XCTAssertEqual(geoJson?["lat"] as? String, "45.55", "It has correct latitude parameter in the coordinates body")
        XCTAssertEqual(geoJson?["lng"] as? String, "50.55", "It has correct longitude parameter in the coordinates body")
        
        let companyJson = json?["company"] as? [String: Any]
        XCTAssertNotNil(companyJson, "It has a company parameter in the body")
        XCTAssertEqual(companyJson?["name"] as? String, "Company", "It has correct name parameter in the company body")
        XCTAssertEqual(companyJson?["catchPhrase"]  as? String, "Catchy", "It has correct catchPhrase parameter in the company body")
        XCTAssertEqual(companyJson?["bs"] as? String, "What bs", "It has correct bs parameter in the company body")
    }
}

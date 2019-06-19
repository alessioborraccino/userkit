//
//  APIClientTests.swift
//  UserKitTests
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import XCTest
@testable import UserKit

final class APIClientTest: XCTestCase {
    
    private lazy var urlSessionMock = URLSessionMock()
    private lazy var client = UserKitAPIClient(session: urlSessionMock)
    
    func testStartCalled() {
        let request = UserRepository.GetUsersRequest()
        client.start(request, completion: { (result: Result<[User], APIError>) in })
        XCTAssertEqual(urlSessionMock.lastRequest, request.jsonUrlRequest, "It creates a data task with the correct request")
        XCTAssertTrue(urlSessionMock.lastReturnedDataTask!.didCallResume, "It resumes the data task")
    }
    
    func testStartReturnsCorrectData() {
        let expectation = XCTestExpectation(description: "users")
        let request = UserRepository.GetUsersRequest()
        let mockedData = UserFixtureFactory.usersDataFromFile!
        let mockedUrlResponse = HTTPURLResponse(url: request.jsonUrlRequest!.url!,
                                                statusCode: 200,
                                                httpVersion: nil,
                                                headerFields: nil)
        client.start(request, completion: { (result: Result<[User], APIError>) in
            XCTAssertEqual((try? result.get())?.count, 10, "It returns the correct number of users")
            expectation.fulfill()
        })
        
        urlSessionMock.lastCompletionHandler?(mockedData, mockedUrlResponse, nil)
        let waiterResult = XCTWaiter.wait(for: [expectation], timeout: 3)
        XCTAssertEqual(waiterResult, .completed, "It fulfills the expectation")
    }
    
    func testStartReturnsCorruptedData() {
        let expectation = XCTestExpectation(description: "users")
        let request = UserRepository.GetUsersRequest()
        let mockedData = UserFixtureFactory.corruptedUsersDataFromFile!
        let mockedUrlResponse = HTTPURLResponse(url: request.jsonUrlRequest!.url!,
                                                statusCode: 200,
                                                httpVersion: nil,
                                                headerFields: nil)
        client.start(request, completion: { (result: Result<[User], APIError>) in
            do {
                let _ = try result.get()
            } catch {
                XCTAssertEqual(error as? APIError, APIError.couldNotParseResult, "It returns the correct error")
                expectation.fulfill()
            }
        })
        
        urlSessionMock.lastCompletionHandler?(mockedData, mockedUrlResponse, nil)
        let waiterResult = XCTWaiter.wait(for: [expectation], timeout: 3)
        XCTAssertEqual(waiterResult, .completed, "It fulfills the expectation")
    }
    
    func testStartReturnsConnectionError() {
        let expectation = XCTestExpectation(description: "users")
        let request = UserRepository.GetUsersRequest()
        let mockedError = NSError(domain: NSURLErrorDomain, code: NSURLErrorServerCertificateNotYetValid)
        client.start(request, completion: { (result: Result<[User], APIError>) in
            do {
                let _ = try result.get()
            } catch {
                XCTAssertEqual(error as? APIError, APIError.connectionError(mockedError), "It returns the correct error")
                expectation.fulfill()
            }
        })
        
        urlSessionMock.lastCompletionHandler?(nil, nil, mockedError)
        let waiterResult = XCTWaiter.wait(for: [expectation], timeout: 3)
        XCTAssertEqual(waiterResult, .completed, "It fulfills the expectation")
    }
    
    func testStartReturnsNoResourceFoundError() {
        let expectation = XCTestExpectation(description: "users")
        let request = UserRepository.GetUserRequest(userIdentifier: 3)
        let mockedData = Data()
        let mockedUrlResponse = HTTPURLResponse(url: request.jsonUrlRequest!.url!,
                                                statusCode: 404,
                                                httpVersion: nil,
                                                headerFields: nil)
        client.start(request, completion: { (result: Result<[User], APIError>) in
            do {
                let _ = try result.get()
            } catch {
                XCTAssertEqual(error as? APIError, APIError.noResourceFound, "It returns the correct error")
                expectation.fulfill()
            }
        })
        
        urlSessionMock.lastCompletionHandler?(mockedData, mockedUrlResponse, nil)
        let waiterResult = XCTWaiter.wait(for: [expectation], timeout: 3)
        XCTAssertEqual(waiterResult, .completed, "It fulfills the expectation")
    }
}



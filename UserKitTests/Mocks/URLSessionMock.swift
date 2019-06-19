//
//  URLSessionMock.swift
//  UserKitTests
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import Foundation
@testable import UserKit

final class URLSessionMock {
    private(set) var lastRequest: URLRequest?
    private(set) var lastCompletionHandler: DataTaskResult?
    private(set) var lastReturnedDataTask: URLSessionDataTaskMock?
}

extension URLSessionMock: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask {
        let dataTaskMock = URLSessionDataTaskMock()
        
        lastRequest = request
        lastCompletionHandler = completionHandler
        lastReturnedDataTask = dataTaskMock
        
        return dataTaskMock
    }
}


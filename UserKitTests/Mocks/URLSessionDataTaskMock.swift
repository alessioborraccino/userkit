//
//  URLSessionDataTaskMock.swift
//  UserKitTests
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import Foundation

final class URLSessionDataTaskMock: URLSessionDataTask {
    
    private (set) var didCallResume = false
    
    override func resume() {
        didCallResume = true
    }
}

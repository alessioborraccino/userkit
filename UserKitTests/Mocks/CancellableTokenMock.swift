//
//  CancellableTokenMock.swift
//  UserKitTests
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import Foundation
import UserKit

final class CancellableTokenMock: CancellableToken {
    private(set) var didCallCancel: Bool  = false
    func cancel() {
        didCallCancel = true
    }
}


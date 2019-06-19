//
//  CancellableToken.swift
//  UserKit
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import Foundation

/// Used to cancel any request. Returned by all the methods called from UserRepository
public protocol CancellableToken {
    func cancel()
}

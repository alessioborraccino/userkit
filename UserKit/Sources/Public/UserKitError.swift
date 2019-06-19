//
//  UserKitError.swift
//  UserKit
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import Foundation

public enum UserKitError: Error {
    case generic 
}

extension UserKitError {
    static func make(from apiError: APIError) -> UserKitError {
        return .generic 
    }
}

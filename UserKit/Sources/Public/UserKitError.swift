//
//  UserKitError.swift
//  UserKit
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import Foundation

public enum UserKitError: Error, Equatable {
    case noUserFound(identifier: Int)
    case connectionError(NSError)
    case generic
    
    public var localizedDescription: String {
        switch self {
        case .noUserFound(let identifier):
            return "No user was found with identifier: \(identifier)"
        case .connectionError(let error):
            return error.localizedDescription
        case .generic:
            return "Something went wrong, please contact support."
        }
    }
}

extension UserKitError {
    static func make(from apiError: APIError, forUserIdentifiedBy userIdentifier: Int? = nil) -> UserKitError {
        switch (apiError, userIdentifier) {
        case (.connectionError(let nsError), _):
            return .connectionError(nsError)
        case (.couldNotParseResult, _), (.noResourceFound, nil):
            return .generic
        case (.noResourceFound, let userIdentifier?):
            return .noUserFound(identifier: userIdentifier)
        }
    }
}

//
//  User.swift
//  UserKit
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import Foundation

public struct User {
    public let identifier: Int?
    public let name: String
    public let email: String
    public let userName: String
    public let phone: String?
    public let website: String?
}

extension User: Codable {
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case email
        case userName = "username"
        case phone
        case website
    }
}


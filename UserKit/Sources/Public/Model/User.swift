//
//  User.swift
//  UserKit
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import Foundation

public struct User {
    public private(set) var identifier: Int?
    public let name: String
    public let email: String
    public let userName: String
    public let phone: String?
    public let website: String?
    public let address: Address?
    public let company: Company?
}

extension User {
    public init(name: String, email: String, userName: String,
                phone: String? = nil,
                website: String? = nil,
                address: Address? = nil,
                company: Company? = nil) {
        self.identifier = nil
        self.name = name
        self.email = email
        self.userName = userName
        self.phone = phone
        self.website = website
        self.address = address
        self.company = company
    }
    
    func identified(by identifier: Int) -> User {
        var user = self
        user.identifier = identifier
        return user
    }
}

extension User: Codable {
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case email
        case userName = "username"
        case phone
        case website
        case address
        case company
    }
}




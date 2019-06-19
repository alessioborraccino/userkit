//
//  User.swift
//  UserKit
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import Foundation


/// User is the main resource of UserKit.
/// The identifier is meant to be only assigned by UserKit and never changed from the client.
/// A new user created from the client, will have no identifier until CreateUser gets called, which will return the identifier.
/// As assumption, a user will always have from creation name, email and username. Everyting else can be added later.
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




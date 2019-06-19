//
//  Company.swift
//  UserKit
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import Foundation

public struct Company {
    public let name: String?
    public let catchPhrase: String?
    public let bs: String?
}

extension Company: Codable {}

//
//  Codable.swift
//  UserKit
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import Foundation

extension Decodable {
    static func decodeAsJson(from: Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: from)
    }
}

extension Encodable {
    func encodeAsJson() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
}

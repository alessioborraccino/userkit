//
//  UserFixtureFactory.swift
//  UserKitTests
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import Foundation

final class UserFixtureFactory {
    static var usersDataFromFile: Data? = {
        guard
            case let bundle = Bundle(for: UserFixtureFactory.self),
            let fileURL = bundle.url(forResource: "users", withExtension: "json"),
            let data = try? Data(contentsOf: fileURL) else {
                return nil
        }
        
        return data
    }()
    
    static var corruptedUsersDataFromFile: Data? = {
        guard
            case let bundle = Bundle(for: UserFixtureFactory.self),
            let fileURL = bundle.url(forResource: "users-corrupt", withExtension: "json"),
            let data = try? Data(contentsOf: fileURL) else {
                return nil
        }
        
        return data
    }()
}

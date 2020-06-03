//
//  CredentialsService.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 24/05/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import Foundation

protocol CredentialsService {
    func checkCredentials(login: String, password: String) -> Bool
    func saveLast(login: String)
    func getLastLogin() -> String
}

final class CredentialsServiceImpl: CredentialsService {
    enum KeychainKey: String {
        case lastLogin
    }

    private let storage = SharedKeychainStorageImpl(groupName: "group.lexpenz.PureSwift")
    
    private let allowedCredentials = [
        "User1": "Password1",
        "user2": "password2",
        "user3": "password3",
    ]

    func checkCredentials(login: String, password: String) -> Bool {
        if allowedCredentials.keys.contains(login) {
            if allowedCredentials[login] == password {
                return true
            }
        }
        return false
    }

    func saveLast(login: String) {
        try? storage.save(string: login, for: KeychainKey.lastLogin.rawValue)
    }

    func getLastLogin() -> String {
        return (try? storage.loadString(for: KeychainKey.lastLogin.rawValue)) ?? ""
    }
}

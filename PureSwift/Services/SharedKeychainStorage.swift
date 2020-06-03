//
//  SharedKeychainStorage.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 02/06/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import Foundation

public protocol Storage {
    func save(string: String?, for key: String) throws
    func loadString(for key: String) throws -> String
}

public enum StorageError: Error {
    case noData
    case notConvertibleToData
    case saveError
}

public indirect enum StorageType {
    case sharedKeychain

    public var name: String {
        switch self {
        case .sharedKeychain:
            return "sharedKeychain"
        }
    }
}

final class SharedKeychainStorageImpl: Storage {

    private let groupName: String
    private var dataEncoder = JSONEncoder()
    private var dataDecoder = JSONDecoder()

    init(groupName: String) {
        self.groupName = groupName
    }

    func save(data: Data?, for key: String) throws {
        delete(for: key)
        if let data = data {
            let keychainQuery = makeSaveQuery(for: key, data: data)
            try save(query: keychainQuery)
        }
    }

    func save(string: String?, for key: String) throws {
        delete(for: key)
        if let string = string {
            let data = try convertToData(string)
            try save(data: data, for: key)
        }
    }

    private func makeSaveQuery(for key: String, data: Data) -> CFDictionary {
        return [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessGroup as String: groupName,
        ] as CFDictionary
    }

    private func convertToData(_ string: String) throws -> Data {
        guard let data = string.data(using: .utf8) else {
            throw StorageError.notConvertibleToData
        }

        return data
    }

    private func save(query: CFDictionary) throws {
        if SecItemAdd(query, nil) != noErr {
            throw StorageError.saveError
        }
    }

    func loadData(for key: String) throws -> Data {
        let keychainQuery = makeLoadQuery(for: key)
        return try load(for: keychainQuery)
    }

    func loadString(for key: String) throws -> String {
        let data = try loadData(for: key)
        return try convertToString(data)
    }
    
    private func makeLoadQuery(for key: String) -> CFDictionary {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrAccessGroup as String: groupName as AnyObject,
        ] as CFDictionary
    }

    private func load(for query: CFDictionary) throws -> Data {
        var dataTypeRef: AnyObject?

        let status: OSStatus = SecItemCopyMatching(query, &dataTypeRef)
        if status == noErr, let data = dataTypeRef as? Data {
            return data
        } else {
            throw StorageError.noData
        }
    }

    private func convertToString(_ data: Data) throws -> String {
        guard let string = String(data: data, encoding: .utf8) else {
            throw StorageError.noData
        }

        return string
    }

    func delete(for key: String) {
        let keychainQuery = makeDeleteQuery(for: key)
        SecItemDelete(keychainQuery)
    }

    private func makeDeleteQuery(for key: String) -> CFDictionary {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrAccessGroup as String: groupName,
            kSecAttrSynchronizable as String: kSecAttrSynchronizableAny,
        ] as CFDictionary
    }
}

//
//  Decodable+Extensions.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 24/05/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import Foundation

public extension Decodable {
    /**
     Create an instance of this type from a json string

     - parameter json: The json string
     - parameter keyPath: for if you want something else than the root object
     */
    init(json: String, keyPath: String? = nil) throws {
        guard let data = json.data(using: .utf8) else { throw NSError() }
        try self.init(data: data, keyPath: keyPath)
    }

    /**
     Create an instance of this type from a json dictionary

     - parameter json: The json dictionary
     - parameter keyPath: for if you want something else than the root object
     */
    init(json: [String: Any], keyPath: String? = nil) throws {
        let data = try JSONSerialization.data(withJSONObject: json)
        self = try Constants.jsonDecoder.decode(Self.self, from: data)
    }

    /**
     Create an instance of this type from a json data

     - parameter data: The json data
     - parameter keyPath: for if you want something else than the root object
     */
    init(data: Data, keyPath: String? = nil) throws {
        let decoder = Constants.jsonDecoder

        if let keyPath = keyPath {
            let topLevel = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            guard let nestedJson = (topLevel as AnyObject).value(forKeyPath: keyPath) else { throw NSError() }
            let nestedData = try JSONSerialization.data(withJSONObject: nestedJson)
            self = try decoder.decode(Self.self, from: nestedData)
            return
        }
        self = try decoder.decode(Self.self, from: data)
    }
}

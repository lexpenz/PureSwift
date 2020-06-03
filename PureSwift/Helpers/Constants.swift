//
//  Constants.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 24/05/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import Foundation

struct Constants {

    // MARK: - Decoder

    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()

        return decoder
    }()

    static let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()

        return encoder
    }()
}

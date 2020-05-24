//
//  Movie.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 20/05/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let title: String
    let image: String
    let rating: Double
    let releaseYear: Int
    let genre: [String]
}

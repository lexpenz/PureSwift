//
//  PureSwiftTests.swift
//  PureSwiftTests
//
//  Created by Aleksei Penzentcev on 20/05/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import XCTest
@testable import PureSwift

class PureSwiftTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMovie_decode_succeed() {
        // arrange
        let data = Data("""
        {
            "title": "Dawn of the Planet of the Apes",
            "image": "https://api.androidhive.info/json/movies/1.jpg",
            "rating": 8.3,
            "releaseYear": 2014,
            "genre": ["Action", "Drama", "Sci-Fi"]
        }
        """.utf8)

        let title = "Dawn of the Planet of the Apes"
        let image = "https://api.androidhive.info/json/movies/1.jpg"
        let rating = 8.3
        let releaseYear = 2014
        let genre = ["Action", "Drama", "Sci-Fi"]

        // act
        let decodedMovie = try? JSONDecoder().decode(Movie.self, from: data)

        // assert
        guard let movie = decodedMovie else {
            XCTFail()
            return
        }

        XCTAssertEqual(title, movie.title, "Expected equality")
        XCTAssertEqual(image, movie.image, "Expected equality")
        XCTAssertEqual(rating, movie.rating, "Expected equality")
        XCTAssertEqual(releaseYear, movie.releaseYear, "Expected equality")
        XCTAssertEqual(genre, movie.genre, "Expected equality")
    }

}

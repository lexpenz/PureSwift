//
//  Storage.swift
//  PureSwiftTests
//
//  Created by Aleksei Penzentcev on 03/06/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import XCTest
@testable import PureSwift

class StorageTests: XCTestCase {

    private var storage: Storage!

    override func setUpWithError() throws {
        storage = SharedKeychainStorageImpl(groupName: "group.lexpenz.PureSwift")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStorage_save_loaded() throws {
        // arrange
        let saveString = "test string"

        //act
        try? storage.save(string: saveString, for: "key")
        let resultString = try? storage.loadString(for: "key")

        // assert
        XCTAssertTrue(saveString == resultString, "save string is not equal to the loaded one")
    }

}

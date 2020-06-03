//
//  PureSwiftUITests.swift
//  PureSwiftUITests
//
//  Created by Aleksei Penzentcev on 20/05/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import XCTest

class PureSwiftUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUserLogin_success() throws {
        let app = XCUIApplication()
        app.launch()

        // Enter login
        app.textFields["loginTextField"].typeText("User1")
        app.keyboards.firstMatch.buttons["return"].tap()

        // Enter password
        app.secureTextFields["passwordTextField"].typeText("Password1")
        app.keyboards.firstMatch.buttons["continue"].tap()

        // Should navigate to the list
        XCTAssertTrue(app.otherElements["ListView"].exists, "ListView is not displayed!")
    }
}

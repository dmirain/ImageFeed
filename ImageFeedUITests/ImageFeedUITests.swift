import XCTest

final class ImageFeedUITests: XCTestCase {
    var app: XCUIApplication!

    let login = ""
    let password = ""

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }

    func testAuth() throws {
        app.buttons["enterButton"].tap()

        let webView = app.webViews["webView"]

        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))

        loginTextField.tap()
        loginTextField.typeText(login)
        app.buttons["Done"].tap()
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))

        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))

        passwordTextField.tap()
        passwordTextField.typeText(password)
        app.buttons["Done"].tap()
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        sleep(1)

        webView.webViews.buttons["Login"].tap()

        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)

        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }

    func testFeed() throws {
        let tablesQuery = app.tables

        var cell = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cell.swipeUp(velocity: .slow)
        sleep(4)

        cell = tablesQuery.children(matching: .cell).element(boundBy: 0)

        let likeButton = cell.buttons["likeButton"]

        likeButton.tap()
        sleep(4)

        likeButton.tap()
        sleep(6)

        cell.tap()
        sleep(6)

        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1)
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)

        app.buttons["backButton"].tap()
    }

    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(1)

        let exitButton = app.buttons["exitButton"]

        XCTAssertTrue(exitButton.exists)
        XCTAssertTrue(app.staticTexts["nameLabel"].exists)
        XCTAssertTrue(app.staticTexts["loginLabel"].exists)

        exitButton.tap()

        app.alerts["Alert"].scrollViews.otherElements.buttons["Да"].tap()

        sleep(2)
        XCTAssertTrue(app.buttons["enterButton"].exists)
    }
}

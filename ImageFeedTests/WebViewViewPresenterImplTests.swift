import XCTest
@testable import ImageFeed

final class WebViewViewPresenterTests: XCTestCase {

    var presenter: WebViewViewPresenterImpl!
    var requestHelper: RequestHelperSpy!

    override func setUpWithError() throws {
        requestHelper = RequestHelperSpy()
        presenter = WebViewViewPresenterImpl(requestHelper: requestHelper)
    }

    func testMakeWebViewRequest() throws {
        // when
        let result = presenter.makeWebViewRequest()

        // then
        XCTAssertTrue(requestHelper.makeAuthorizeRequestCalled)
        XCTAssertEqual(result, requestHelper.request)
    }

    func testCalculateProgress() throws {
        // when
        let result = presenter.calculateProgress(for: 0.7)

        // then
        XCTAssertEqual(result.value, Progress(from: 0.7).value)
    }

    func testExtractCode() throws {
        // when
        let result = presenter.extractCode(from: URL(string: "https://ya.ru")!)

        // then
        XCTAssertTrue(requestHelper.extractCodeCalled)
        XCTAssertEqual(result, requestHelper.code)
    }
}

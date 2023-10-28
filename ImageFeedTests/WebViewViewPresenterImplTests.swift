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

final class RequestHelperSpy: RequestHelper {
    let request = URLRequest(url: URL(string: "https://ya.ru")!)
    let code = "code"

    var makeAuthorizeRequestCalled = false
    var extractCodeCalled = false

    func makeAuthorizeRequest() -> URLRequest {
        makeAuthorizeRequestCalled = true
        return request
    }

    func extractCode(from url: URL) -> String? {
        extractCodeCalled = true
        return code
    }

    func makeToketRequest(code: String) -> URLRequest { request }
    func makeApiRequest(path: String, params: [URLQueryItem], method: String) -> URLRequest { request }
}

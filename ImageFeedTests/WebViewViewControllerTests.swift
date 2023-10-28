import XCTest
@testable import ImageFeed

final class WebViewViewControllerTests: XCTestCase {

    var view: WebViewViewSpy!
    var presenter: WebViewPresenterSpy!
    var controller: WebViewViewController!
    var prevController: WebViewViewControllerDelegateSpy!

    override func setUpWithError() throws {
        view = WebViewViewSpy()
        presenter = WebViewPresenterSpy()
        controller = WebViewViewController(
            presenter: presenter,
            contentView: view
        )
        prevController = WebViewViewControllerDelegateSpy()
        controller.delegate = prevController
    }

    func testControllerViewLoad() throws {
        // when
        _ = controller.view
        controller.viewWillAppear(true)

        // then
        XCTAssertTrue(view.willAppearCalled)
        XCTAssertTrue(presenter.makeWebViewRequestCalled)
        XCTAssertTrue(view.loadCalled)
        XCTAssertEqual(view.request, presenter.request)
    }

    func testCalculateProgress() throws {
        // given
        let value = 0.5

        // when
        let progress = controller.calculateProgress(for: value)

        // then
        XCTAssertTrue(presenter.calculateProgressCalled)
        XCTAssertEqual(progress.value, Progress(from: value).value)
    }

    func testExtractCode() throws {
        // when
        let result = controller.extractCode(from: URL(string: "https://ya.ru")!)

        // then
        XCTAssertTrue(result)
        XCTAssertTrue(presenter.extractCodeCalled)
        XCTAssertTrue(prevController.authWithCodeCalled)
        XCTAssertEqual(presenter.code, prevController.code)
    }

    func testBackButtonClicked() throws {
        // when
        controller.backButtonClicked()

        // then
        XCTAssertTrue(prevController.cancelClickCalled)
    }
}

final class WebViewPresenterSpy: WebViewViewPresenter {
    var makeWebViewRequestCalled = false
    var calculateProgressCalled = false
    var extractCodeCalled = false

    let request = URLRequest(url: URL(string: "https://ya.ru")!)
    let code = "code"

    func makeWebViewRequest() -> URLRequest {
        makeWebViewRequestCalled = true
        return request
    }

    func calculateProgress(for currentValue: Double) -> ImageFeed.Progress {
        calculateProgressCalled = true
        return Progress(from: currentValue)
    }

    func extractCode(from url: URL) -> String? {
        extractCodeCalled = true
        return "code"
    }
}

final class WebViewViewSpy: UIView, WebViewView {
    weak var delegate: WebViewViewDelegat?
    var loadCalled = false
    var willAppearCalled = false
    var request: URLRequest!

    func load(_ request: URLRequest) {
        self.request = request
        loadCalled = true
    }

    func willAppear() {
        willAppearCalled = true
    }
}

final class WebViewViewControllerDelegateSpy: WebViewViewControllerDelegate {
    var authWithCodeCalled = false
    var cancelClickCalled = false

    var code: String!

    func webViewViewController(
        _ viewController: WebViewViewController,
        didAuthenticateWithCode code: String
    ) {
        authWithCodeCalled = true
        self.code = code
    }

    func webViewViewControllerDidCancel(_ viewController: WebViewViewController) {
        cancelClickCalled = true
    }
}

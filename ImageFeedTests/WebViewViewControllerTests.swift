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

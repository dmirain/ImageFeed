import Foundation
import UIKit
@testable import ImageFeed

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

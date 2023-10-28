import Foundation

protocol WebViewViewPresenter {
    func makeWebViewRequest() -> URLRequest
    func calculateProgress(for currentValue: Double) -> Progress
    func extractCode(from url: URL) -> String?
}

final class WebViewViewPresenterImpl: WebViewViewPresenter {
    private let requestHelper: RequestHelper

    init(requestHelper: RequestHelper) {
        self.requestHelper = requestHelper
    }

    func makeWebViewRequest() -> URLRequest {
        requestHelper.makeAuthorizeRequest()
    }

    func calculateProgress(for currentValue: Double) -> Progress {
        Progress(from: currentValue)
    }

    func extractCode(from url: URL) -> String? {
        requestHelper.extractCode(from: url)
    }
}

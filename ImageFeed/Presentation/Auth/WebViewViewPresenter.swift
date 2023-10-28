import Foundation

protocol WebViewViewPresenter {
    func makeWebViewRequest() -> URLRequest
    func calculateProgress(for currentValue: Double) -> Progress
    func extractCode(from url: URL) -> String?
}

final class WebViewViewPresenterImpl: WebViewViewPresenter {
    private let requestBuilder: RequestBuilder

    init(requestBuilder: RequestBuilder) {
        self.requestBuilder = requestBuilder
    }

    func makeWebViewRequest() -> URLRequest {
        requestBuilder.makeAuthorizeRequest()
    }

    func calculateProgress(for currentValue: Double) -> Progress {
        Progress(from: currentValue)
    }

    func extractCode(from url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" }) {
            return codeItem.value
        } else {
            return nil
        }
    }
}

import WebKit
import UIKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ viewController: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ viewController: WebViewViewController)
}

class WebViewViewController: BaseUIViewController {

    weak var delegate: WebViewViewControllerDelegate?
    var observation: NSKeyValueObservation?

    private var authorizeRequest: URLRequest {
        var urlComponents = URLComponents(string: Const.authorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Const.accessKey),
            URLQueryItem(name: "redirect_uri", value: Const.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Const.accessScope)
        ]
        let url = urlComponents.url!
        return URLRequest(url: url)
    }

    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.load(authorizeRequest)
    }

    override func viewWillAppear(_ animated: Bool) {
        observation = observe(\.webView.estimatedProgress) { [weak self] _, _ in
            guard let self else { return }
            self.updateProgress()
        }
        super.viewWillAppear(animated)
    }

    @IBAction private func didTapBackButton(_ sender: UIButton) {
        guard let delegate else {
            assertionFailure("Missed delegate in WebView")
            return
        }
        delegate.webViewViewControllerDidCancel(self)
    }

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let delegate else {
            assertionFailure("Missed delegate in WebView")
            return
        }
        guard let code = code(from: navigationAction) else {
            decisionHandler(.allow)
            return
        }

        decisionHandler(.cancel)
        delegate.webViewViewController(self, didAuthenticateWithCode: code)
    }

    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
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

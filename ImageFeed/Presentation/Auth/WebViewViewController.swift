import WebKit
import UIKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ viewController: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ viewController: WebViewViewController)
}

class WebViewViewController: BaseUIViewController {

    weak var delegate: WebViewViewControllerDelegate?
    private let contentView: WebViewView
    private let requestBuilder: RequestBuilder

    init(requestBuilder: RequestBuilder) {
        self.requestBuilder = requestBuilder

        contentView = WebViewView()
        super .init(nibName: nil, bundle: nil)
        contentView.controller = self
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
       self.view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.load(requestBuilder.makeAuthorizeRequest())
    }

    override func viewWillAppear(_ animated: Bool) {
        contentView.willAppear()
        super.viewWillAppear(animated)
    }
}

extension WebViewViewController: WebViewViewDelegat {
    func extractCode(from url: URL) -> Bool {
        if let code = code(from: url) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            return true
        }
        return false
    }

    func backButtonClicked() {
        delegate?.webViewViewControllerDidCancel(self)
    }

    private func code(from url: URL) -> String? {
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

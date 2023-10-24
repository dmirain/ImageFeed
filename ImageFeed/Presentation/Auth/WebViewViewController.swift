import WebKit
import UIKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ viewController: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ viewController: WebViewViewController)
}

class WebViewViewController: BaseUIViewController {

    weak var delegate: WebViewViewControllerDelegate?
    private let contentView: WebViewView

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

    init() {
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
        contentView.load(authorizeRequest)
    }

    override func viewWillAppear(_ animated: Bool) {
        contentView.willAppear()
        super.viewWillAppear(animated)
    }
}

extension WebViewViewController: WebViewViewDelegat {
    func backButtonClicked() {
        delegate?.webViewViewControllerDidCancel(self)
    }

    func authenticated(with code: String) {
        delegate?.webViewViewController(self, didAuthenticateWithCode: code)
    }
}

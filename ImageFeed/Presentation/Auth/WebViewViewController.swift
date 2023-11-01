import WebKit
import UIKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ viewController: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ viewController: WebViewViewController)
}

final class WebViewViewController: BaseUIViewController {

    weak var delegate: WebViewViewControllerDelegate?
    private let contentView: WebViewView
    private let presenter: WebViewViewPresenter

    init(presenter: WebViewViewPresenter, contentView: WebViewView) {
        self.presenter = presenter
        self.contentView = contentView

        super .init(nibName: nil, bundle: nil)
        contentView.delegate = self
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
        contentView.load(presenter.makeWebViewRequest())
    }

    override func viewWillAppear(_ animated: Bool) {
        contentView.willAppear()
        super.viewWillAppear(animated)
    }
}

extension WebViewViewController: WebViewViewDelegat {
    func calculateProgress(for currentValue: Double) -> Progress {
        presenter.calculateProgress(for: currentValue)
    }

    func extractCode(from url: URL) -> Bool {
        if let code = presenter.extractCode(from: url) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            return true
        }
        return false
    }

    func backButtonClicked() {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

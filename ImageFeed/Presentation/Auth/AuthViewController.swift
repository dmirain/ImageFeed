import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authComplite(_ viewController: AuthViewController)
}

final class AuthViewController: BaseUIViewController {
    weak var delegate: AuthViewControllerDelegate?
    private let contentView: AuthView

    private let showAuthWebViewIdentifier = "ShowAuthWebView"
    private let authGateway: AuthGateway
    private let authStorage: AuthStorage
    private var alertPresenter: AlertPresenter
    private let webViewViewController: WebViewViewController

    init(
        authStorage: AuthStorage,
        alertPresenter: AlertPresenter,
        webViewViewController: WebViewViewController,
        authGateway: UnsplashAuthGateway
    ) {
        self.authGateway = authGateway
        self.authStorage = authStorage
        self.alertPresenter = alertPresenter
        self.webViewViewController = webViewViewController

        contentView = AuthView()
        super.init(nibName: nil, bundle: nil)

        contentView.controller = self
        self.alertPresenter.delegate = self
        self.webViewViewController.delegate = self
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
       self.view = contentView
    }
}

extension AuthViewController: AuthViewDelegat {
    func enterButtonClicked() {
        present(webViewViewController, animated: true)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ viewController: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        authGateway.fetchAuthToken(with: code) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(authData):
                if authStorage.set(authData) {
                    self.handleSuccessAuth(viewController, authData: authData)
                } else {
                    self.handleErrorAuth(error: .authFaild)
                }
            case let .failure(error):
                self.handleErrorAuth(error: error)
            }
        }
    }

    private func handleErrorAuth(error: NetworkError) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            UIBlockingProgressHUD.dismiss()

            self.alertPresenter.show(with: ErrorAlertDto(error: error))
        }
    }

    private func handleSuccessAuth(_ viewController: WebViewViewController, authData: AuthDto) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard let delegate = self.delegate else { return }
            UIBlockingProgressHUD.dismiss()

            viewController.dismiss(animated: false)
            delegate.authComplite(self)
        }
    }

    func webViewViewControllerDidCancel(_ viewController: WebViewViewController) {
        viewController.dismiss(animated: true)
    }
}

extension AuthViewController: AlertPresenterDelegate {
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }

    func performAlertAction(action: AlertAction) {}
}

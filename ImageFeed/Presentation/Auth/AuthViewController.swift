import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authComplite(_ viewController: AuthViewController)
}

final class AuthViewController: BaseUIViewController {
    weak var delegate: AuthViewControllerDelegate?

    private let showAuthWebViewIdentifier = "ShowAuthWebView"
    private let authGateway: AuthGateway
    private let authStorage: AuthStorage
    private var alertPresenter: AlertPresenter

    required init?(coder: NSCoder) {
        let httpClient = NetworkClientImpl()
        authGateway = UnsplashAuthGateway(httpClient: httpClient)
        authStorage = AuthStorageImpl.shared
        alertPresenter = AlertPresenterImpl()

        super.init(coder: coder)

        alertPresenter.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthWebViewIdentifier {
            guard let viewController = segue.destination as? WebViewViewController else {
                assertionFailure("unknown controller \(segue.destination)")
                return
            }
            viewController.delegate = self
        } else {
            assertionFailure("unknown segue identifier \(segue.identifier ?? "")")
        }
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

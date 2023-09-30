import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authComplite()
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
        authStorage = UserDeafaultsAuthStorage.shared
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
        // TODO вытащить всё это из контроллера, как будет минутка
        UIBlockingProgressHUD.show()
        authGateway.fetchAuthToken(with: code) { [weak self] result in
            guard let self else {
                assertionFailure("Missed self")
                return
            }

            UIBlockingProgressHUD.dismiss()
            switch result {
            case let .success(authData):
                self.handleSuccessAuth(authData: authData)
            case let .failure(error):
                self.handleErrorAuth(error: error)
            }
        }
    }

    private func handleErrorAuth(error: NetworkError) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                assertionFailure("Missed self")
                return
            }
            self.alertPresenter.show(with: ErrorAlertDto(error: error))
        }
    }

    private func handleSuccessAuth(authData: AuthDto) {
        authStorage.set(authData)
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                assertionFailure("Missed self")
                return
            }
            guard let delegate = self.delegate else {
                assertionFailure("Missed delegat")
                return
            }
            delegate.authComplite()
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

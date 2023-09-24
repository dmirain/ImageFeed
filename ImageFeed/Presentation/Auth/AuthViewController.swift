import UIKit

final class AuthViewController: BaseUIViewController {
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
        Task { [weak self] in
            guard let self else { return }
            var requestError: NetworkError?
            do {
                let authData = try await self.authGateway.authenticate(with: code)
                self.authStorage.set(authData)
            } catch let error as NetworkError {
                requestError = error
            } catch let error {
                requestError = .unknownError(error: error)
            }

            Task { @MainActor [weak self] in
                guard let self else { return }
                if let error = requestError {
                    self.alertPresenter.show(with: ErrorAlertDto(error: error))
                } else {
                    // TODO передавать управление галереи
                }
            }
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

import UIKit

final class SplashViewController: BaseUIViewController {
    private let window: UIWindow
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"

    private let contentView: SplashUIView

    private let authStorage: AuthStorage
    private let tabBarViewController: TabBarController
    private let authViewController: AuthViewController
    private var alertPresenter: AlertPresenter

    init(
        window: UIWindow,
        authStorage: AuthStorage,
        authViewController: AuthViewController,
        tabBarViewController: TabBarController,
        alertPresenter: AlertPresenter
    ) {
        self.window = window
        self.authStorage = authStorage
        self.authViewController = authViewController
        self.tabBarViewController = tabBarViewController
        self.alertPresenter = alertPresenter
        self.contentView = SplashUIView()

        super.init(nibName: nil, bundle: nil)

        self.alertPresenter.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        routeToController()
    }

    override func loadView() {
       self.view = contentView
    }
}

private extension SplashViewController {
    func routeToController() {
        guard let token = authStorage.get()?.token else {
            authViewController.delegate = self
            present(authViewController, animated: true)
            return
        }
        showTabBarViewController(token: token)
    }

    func showTabBarViewController(token: String) {
        UIBlockingProgressHUD.show()

        tabBarViewController.initData(token: token) { [weak self] error in
            guard let self else { return }
            if let error {
                switch error {
                case .authFaild:
                    self.authStorage.reset()
                default:
                    break
                }

                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                    self.alertPresenter.show(with: ErrorAlertDto(error: error))
                }
            } else {
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                    self.window.rootViewController = self.tabBarViewController
                }
            }
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authComplite(_ viewController: AuthViewController) {
        viewController.dismiss(animated: true)
    }
}

extension SplashViewController: AlertPresenterDelegate {
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true)
    }

    func performAlertAction(action: AlertAction) {
        routeToController()
    }
}

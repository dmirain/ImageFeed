import UIKit

final class SplashViewController: BaseUIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"

    private let contentView: SplashUIView

    private let authStorage: AuthStorage
    private let tabBarViewController: TabBarController
    private let authViewController: AuthViewController

    init(authStorage: AuthStorage, authViewController: AuthViewController, tabBarViewController: TabBarController) {
        self.authStorage = authStorage
        self.authViewController = authViewController
        self.tabBarViewController = tabBarViewController
        self.contentView = SplashUIView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        routeToController()
    }
}

extension SplashViewController {
    private func routeToController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }

        let token = authStorage.get()?.token

        if token == nil {
            authViewController.delegate = self
            present(authViewController, animated: true)
        } else {
            window.rootViewController = tabBarViewController
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authComplite() {
        routeToController()
    }
}

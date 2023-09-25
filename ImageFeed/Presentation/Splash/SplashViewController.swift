import UIKit

final class SplashViewController: BaseUIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"

    private let authStorage: AuthStorage
    private let tabBarViewController: UIViewController

    required init?(coder: NSCoder) {
        authStorage = UserDeafaultsAuthStorage.shared
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        tabBarViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController")

        super.init(coder: coder)
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
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        } else {
            window.rootViewController = tabBarViewController
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard let viewController = segue.destination as? AuthViewController else {
                assertionFailure("unknown controller \(segue.destination)")
                return
            }

            viewController.delegate = self
        } else {
            assertionFailure("unknown segue identifier \(segue.identifier ?? "")")
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authComplite() {
        routeToController()
    }
}

import UIKit
import Swinject

protocol SplashViewControllerDelegate: AnyObject {
    func routeToController(controller: UIViewController)
}

final class SplashViewController: BaseUIViewController {
    private weak var delegate: SplashViewControllerDelegate?

    private let contentView: SplashUIView

    private let diResolver: Resolver
    private let authStorage: AuthStorage
    private var alertPresenter: AlertPresenter
    private lazy var tabBarViewController: TabBarController = {
        diResolver.resolve(TabBarController.self)!
    }()
    private lazy var authViewController: AuthViewController = {
        let controller = diResolver.resolve(AuthViewController.self)!
        controller.delegate = self
        return controller
    }()
    init(
        delegate: SplashViewControllerDelegate,
        authStorage: AuthStorage,
        alertPresenter: AlertPresenter,
        diResolver: Resolver
    ) {
        self.delegate = delegate
        self.authStorage = authStorage
        self.alertPresenter = alertPresenter
        self.diResolver = diResolver
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

                DispatchQueue.main.async { [weak self] in
                    UIBlockingProgressHUD.dismiss()
                    self?.alertPresenter.show(with: ErrorAlertDto(error: error))
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    UIBlockingProgressHUD.dismiss()
                    guard let self else { return }
                    self.delegate?.routeToController(controller: self.tabBarViewController)
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

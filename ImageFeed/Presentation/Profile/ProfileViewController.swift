import UIKit
import WebKit
import Swinject

final class ProfileViewController: BaseUIViewController {
    private let window: UIWindow
    private let diResolver: Resolver
    private let contentView: ProfileUIView
    private let authStorage: AuthStorage
    private var alertPresenter: AlertPresenter
    private let profileGateway: ProfileGateway
    private let profileImageGateway: ProfileImageGateway
    private var profileImageServiceObserver: NSObjectProtocol?

    init(
        window: UIWindow,
        authStorage: AuthStorage,
        alertPresenter: AlertPresenter,
        profileGateway: ProfileGateway,
        profileImageGateway: ProfileImageGateway,
        diResolver: Resolver
    ) {
        contentView = ProfileUIView()
        self.window = window
        self.diResolver = diResolver
        self.authStorage = authStorage
        self.alertPresenter = alertPresenter
        self.profileGateway = profileGateway
        self.profileImageGateway = profileImageGateway
        super.init(nibName: nil, bundle: nil)

        contentView.controller = self
        self.alertPresenter.delegate = self
        subscribeOnUpdateAvatar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
       self.view = contentView
    }

    func initData(token: String, handler: @escaping (NetworkError?) -> Void) {
        profileGateway.fetchProfile { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    self.contentView.set(profileData: data)
                }

                profileImageGateway.fetchProfilePhoto(username: data.username)

                handler(nil)
            case let .failure(error):
                handler(error)
            }
        }
    }

    private func subscribeOnUpdateAvatar() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageGateway.didChangeNotification, object: nil, queue: .main
        ) { [weak self] data in
            guard let self else { return }
            if let photoUrl = data.userInfo?["URL"] as? String {
                guard let photoUrl = URL(string: photoUrl) else { return }
                self.contentView.updateAvatar(photoUrl)
            }
        }
    }
}

extension ProfileViewController: ProfileUIViewDelegat, AlertPresenterDelegate {
    func exitButtonClicked() {
        alertPresenter.show(with: ExitAlertDto())
    }

    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true)
    }

    func performAlertAction(action: AlertAction) {
        switch action {
        case .doNothing:
            break
        case .reset:
            break
        case .exit:
            performExit()
        }
    }

    private func performExit() {
        authStorage.reset()

        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища.
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища.
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
        window.rootViewController = diResolver.resolve(SplashViewController.self, argument: window)
    }
}

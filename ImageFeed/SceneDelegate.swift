import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var container = Container()

    override init() {
        super.init()

        registerHelpers()
        registerGateways()
        registerAuth()
        registerGallery()
        registerProfile()
        registerMainControllers()
    }

    private func registerHelpers() {
        container.register(AuthStorage.self) { _ in AuthStorageImpl.shared }
        container.register(UnsplashApiConfig.self) { _ in UnsplashApiConfig.production }
        container.register(NetworkClient.self) { _ in NetworkClientImpl() }
        container.register(AlertPresenter.self) { _ in AlertPresenterImpl() }

        container.register(RequestHelper.self) { diResolver in
            RequestHelperImpl(
                authStorage: diResolver.resolve(AuthStorage.self)!,
                unsplashApiConfig: diResolver.resolve(UnsplashApiConfig.self)!
            )
        }
    }

    private func registerGateways() {
        container.register(ProfileGateway.self) { diResolver in
            ProfileGateway(
                httpClient: diResolver.resolve(NetworkClient.self)!,
                requestHelper: diResolver.resolve(RequestHelper.self)!
            )
        }
        container.register(ProfileImageGateway.self) { diResolver in
            ProfileImageGateway(
                httpClient: diResolver.resolve(NetworkClient.self)!,
                requestHelper: diResolver.resolve(RequestHelper.self)!
            )
        }
        container.register(ImagesListGateway.self) { diResolver in
            ImagesListGateway(
                httpClient: diResolver.resolve(NetworkClient.self)!,
                requestHelper: diResolver.resolve(RequestHelper.self)!
            )
        }
        container.register(ImageLikeGateway.self) { diResolver in
            ImageLikeGateway(
                httpClient: diResolver.resolve(NetworkClient.self)!,
                requestHelper: diResolver.resolve(RequestHelper.self)!
            )
        }
        container.register(AuthGateway.self) { diResolver in
            AuthGateway(
                httpClient: diResolver.resolve(NetworkClient.self)!,
                requestHelper: diResolver.resolve(RequestHelper.self)!
            )
        }
    }

    private func registerAuth() {
        container.register(AuthViewController.self) { diResolver in
            AuthViewController(
                authStorage: diResolver.resolve(AuthStorage.self)!,
                alertPresenter: diResolver.resolve(AlertPresenter.self)!,
                webViewViewController: diResolver.resolve(WebViewViewController.self)!,
                authGateway: diResolver.resolve(AuthGateway.self)!
            )
        }
        container.register(WebViewViewPresenter.self) { diResolver in
            WebViewViewPresenterImpl(
                requestHelper: diResolver.resolve(RequestHelper.self)!
            )
        }
        container.register(WebViewView.self) { _ in
            WebViewViewImpl()
        }
        container.register(WebViewViewController.self) { diResolver in
            WebViewViewController(
                presenter: diResolver.resolve(WebViewViewPresenter.self)!,
                contentView: diResolver.resolve(WebViewView.self)!
            )
        }
    }

    private func registerGallery() {
        container.register(ImagesListService.self) { diResolver in
            ImagesListService(
                imageListGateway: diResolver.resolve(ImagesListGateway.self)!,
                imageLikeGateway: diResolver.resolve(ImageLikeGateway.self)!
            )
        }

        container.register(SingleImageViewController.self) { diResolver in
            SingleImageViewController(
                alertPresenter: diResolver.resolve(AlertPresenter.self)!
            )
        }
        container.register(ImagesListTableUIView.self) { _ in
            ImagesListTableUIView()
        }
        container.register(ImagesListViewPresenter.self) { diResolver in
            ImagesListViewPresenterImpl(
                imagesListService: diResolver.resolve(ImagesListService.self)!
            )
        }
        container.register(ImagesListViewController.self) { diResolver in
            ImagesListViewController(
                diResolver: diResolver,
                presenter: diResolver.resolve(ImagesListViewPresenter.self)!,
                contentView: diResolver.resolve(ImagesListTableUIView.self)!
            )
        }
    }

    private func registerProfile() {
        container.register(ProfileUIView.self) { _ in
            ProfileUIViewImpl()
        }
        container.register(ProfileViewPresenter.self) { diResolver in
            ProfileViewPresenterImpl(
                authStorage: diResolver.resolve(AuthStorage.self)!,
                profileGateway: diResolver.resolve(ProfileGateway.self)!,
                profileImageGateway: diResolver.resolve(ProfileImageGateway.self)!
            )
        }
        container.register(ProfileViewController.self) { diResolver in
            ProfileViewController(
                delegate: self,
                presenter: diResolver.resolve(ProfileViewPresenter.self)!,
                alertPresenter: diResolver.resolve(AlertPresenter.self)!,
                contentView: diResolver.resolve(ProfileUIView.self)!
            )
        }
    }

    private func registerMainControllers() {
        container.register(TabBarController.self) { diResolver in
            TabBarController(
                imagesListViewController: diResolver.resolve(ImagesListViewController.self)!,
                profileViewController: diResolver.resolve(ProfileViewController.self)!
            )
        }
        container.register(SplashViewController.self) { diResolver in
            SplashViewController(
                delegate: self,
                authStorage: diResolver.resolve(AuthStorage.self)!,
                alertPresenter: diResolver.resolve(AlertPresenter.self)!,
                diResolver: diResolver
            )
        }
    }

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        window?.rootViewController = container.resolve(SplashViewController.self, argument: window!)
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

extension SceneDelegate: ProfileViewControllerDelegate {
    func roteToRoot() {
        window?.rootViewController = container.resolve(SplashViewController.self)
    }
}

extension SceneDelegate: SplashViewControllerDelegate {
    func routeToController(controller: UIViewController) {
        window?.rootViewController = controller
    }
}

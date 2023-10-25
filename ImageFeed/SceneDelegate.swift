import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private let container: Container = {
        let container = Container()
        container.register(AuthStorage.self) { _ in AuthStorageImpl.shared }
        container.register(UnsplashApiConfig.self) { _ in UnsplashApiConfig.production }
        container.register(NetworkClient.self) { _ in NetworkClientImpl() }
        container.register(AlertPresenter.self) { _ in AlertPresenterImpl() }

        container.register(RequestBuilder.self) { diResolver in
            RequestBuilderImpl(
                authStorage: diResolver.resolve(AuthStorage.self)!,
                unsplashApiConfig: diResolver.resolve(UnsplashApiConfig.self)!
            )
        }
        container.register(ProfileGateway.self) { diResolver in
            ProfileGateway(
                httpClient: diResolver.resolve(NetworkClient.self)!,
                requestBuilder: diResolver.resolve(RequestBuilder.self)!
            )
        }
        container.register(ProfileImageGateway.self) { diResolver in
            ProfileImageGateway(
                httpClient: diResolver.resolve(NetworkClient.self)!,
                requestBuilder: diResolver.resolve(RequestBuilder.self)!
            )
        }
        container.register(ImagesListGateway.self) { diResolver in
            ImagesListGateway(
                httpClient: diResolver.resolve(NetworkClient.self)!,
                requestBuilder: diResolver.resolve(RequestBuilder.self)!
            )
        }
        container.register(ImageLikeGateway.self) { diResolver in
            ImageLikeGateway(
                httpClient: diResolver.resolve(NetworkClient.self)!,
                requestBuilder: diResolver.resolve(RequestBuilder.self)!
            )
        }
        container.register(UnsplashAuthGateway.self) { diResolver in
            UnsplashAuthGateway(
                httpClient: diResolver.resolve(NetworkClient.self)!,
                requestBuilder: diResolver.resolve(RequestBuilder.self)!
            )
        }

        container.register(ImagesListService.self) { diResolver in
            ImagesListService(
                imageListGateway: diResolver.resolve(ImagesListGateway.self)!,
                imageLikeGateway: diResolver.resolve(ImageLikeGateway.self)!
            )
        }

        container.register(AuthViewController.self) { diResolver in
            AuthViewController(
                authStorage: diResolver.resolve(AuthStorage.self)!,
                alertPresenter: diResolver.resolve(AlertPresenter.self)!,
                webViewViewController: diResolver.resolve(WebViewViewController.self)!,
                authGateway: diResolver.resolve(UnsplashAuthGateway.self)!
            )
        }
        container.register(WebViewViewController.self) { diResolver in
            WebViewViewController(
                requestBuilder: diResolver.resolve(RequestBuilder.self)!
            )
        }
        container.register(SingleImageViewController.self) { diResolver in
            SingleImageViewController(
                alertPresenter: diResolver.resolve(AlertPresenter.self)!
            )
        }
        container.register(ImagesListViewController.self) { diResolver in
            ImagesListViewController(
                diResolver: diResolver,
                imagesListService: diResolver.resolve(ImagesListService.self)!
            )
        }
        container.register(ProfileViewController.self) { diResolver, window in
            ProfileViewController(
                window: window,
                authStorage: diResolver.resolve(AuthStorage.self)!,
                alertPresenter: diResolver.resolve(AlertPresenter.self)!,
                profileGateway: diResolver.resolve(ProfileGateway.self)!,
                profileImageGateway: diResolver.resolve(ProfileImageGateway.self)!,
                diResolver: diResolver
            )
        }
        container.register(TabBarController.self) { (diResolver: Resolver, window: UIWindow) in
            TabBarController(
                imagesListViewController: diResolver.resolve(ImagesListViewController.self)!,
                profileViewController: diResolver.resolve(ProfileViewController.self, argument: window)!
            )
        }
        container.register(SplashViewController.self) { diResolver, window in
            SplashViewController(
                window: window,
                authStorage: diResolver.resolve(AuthStorage.self)!,
                alertPresenter: diResolver.resolve(AlertPresenter.self)!,
                diResolver: diResolver
            )
        }
        return container
    }()

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

import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private let container: Container = {
        let container = Container()
        container.register(UIStoryboard.self) { _ in UIStoryboard(name: "Main", bundle: .main) }
        container.register(AuthStorage.self) { _ in AuthStorageImpl.shared }
        container.register(NetworkClient.self) { _ in NetworkClientImpl() }
        container.register(AlertPresenter.self) { _ in AlertPresenterImpl() }

        container.register(ProfileGateway.self) { diResolver in
            ProfileGateway(httpClient: diResolver.resolve(NetworkClient.self)!)
            
        }
        container.register(ProfileImageGateway.self) { diResolver in
            ProfileImageGateway(httpClient: diResolver.resolve(NetworkClient.self)!)
        }
        container.register(ImageFeedModel.self) { _ in ImageFeedModel() }

        container.register(AuthViewController.self) { diResolver in
            let controller = diResolver.resolve(UIStoryboard.self)!.instantiateViewController(
                withIdentifier: "AuthViewController"
            ) as? AuthViewController
            controller?.modalPresentationStyle = .fullScreen
            return controller!
        }
        container.register(ImagesListViewController.self) { diResolver in
            ImagesListViewController(imageFeedModel: diResolver.resolve(ImageFeedModel.self)!)
        }
        container.register(ProfileViewController.self) { diResolver in
            ProfileViewController(
                profileGateway: diResolver.resolve(ProfileGateway.self)!,
                profileImageGateway: diResolver.resolve(ProfileImageGateway.self)!
            )
        }
        container.register(TabBarController.self) { diResolver in
            TabBarController(
                imagesListViewController: diResolver.resolve(ImagesListViewController.self)!,
                profileViewController: diResolver.resolve(ProfileViewController.self)!
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

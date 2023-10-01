import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private let storyboard = UIStoryboard(name: "Main", bundle: .main)
    private let authStorage = AuthStorageImpl.shared
    private let httpClient = NetworkClientImpl()
    private var authViewController: AuthViewController? {
        storyboard.instantiateViewController(
            withIdentifier: "AuthViewController"
        ) as? AuthViewController
    }
    private var imagesListViewController: ImagesListViewController? {
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as? ImagesListViewController

        imagesListViewController?.tabBarItem = UITabBarItem(title: nil, image: UIImage.mainTabImage, selectedImage: nil)
        return imagesListViewController
    }
    private var profileViewController: ProfileViewController {
        let profileGateway = ProfileGateway(httpClient: httpClient)
        return ProfileViewController(profileGateway: profileGateway)
    }
    private var tabBarViewController: TabBarController {
        TabBarController(
            imagesListViewController: imagesListViewController!,
            profileViewController: profileViewController
        )
    }
    private var splashViewController: SplashViewController {
        SplashViewController(
            window: window!,
            authStorage: authStorage,
            authViewController: authViewController!,
            tabBarViewController: tabBarViewController,
            alertPresenter: AlertPresenterImpl()
        )
    }

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        window?.rootViewController = splashViewController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

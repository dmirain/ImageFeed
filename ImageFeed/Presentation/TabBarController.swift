import UIKit

final class TabBarController: UITabBarController {
    private let imagesListViewController: ImagesListViewController
    private let profileViewController: ProfileViewController

    init(
        imagesListViewController: ImagesListViewController,
        profileViewController: ProfileViewController
    ) {
        self.imagesListViewController = imagesListViewController
        self.profileViewController = profileViewController

        super.init(nibName: nil, bundle: nil)

        viewControllers = [imagesListViewController, profileViewController]

        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage.profileTabImage, selectedImage: nil)
        imagesListViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage.mainTabImage, selectedImage: nil)

        tabBar.tintColor = UIColor.ypWhite
        tabBar.barTintColor = UIColor.ypBlack
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initData(token: String, handler: @escaping (NetworkError?) -> Void) {
        imagesListViewController.fetchPhotosNextPage()
        profileViewController.initData(token: token, handler: handler)
    }
}

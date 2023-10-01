import UIKit

final class TabBarController: UITabBarController {
    init(imagesListViewController: ImagesListViewController, profileViewController: ProfileViewController) {
        super.init(nibName: nil, bundle: nil)
        viewControllers = [imagesListViewController, profileViewController]
        tabBar.tintColor = UIColor.ypWhite
        tabBar.barTintColor = UIColor.ypBlack
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

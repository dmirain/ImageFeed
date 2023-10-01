import UIKit

final class ProfileViewController: BaseUIViewController {
    private let contentView: ProfileUIView

    init() {
        contentView = ProfileUIView()
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: nil, image: UIImage.profileTabImage, selectedImage: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
       self.view = contentView
    }
}

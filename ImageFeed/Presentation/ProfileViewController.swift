import UIKit

final class ProfileViewController: BaseUIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfileRenderer(delegate: self).render()
    }
}

// MARK: - ProfileRendererProtocol

extension ProfileViewController: ProfileRendererProtocol {
    func addToSuperview(subview: UIView) {
        view.addSubview(subview)
    }
}

import UIKit

final class ProfileViewController: BaseUIViewController {
    private lazy var contentView = ProfileUIView()

    override func loadView() {
       self.view = contentView
    }
}

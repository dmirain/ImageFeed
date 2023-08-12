import UIKit

final class ProfileViewController: BaseUIViewController {
    @IBOutlet private weak var userpick: UIImageView!
    @IBOutlet private weak var exit: UIButton!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var email: UILabel!
    @IBOutlet private weak var userInfo: UILabel!

    @IBAction private func touchExit(_ sender: UIButton) {
    }
}

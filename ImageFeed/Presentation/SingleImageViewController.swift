import UIKit

final class SingleImageViewController: BaseUIViewController {
    var imageModel: ImageCellModel!

    @IBOutlet private weak var imageView: UIImageView!

    override func viewDidLoad() {
        imageView.image = imageModel.image
        super.viewDidLoad()
    }

    @IBAction private func tapBack() {
        dismiss(animated: true, completion: nil)
    }
}

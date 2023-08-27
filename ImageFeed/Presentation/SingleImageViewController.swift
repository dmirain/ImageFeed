import UIKit

final class SingleImageViewController: BaseUIViewController {
    var imageModel: ImageCellModel? {
        didSet {
            onModelSet()
        }
    }

    @IBOutlet private weak var imageView: UIImageView?

    override func viewDidLoad() {
        onModelSet()
        super.viewDidLoad()
    }

    @IBAction private func tapBack() {
        dismiss(animated: true, completion: nil)
    }

    private func onModelSet() {
        imageView?.image = imageModel?.image
    }
}

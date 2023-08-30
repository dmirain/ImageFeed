import UIKit

final class SingleImageViewController: BaseUIViewController {
    var imageModel: ImageCellModel? {
        didSet {
            onModelSet()
        }
    }

    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25

        onModelSet()
        super.viewDidLoad()
    }

    @IBAction private func tapBack() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction private func tapShare() {
        guard let image = imageModel?.image else { return }

        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }

    private func onModelSet() {
        imageView?.image = imageModel?.image
        if let image = imageView?.image {
            rescaleAndCenterImageInScrollView(image: image)
        }
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale

        view.layoutIfNeeded()

        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)

        scrollView.layoutIfNeeded()

        let newContentSize = scrollView.contentSize
        let xCord = (newContentSize.width - visibleRectSize.width) / 2
        let yCord = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: xCord, y: yCord), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

import UIKit

protocol SingleImageViewDelegate: AnyObject {
    func backButtonClicked()
    func shareButtonClicked(image: UIImage)
    func showRetryAlert()
}

final class SingleImageView: UIView {
    weak var delegate: SingleImageViewDelegate?

    private var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.minimumZoomScale = 0.1
        view.maximumZoomScale = 1.25
        return view
    }()

    private var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()

    private var backButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "backButton"
        view.setImage(UIImage.back, for: .normal)
        view.setTitle("", for: .normal)

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 44),
            view.heightAnchor.constraint(equalToConstant: 44)
        ])
        return view
    }()

    private var shareButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage.share, for: .normal)
        view.setTitle("", for: .normal)

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 50),
            view.heightAnchor.constraint(equalToConstant: 50)
        ])
        return view
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .ypBlack

        scrollView.addSubview(imageView)
        addSubview(scrollView)
        addSubview(backButton)
        addSubview(shareButton)

        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonClicked), for: .touchUpInside)

        scrollView.delegate = self

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            shareButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -17),
            shareButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            backButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            backButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func backButtonClicked() {
        imageView.kf.cancelDownloadTask()
        delegate?.backButtonClicked()
    }
    @objc
    private func shareButtonClicked() {
        guard let delegate, let image = imageView.image else { return }
        delegate.shareButtonClicked(image: image)
    }

    func setImage(image: ImageDto) {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: image.largeImageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success:
                    self.rescaleAndCenterImageInScrollView()
                case .failure:
                    self.delegate?.showRetryAlert()
                }
            }
        }
    }

    private func rescaleAndCenterImageInScrollView() {
        guard let image = imageView.image else { return }

        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale

        scrollView.layoutIfNeeded()

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

extension SingleImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { imageView }
}

import UIKit

final class SingleImageViewController: BaseUIViewController {
    private let contentView: SingleImageView
    private var image: ImageDto?
    private var alertPresenter: AlertPresenter

    init(alertPresenter: AlertPresenter) {
        contentView = SingleImageView()
        self.alertPresenter = alertPresenter

        super.init(nibName: nil, bundle: nil)

        contentView.delegate = self
        self.alertPresenter.delegate = self
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    func setImage(image: ImageDto) {
        self.image = image
        contentView.setImage(image: image)
    }
}

extension SingleImageViewController: SingleImageViewDelegate {
    func backButtonClicked() {
        dismiss(animated: true, completion: nil)
    }

    func shareButtonClicked(image: UIImage) {
        let activityViewController = UIActivityViewController(
            activityItems: [image], applicationActivities: nil
        )
        present(activityViewController, animated: true, completion: nil)
    }

    func showRetryAlert() {
        self.alertPresenter.show(with: OpenImageAlertDto())
    }
}

extension SingleImageViewController: AlertPresenterDelegate {
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true)
    }

    func performAlertAction(action: AlertAction) {
        switch action {
        case .doNothing:
            break
        case .reset:
            guard let image = self.image else {
                self.backButtonClicked()
                return
            }
            self.contentView.setImage(image: image)
        case .exit:
            self.backButtonClicked()
        }
    }
}

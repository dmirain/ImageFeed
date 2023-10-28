import UIKit
import Swinject

protocol ProfileViewControllerDelegate: AnyObject {
    func roteToRoot()
}

final class ProfileViewController: BaseUIViewController {
    private let contentView: ProfileUIView
    private var alertPresenter: AlertPresenter
    private var presenter: ProfileViewPresenter
    private weak var delegate: ProfileViewControllerDelegate?

    init(
        delegate: ProfileViewControllerDelegate,
        presenter: ProfileViewPresenter,
        alertPresenter: AlertPresenter,
        contentView: ProfileUIView
    ) {
        self.contentView = contentView
        self.delegate = delegate
        self.presenter = presenter
        self.alertPresenter = alertPresenter
        super.init(nibName: nil, bundle: nil)

        self.contentView.delegate = self
        self.presenter.delegate = self
        self.alertPresenter.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
       self.view = contentView
    }

    func initData(handler: @escaping (NetworkError?) -> Void) {
        presenter.initData(handler: handler)
    }

}

extension ProfileViewController: ProfileViewPresenterDelegate {
    func updateAvatar(_ photoUrl: URL) {
        contentView.updateAvatar(photoUrl)
    }

    func set(profileData data: ProfileDto) {
        contentView.set(profileData: data)
    }
}

extension ProfileViewController: ProfileUIViewDelegat, AlertPresenterDelegate {
    func exitButtonClicked() {
        alertPresenter.show(with: ExitAlertDto())
    }

    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true)
    }

    func performAlertAction(action: AlertAction) {
        switch action {
        case .doNothing:
            break
        case .reset:
            break
        case .exit:
            performExit()
        }
    }

    private func performExit() {
        presenter.performExit()
        delegate?.roteToRoot()
    }
}

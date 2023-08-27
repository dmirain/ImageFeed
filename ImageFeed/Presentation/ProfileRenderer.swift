import UIKit

protocol ProfileRendererProtocol: AnyObject {
    func addToSuperview(subview: UIView)
}

final class ProfileRenderer {
    private let userpickImageView = UIImageView()
    private let exitButton = UIButton()
    private let nameLabel = UILabel()
    private let loginLabel = UILabel()
    private let userInfoLabel = UILabel()

    private weak var delegate: ProfileRendererProtocol?
    private let hStack = UIStackView()
    private let vStack = UIStackView()

    init(delegate: ProfileRendererProtocol) {
        self.delegate = delegate
    }

    func render() {
        guard let delegate else { return }

        [userpickImageView, exitButton, nameLabel, loginLabel, hStack, vStack].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        renderUserpic()
        renderExitButton()
        renderHStack()
        renderNameLabel()
        renderLoginLabel()
        renderUserInfoLabel()
        renderVStack()

        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: vStack.leadingAnchor, constant: 0),
            hStack.trailingAnchor.constraint(equalTo: vStack.trailingAnchor, constant: 0)
        ])

        delegate.addToSuperview(subview: vStack)

        guard let superview = vStack.superview else {
            assertionFailure("vStack must be added to superview")
            return
        }

        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(
                equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: 32
            ),
            vStack.leadingAnchor.constraint(
                equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: 16
            ),
            vStack.trailingAnchor.constraint(
                equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -16
            )
        ])
    }

    private func renderUserpic() {
        userpickImageView.image = UIImage(named: "Userpick Stub")
        NSLayoutConstraint.activate([
            userpickImageView.widthAnchor.constraint(equalToConstant: 70),
            userpickImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    private func renderExitButton() {
        exitButton.setImage(UIImage(named: "Exit"), for: .normal)
        exitButton.setTitle("", for: .normal)
        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func renderNameLabel() {
        nameLabel.text = "Имя"
        let desc = UIFontDescriptor().withSymbolicTraits(UIFontDescriptor.SymbolicTraits([.traitBold]))!
        nameLabel.font = UIFont(descriptor: desc, size: 23)
        nameLabel.textColor = UIColor.ypWhite
    }

    private func renderLoginLabel() {
        loginLabel.text = "@login"
        loginLabel.font = loginLabel.font.withSize(13)
        loginLabel.textColor = UIColor.ypGray
    }

    private func renderUserInfoLabel() {
        userInfoLabel.text = "Информация"
        userInfoLabel.font = userInfoLabel.font.withSize(13)
        userInfoLabel.textColor = UIColor.ypWhite
    }

    private func renderHStack() {
        hStack.addArrangedSubview(userpickImageView)
        hStack.addArrangedSubview(exitButton)

        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 0
        hStack.contentMode = .scaleAspectFit
        hStack.distribution = .equalCentering
    }

    private func renderVStack() {
        vStack.addArrangedSubview(hStack)
        vStack.addArrangedSubview(nameLabel)
        vStack.addArrangedSubview(loginLabel)
        vStack.addArrangedSubview(userInfoLabel)

        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.distribution = .equalSpacing
        vStack.spacing = 8
    }
}

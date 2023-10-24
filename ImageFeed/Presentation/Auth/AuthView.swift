import UIKit

protocol AuthViewDelegat: AnyObject {
    func enterButtonClicked()
}

final class AuthView: UIView {
    weak var controller: AuthViewDelegat?

    private lazy var logo: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = .logo
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 60),
            view.heightAnchor.constraint(equalToConstant: 60)
        ])
        return view
    }()

    private lazy var enterButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Войти", for: .normal)
        view.setTitleColor(.ypBlack, for: .normal)
        view.backgroundColor = .ypWhite
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 48)
        ])
        return view
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .ypBlack

        addSubview(logo)
        addSubview(enterButton)

        enterButton.addTarget(self, action: #selector(enterButtonClicked), for: .touchUpInside)

        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: enterButton.trailingAnchor, constant: 16),
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: enterButton.bottomAnchor, constant: 90),
            safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: enterButton.leadingAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func enterButtonClicked() {
        controller?.enterButtonClicked()
    }
}

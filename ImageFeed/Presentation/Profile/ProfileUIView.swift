import UIKit

final class ProfileUIView: UIView {

    private var userpickImageView: UIImageView {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage.userpicImage
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 70),
            view.heightAnchor.constraint(equalToConstant: 70)
        ])
        return view
    }
    private var exitButton: UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage.exitImage, for: .normal)
        view.setTitle("", for: .normal)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 44),
            view.heightAnchor.constraint(equalToConstant: 44)
        ])
        return view
    }
    private var nameLabel: UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Имя"
        let desc = UIFontDescriptor().withSymbolicTraits(UIFontDescriptor.SymbolicTraits([.traitBold]))!
        view.font = UIFont(descriptor: desc, size: 23)
        view.textColor = UIColor.ypWhite
        return view
    }
    private var loginLabel: UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "@login"
        view.font = view.font.withSize(13)
        view.textColor = UIColor.ypGray
        return view
    }
    private var userInfoLabel: UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Информация"
        view.font = view.font.withSize(13)
        view.textColor = UIColor.ypWhite
        return view
    }

    private var userpickRow: UIStackView {
        let view = UIStackView(arrangedSubviews: [userpickImageView, exitButton])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 0
        view.contentMode = .scaleAspectFit
        view.distribution = .equalCentering
        return view
    }
    private var allRows: UIStackView {
        let userpickRow = userpickRow

        let view = UIStackView(arrangedSubviews: [userpickRow, nameLabel, loginLabel, userInfoLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .equalSpacing
        view.spacing = 8

        NSLayoutConstraint.activate([
            userpickRow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            userpickRow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])

        return view
    }

    init() {
        super.init(frame: .zero)

        let allRows = allRows
        addSubview(allRows)
        NSLayoutConstraint.activate([
            allRows.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            allRows.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            allRows.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

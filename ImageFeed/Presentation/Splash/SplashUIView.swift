import UIKit

final class SplashUIView: UIView {

    private var logoImageView: UIImageView {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage.mainLogoImage
        return view
    }

    init() {
        super.init(frame: .zero)

        backgroundColor = UIColor.ypBlack
        let logoImageView = logoImageView
        addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

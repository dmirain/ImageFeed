import UIKit

final class ProfileViewController: BaseUIViewController {
    private let contentView: ProfileUIView
    private let profileGateway: ProfileGateway
    private let profileImageGateway: ProfileImageGateway
    private var profileImageServiceObserver: NSObjectProtocol?

    init(profileGateway: ProfileGateway, profileImageGateway: ProfileImageGateway) {
        contentView = ProfileUIView()
        self.profileGateway = profileGateway
        self.profileImageGateway = profileImageGateway
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: nil, image: UIImage.profileTabImage, selectedImage: nil)
        subscribeOnUpdateAvatar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
       self.view = contentView
    }

    func initData(token: String, handler: @escaping (NetworkError?) -> Void) {
        let requestBuilder = RequestBuilderImpl(token: token)

        profileGateway.requestBuilder = requestBuilder
        profileGateway.fetchProfile { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    self.contentView.set(profileData: data)
                }

                profileImageGateway.requestBuilder = requestBuilder
                profileImageGateway.fetchProfilePhoto(username: data.username)

                handler(nil)
            case let .failure(error):
                handler(error)
            }
        }
    }

    private func subscribeOnUpdateAvatar() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageGateway.DidChangeNotification, object: nil, queue: .main
        ) { [weak self] data in
            guard let self else { return }
            if let photoUrl = data.userInfo?["URL"] as? String {
                guard let photoUrl = URL(string: photoUrl) else { return }
                self.contentView.updateAvatar(photoUrl)
            }
        }
    }
}

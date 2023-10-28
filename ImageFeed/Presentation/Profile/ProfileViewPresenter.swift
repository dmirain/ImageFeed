import Foundation

protocol ProfileViewPresenter {
    var delegate: ProfileViewPresenterDelegate? { get set }
    func initData(handler: @escaping (NetworkError?) -> Void)
    func performExit()
}

protocol ProfileViewPresenterDelegate: AnyObject {
    func updateAvatar(_ photoUrl: URL)
    func set(profileData data: ProfileDto)
}

final class ProfileViewPresenterImpl: ProfileViewPresenter {
    private let authStorage: AuthStorage
    private let profileGateway: ProfileGateway
    private let profileImageGateway: ProfileImageGateway
    private var profileImageServiceObserver: NSObjectProtocol?

    weak var delegate: ProfileViewPresenterDelegate?

    init(
        authStorage: AuthStorage,
        profileGateway: ProfileGateway,
        profileImageGateway: ProfileImageGateway
    ) {
        self.authStorage = authStorage
        self.profileGateway = profileGateway
        self.profileImageGateway = profileImageGateway

        subscribeOnUpdateAvatar()
    }

    func initData(handler: @escaping (NetworkError?) -> Void) {
        profileGateway.fetchProfile { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(data):
                DispatchQueue.main.async { [weak self] in
                    guard let self, let delegate = self.delegate else { return }
                    delegate.set(profileData: data)
                }

                profileImageGateway.fetchProfilePhoto(username: data.username)

                handler(nil)
            case let .failure(error):
                handler(error)
            }
        }
    }

    func performExit() {
        authStorage.reset()
    }

    private func subscribeOnUpdateAvatar() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageGateway.didChangeNotification, object: nil, queue: .main
        ) { [weak self] data in
            guard let self, let delegate = self.delegate else { return }
            if let photoUrl = data.userInfo?["URL"] as? String {
                guard let photoUrl = URL(string: photoUrl) else { return }
                delegate.updateAvatar(photoUrl)
            }
        }
    }
}

import Foundation

final class ProfileImageGateway {
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    private let httpClient: NetworkClient
    private var task: URLSessionTask?
    var requestBuilder: RequestBuilder?

    init(httpClient: NetworkClient) {
        self.httpClient = httpClient
    }

    func fetchProfilePhoto(username: String) {
        guard requestBuilder != nil else { return }
        guard isLockedForNext() else { return }
        task = httpClient.fetchObject(
            from: request(username: username),
            as: ProfileImageResponse.self
        ) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(photoResponse):
                NotificationCenter.default.post(
                    name: Self.DidChangeNotification,
                    object: nil,
                    userInfo: ["URL": photoResponse.profileImage.medium]
                )
            case .failure:
                break
            }

            self.unlockForNext()
        }
    }
}

private extension ProfileImageGateway {
    func isLockedForNext() -> Bool {
        task?.cancel()
        return true
    }

    func unlockForNext() {
        task = nil
    }

    func request(username: String) -> URLRequest {
        requestBuilder!.makeRequest(path: "/users/\(username)")
    }
}

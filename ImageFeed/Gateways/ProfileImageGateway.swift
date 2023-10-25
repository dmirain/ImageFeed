import Foundation

final class ProfileImageGateway {
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    private let httpClient: NetworkClient
    private let requestBuilder: RequestBuilder
    private var task: URLSessionTask?

    init(httpClient: NetworkClient, requestBuilder: RequestBuilder) {
        self.httpClient = httpClient
        self.requestBuilder = requestBuilder
    }

    func fetchProfilePhoto(username: String) {
        guard isLockedForNext() else { return }
        task = httpClient.fetchObject(
            from: request(username: username),
            as: ProfileImageResponse.self
        ) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(photoResponse):
                NotificationCenter.default.post(
                    name: Self.didChangeNotification,
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
        requestBuilder.makeApiRequest(path: "/users/\(username)", params: [], method: "GET")
    }
}

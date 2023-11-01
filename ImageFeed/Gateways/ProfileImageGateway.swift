import Foundation

final class ProfileImageGateway {
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    private let httpClient: NetworkClient
    private let requestHelper: RequestHelper

    private var task: URLSessionTask?

    init(httpClient: NetworkClient, requestHelper: RequestHelper) {
        self.httpClient = httpClient
        self.requestHelper = requestHelper
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
        requestHelper.makeApiRequest(path: "/users/\(username)", params: [], method: "GET")
    }
}

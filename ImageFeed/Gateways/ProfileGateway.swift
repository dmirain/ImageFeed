import Foundation

final class ProfileGateway {
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    private let httpClient: NetworkClient
    private var task: URLSessionTask?
    var requestBuilder: RequestBuilder?

    init(httpClient: NetworkClient) {
        self.httpClient = httpClient
    }

    func fetchProfile(handler: @escaping (Result<ProfileDto, NetworkError>) -> Void) {
        guard requestBuilder != nil else {
            handler(.failure(.authFaild))
            return
        }

        guard isLockedForNext() else { return }

        task = httpClient.fetchObject(from: profileRequest(), as: ProfileResponse.self) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(response):
                handler(.success(ProfileDto.fromProfileResponse(response)))
                fetchProfilePhoto(username: response.username)
                self.unlockForNext()
            case let .failure(error):
                handler(.failure(error))
            }
        }
    }

    private func fetchProfilePhoto(username: String) {
        _ = httpClient.fetchObject(
            from: profilePhotoRequest(username: username),
            as: ProfileImageResponse.self
        ) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(photoResponse):
                NotificationCenter.default.post(
                    name: Self.DidChangeNotification,
                    object: self,
                    userInfo: ["URL": photoResponse.profileImage.medium]
                )
            case .failure:
                break
            }
        }
    }
}

private extension ProfileGateway {
    func isLockedForNext() -> Bool {
        assert(Thread.isMainThread)
        task?.cancel()
        return true
    }

    func unlockForNext() {
        task = nil
    }

    func profilePhotoRequest(username: String) -> URLRequest {
        requestBuilder!.makeRequest(path: "/users/\(username)")
    }

    func profileRequest() -> URLRequest {
        requestBuilder!.makeRequest(path: "/me")
    }
}

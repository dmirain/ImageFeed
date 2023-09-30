import Foundation

final class ProfileGateway {
    private let httpClient: NetworkClient
    private var task: URLSessionTask?

    init(httpClient: NetworkClient) {
        self.httpClient = httpClient
    }

    func fetchProfile(with token: String, handler: @escaping (Result<ProfileDto, NetworkError>) -> Void) {
        guard isLockedForNext() else { return }

        task = httpClient.fetchObject(from: profileRequest(token), as: ProfileResponse.self) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(response):
                handler(.success(ProfileDto.fromProfileResponse(response)))
            case let .failure(error):
                handler(.failure(error))
            }

            self.unlockForNext()
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

    func profileRequest(_ token: String) -> URLRequest {
        var components = URLComponents(url: Const.defaultBaseURL, resolvingAgainstBaseURL: true)!
        components.path = "me"
        var request = URLRequest(url: components.url!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 2 // seconds
        request.httpMethod = "GET"
        return request
    }
}

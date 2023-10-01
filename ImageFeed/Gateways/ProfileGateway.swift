import Foundation

final class ProfileGateway {
    private let httpClient: NetworkClient
    private let requestBuilder: RequestBuilder
    private var task: URLSessionTask?
    private var photoTask: URLSessionTask?

    init(httpClient: NetworkClient, requestBuilder: RequestBuilder) {
        self.httpClient = httpClient
        self.requestBuilder = requestBuilder
    }

    func fetchProfile(handler: @escaping (Result<ProfileDto, NetworkError>) -> Void) {
        guard isLockedForNext() else { return }

        task = httpClient.fetchObject(from: profileRequest(), as: ProfileResponse.self) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(response):
                photoTask = httpClient.fetchObject(
                    from: profilePhotoRequest(username: response.username),
                    as: ProfileImageResponse.self
                ) { [weak self] result in
                    guard let self else { return }

                    switch result {
                    case let .success(photoResponse):
                        handler(.success(ProfileDto.fromProfileResponse(response, photoData: photoResponse)))
                    case let .failure(error):
                        handler(.failure(error))
                    }
                    self.unlockForNext()
                }
            case let .failure(error):
                handler(.failure(error))
            }
        }
    }

}

private extension ProfileGateway {
    func isLockedForNext() -> Bool {
        assert(Thread.isMainThread)
        task?.cancel()
        photoTask?.cancel()
        return true
    }

    func unlockForNext() {
        task = nil
        photoTask = nil
    }

    func profilePhotoRequest(username: String) -> URLRequest {
        requestBuilder.makeRequest(path: "/users/\(username)")
    }

    func profileRequest() -> URLRequest {
        requestBuilder.makeRequest(path: "/me")
    }
}

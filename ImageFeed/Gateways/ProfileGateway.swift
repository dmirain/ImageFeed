import Foundation

final class ProfileGateway {
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

        task = httpClient.fetchObject(from: request(), as: ProfileResponse.self) { [weak self] result in
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

    func request() -> URLRequest {
        requestBuilder!.makeRequest(path: "/me", params: [])
    }
}

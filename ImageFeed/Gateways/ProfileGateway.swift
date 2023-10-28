import Foundation

final class ProfileGateway {
    private let httpClient: NetworkClient
    private let requestHelper: RequestHelper

    private var task: URLSessionTask?

    init(httpClient: NetworkClient, requestHelper: RequestHelper) {
        self.httpClient = httpClient
        self.requestHelper = requestHelper
    }

    func fetchProfile(handler: @escaping (Result<ProfileDto, NetworkError>) -> Void) {
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
        requestHelper.makeApiRequest(path: "/me", params: [], method: "GET")
    }
}

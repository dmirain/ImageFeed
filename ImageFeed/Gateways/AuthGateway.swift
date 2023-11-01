import Foundation

final class AuthGateway {
    private let httpClient: NetworkClient
    private let requestHelper: RequestHelper

    private var task: URLSessionTask?
    private var lastCode: String?

    init(httpClient: NetworkClient, requestHelper: RequestHelper) {
        self.httpClient = httpClient
        self.requestHelper = requestHelper
    }

    func fetchAuthToken(with code: String, handler: @escaping (Result<AuthDto, NetworkError>) -> Void) {
        guard isLockedForNext(with: code) else { return }

        task = httpClient.fetchObject(from: request(code), as: TokenResponse.self) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(oauthData):
                handler(self.convertData(oauthData: oauthData))
            case let .failure(error):
                handler(.failure(error))
            }

            self.unlockForNext()
        }
    }

}

private extension AuthGateway {
    func isLockedForNext(with code: String) -> Bool {
        assert(Thread.isMainThread)
        if lastCode == code { return false }
        task?.cancel()
        lastCode = code
        return true
    }

    func unlockForNext() {
        task = nil
        lastCode = nil
    }

    func convertData(oauthData: TokenResponse) -> Result<AuthDto, NetworkError> {
        guard !oauthData.accessToken.isEmpty else { return .failure(NetworkError.emptyData) }
        return .success(AuthDto(token: oauthData.accessToken))
    }

    func request(_ code: String) -> URLRequest {
        requestHelper.makeToketRequest(code: code)
    }
}

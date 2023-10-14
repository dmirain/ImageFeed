import Foundation

final class UnsplashAuthGateway: AuthGateway {
    private let httpClient: NetworkClient
    private var task: URLSessionTask?
    private var lastCode: String?

    init(httpClient: NetworkClient) {
        self.httpClient = httpClient
    }

    func fetchAuthToken(with code: String, handler: @escaping (Result<AuthDto, NetworkError>) -> Void) {
        guard isLockedForNext(with: code) else { return }

        task = httpClient.fetchObject(from: request(code), as: UnsplashOAuthData.self) { [weak self] result in
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

private extension UnsplashAuthGateway {
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

    func convertData(oauthData: UnsplashOAuthData) -> Result<AuthDto, NetworkError> {
        guard !oauthData.accessToken.isEmpty else { return .failure(NetworkError.emptyData) }
        return .success(AuthDto(token: oauthData.accessToken))
    }

    func request(_ code: String) -> URLRequest {
        var components = URLComponents(string: "https://unsplash.com/oauth/token")!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: Const.accessKey),
            URLQueryItem(name: "client_secret", value: Const.secretKey),
            URLQueryItem(name: "redirect_uri", value: Const.redirectURI),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code)
        ]
        var request = URLRequest(url: components.url!)
        request.timeoutInterval = 2 // seconds
        request.httpMethod = "POST"
        return request
    }
}

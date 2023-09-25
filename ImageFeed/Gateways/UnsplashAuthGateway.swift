import Foundation

final class UnsplashAuthGateway: AuthGateway {
    private let httpClient: NetworkClient

    init(httpClient: NetworkClient) {
        self.httpClient = httpClient
    }

    func fetchAuthToken(with code: String, handler: @escaping (Result<AuthData, NetworkError>) -> Void) {
        httpClient.fetch(request: request(code)) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(authRawData):
                handler(self.convertData(data: authRawData))
            case let .failure(error):
                handler(.failure(error))
            }
        }
    }

    private func convertData(data: Data) -> Result<AuthData, NetworkError> {
        guard let oauthData = data.fromJson(to: UnsplashOAuthData.self) else {
            return .failure(NetworkError.parseError)
        }
        guard !oauthData.token.isEmpty else { return .failure(NetworkError.emptyData) }
        return .success(AuthData(token: oauthData.token))
    }

    private func request(_ code: String) -> URLRequest {
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

import Foundation

final class UnsplashAuthGateway: AuthGateway {
    private let httpClient: NetworkClient

    init(httpClient: NetworkClient) {
        self.httpClient = httpClient
    }

    func authenticate(with code: String) async throws -> AuthData {
        let authRawData = try await httpClient.fetch(request: request(code))
        return try convertData(data: authRawData)
    }

    private func convertData(data: Data) throws -> AuthData {
        guard let oauthData = data.fromJson(to: UnsplashOAuthData.self) else {
            throw NetworkError.parseError
        }
        guard !oauthData.token.isEmpty else { throw NetworkError.emptyData }
        return AuthData(token: oauthData.token)
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

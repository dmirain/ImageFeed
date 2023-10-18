import Foundation

protocol RequestBuilder {
    func makeRequest(path: String, params: [URLQueryItem]) -> URLRequest
}

struct RequestBuilderImpl: RequestBuilder {
    private let token: String

    init(token: String) {
        self.token = token
    }

    func makeRequest(path: String, params: [URLQueryItem]) -> URLRequest {
        var components = URLComponents(url: Const.defaultBaseURL, resolvingAgainstBaseURL: true)!
        components.path = path
        components.queryItems = params
        var request = URLRequest(url: components.url!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 5 // seconds
        request.httpMethod = "GET"
        return request
    }
}

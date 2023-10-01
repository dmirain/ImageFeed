import Foundation

protocol RequestBuilder {
    func makeRequest(path: String) -> URLRequest
}

struct RequestBuilderImpl: RequestBuilder {
    let token: String

    func makeRequest(path: String) -> URLRequest {
        var components = URLComponents(url: Const.defaultBaseURL, resolvingAgainstBaseURL: true)!
        components.path = path
        var request = URLRequest(url: components.url!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 2 // seconds
        request.httpMethod = "GET"
        return request
    }
}

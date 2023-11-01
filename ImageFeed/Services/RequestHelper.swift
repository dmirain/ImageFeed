import Foundation

protocol RequestHelper {
    func makeAuthorizeRequest() -> URLRequest
    func makeToketRequest(code: String) -> URLRequest
    func makeApiRequest(path: String, params: [URLQueryItem], method: String) -> URLRequest
    func extractCode(from url: URL) -> String?
}

struct RequestHelperImpl: RequestHelper {
    private let authStorage: AuthStorage
    private let apiConf: UnsplashApiConfig

    private var token: String { authStorage.get()?.token ?? "" }

    init(authStorage: AuthStorage, unsplashApiConfig: UnsplashApiConfig) {
        self.authStorage = authStorage
        self.apiConf = unsplashApiConfig
    }

    func makeApiRequest(path: String, params: [URLQueryItem], method: String) -> URLRequest {
        var components = URLComponents()
        components.scheme = apiConf.scheme
        components.host = apiConf.apiHost
        components.path = path
        components.queryItems = params
        var request = URLRequest(url: components.url!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 5 // seconds
        request.httpMethod = method
        return request
    }

    func makeAuthorizeRequest() -> URLRequest {
        var components = URLComponents()
        components.scheme = apiConf.scheme
        components.host = apiConf.serviceHost
        components.path = "/oauth/authorize"

        components.queryItems = [
            URLQueryItem(name: "client_id", value: apiConf.accessKey),
            URLQueryItem(name: "redirect_uri", value: apiConf.redirectURI),
            URLQueryItem(name: "response_type", value: apiConf.responseType),
            URLQueryItem(name: "scope", value: apiConf.accessScope)
        ]
        return URLRequest(url: components.url!)
    }

    func makeToketRequest(code: String) -> URLRequest {
        var components = URLComponents()
        components.scheme = apiConf.scheme
        components.host = apiConf.serviceHost
        components.path = "/oauth/token"

        components.queryItems = [
            URLQueryItem(name: "client_id", value: apiConf.accessKey),
            URLQueryItem(name: "client_secret", value: apiConf.secretKey),
            URLQueryItem(name: "redirect_uri", value: apiConf.redirectURI),
            URLQueryItem(name: "grant_type", value: apiConf.grantType),
            URLQueryItem(name: "code", value: code)
        ]
        var request = URLRequest(url: components.url!)
        request.timeoutInterval = 2 // seconds
        request.httpMethod = "POST"
        return request
    }

    func extractCode(from url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" }) {
            return codeItem.value
        } else {
            return nil
        }
    }
}

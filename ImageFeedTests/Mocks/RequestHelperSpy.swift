import Foundation
@testable import ImageFeed

final class RequestHelperSpy: RequestHelper {
    let request = URLRequest(url: URL(string: "https://ya.ru")!)
    let code = "code"

    var makeAuthorizeRequestCalled = false
    var extractCodeCalled = false

    func makeAuthorizeRequest() -> URLRequest {
        makeAuthorizeRequestCalled = true
        return request
    }

    func extractCode(from url: URL) -> String? {
        extractCodeCalled = true
        return code
    }

    func makeToketRequest(code: String) -> URLRequest { request }
    func makeApiRequest(path: String, params: [URLQueryItem], method: String) -> URLRequest { request }
}

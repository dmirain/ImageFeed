import XCTest
@testable import ImageFeed

final class RequestHelperImplTests: XCTestCase {

    var helper: RequestHelperImpl!

    override func setUpWithError() throws {
        self.helper = RequestHelperImpl(
            authStorage: AuthStorageStub.shared,
            unsplashApiConfig: UnsplashApiConfig.production
        )
    }

    func testMakeAuthorizeRequest() throws {
        // when
        let urlString = helper.makeAuthorizeRequest().url!.absoluteString

        // then
        XCTAssertTrue(urlString.contains(UnsplashApiConfig.production.accessKey))
        XCTAssertTrue(urlString.contains(UnsplashApiConfig.production.redirectURI))
        XCTAssertTrue(urlString.contains(UnsplashApiConfig.production.responseType))
        XCTAssertTrue(urlString.contains(UnsplashApiConfig.production.accessScope))
    }

    func testExtractCode() throws {
        // given
        let url = URL(string: "https://ya.ru/oauth/authorize/native?code=testCode")!

        // when
        let result = helper.extractCode(from: url)

        // then
        XCTAssertEqual(result, "testCode")
    }
}

final class AuthStorageStub: AuthStorage {
    static var shared: AuthStorage = AuthStorageStub()
    private init() {}
    func get() -> AuthDto? { AuthDto(token: "token") }
    func set(_ newValue: AuthDto) -> Bool { true }
    func reset() {}
}

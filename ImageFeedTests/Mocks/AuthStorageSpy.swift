import Foundation

@testable import ImageFeed

final class AuthStorageSpy: AuthStorage {
    static var shared: AuthStorage = AuthStorageSpy()

    var resetCalled = false

    func get() -> AuthDto? { AuthDto(token: "token") }
    func set(_ newValue: AuthDto) -> Bool { true }
    func reset() { resetCalled = true }
}

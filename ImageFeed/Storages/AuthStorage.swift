import Foundation
import SwiftKeychainWrapper

protocol AuthStorage {
    static var shared: AuthStorage { get }
    func get() -> AuthDto?
    func set(_ newValue: AuthDto) -> Bool
    func reset()
}

struct AuthStorageImpl: AuthStorage {
    static let shared: AuthStorage = Self()

    private let storageKey = "authData"
    private init() {}

    func get() -> AuthDto? {
        guard let jsonData = KeychainWrapper.standard.string(forKey: storageKey) else { return nil }
        return try? jsonData.data(using: .utf8)?.fromJson(to: AuthDto.self)
    }

    func set(_ newValue: AuthDto) -> Bool {
        guard let jsonData = Data.toJson(from: newValue) else { return false }
        return KeychainWrapper.standard.set(String(data: jsonData, encoding: .utf8)!, forKey: storageKey)
    }

    func reset() {
        KeychainWrapper.standard.removeObject(forKey: storageKey)
    }
}

import Foundation
import SwiftKeychainWrapper

protocol AuthStorage {
    static var shared: AuthStorage { get }
    func get() -> AuthDto?
    func set(_ newValue: AuthDto) -> Bool
    func reset()
}

class AuthStorageImpl: AuthStorage {
    static let shared: AuthStorage = AuthStorageImpl()

    private let storageKey = "authData"
    private var cache: AuthDto?

    private init() {}

    func get() -> AuthDto? {
        if cache == nil {
            guard let jsonData = KeychainWrapper.standard.string(forKey: storageKey) else { return nil }
            cache = try? jsonData.data(using: .utf8)?.fromJson(to: AuthDto.self)
        }
        return cache
    }

    func set(_ newValue: AuthDto) -> Bool {
        cache = newValue
        guard let jsonData = Data.toJson(from: newValue) else { return false }
        return KeychainWrapper.standard.set(String(data: jsonData, encoding: .utf8)!, forKey: storageKey)
    }

    func reset() {
        cache = nil
        KeychainWrapper.standard.removeObject(forKey: storageKey)
    }
}

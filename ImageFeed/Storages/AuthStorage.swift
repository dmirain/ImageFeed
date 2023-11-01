import Foundation
import SwiftKeychainWrapper
import WebKit

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

        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища.
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища.
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }

        KeychainWrapper.standard.removeObject(forKey: storageKey)
    }
}

import Foundation

struct UserDeafaultsAuthStorage: AuthStorage {
    static let shared: AuthStorage = Self()

    private let storageKey = "authData"
    private let userDefaults = UserDefaults.standard

    private init() {}

    func get() -> AuthDto? {
        guard let jsonData = userDefaults.data(forKey: storageKey) else { return nil }
        guard let dto = jsonData.fromJson(to: AuthDto.self) else { return nil }
        return dto
    }

    func set(_ newValue: AuthDto) {
        guard let jsonData = Data.toJson(from: newValue) else { return }
        userDefaults.set(jsonData, forKey: storageKey)
    }

    func reset() {
        userDefaults.removeObject(forKey: storageKey)
    }
}

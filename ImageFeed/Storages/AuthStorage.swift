protocol AuthStorage {
    static var shared: AuthStorage { get }
    func get() -> AuthData?
    func set(_ newValue: AuthData)
    func reset()
}

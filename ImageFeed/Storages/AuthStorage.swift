protocol AuthStorage {
    static var shared: AuthStorage { get }
    func get() -> AuthDto?
    func set(_ newValue: AuthDto)
    func reset()
}

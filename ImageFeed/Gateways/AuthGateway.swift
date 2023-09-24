protocol AuthGateway {
    func authenticate(with code: String) async throws -> AuthData
}

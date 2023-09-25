protocol AuthGateway {
    func fetchAuthToken(with code: String, handler: @escaping (Result<AuthData, NetworkError>) -> Void)
}

protocol AuthGateway {
    func fetchAuthToken(with code: String, handler: @escaping (Result<AuthDto, NetworkError>) -> Void)
}

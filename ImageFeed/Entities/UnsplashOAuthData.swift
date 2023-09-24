struct UnsplashOAuthData: Decodable {
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }

    let token: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}

struct UnsplashOAuthData: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}

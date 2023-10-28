struct UnsplashApiConfig {
    static let production = Self(
        accessKey: "7km4bSI2aPRq9Z7lHH-HkWFYnVfayjE8wZc1Ekm99f8",
        secretKey: "Jp85u8E0sOqqu1d58BgANZimPY_kRu694oSD1jJzL68",
        redirectURI: "urn:ietf:wg:oauth:2.0:oob",
        accessScope: "public+read_user+write_likes",
        responseType: "code",
        grantType: "authorization_code",

        scheme: "https",
        apiHost: "api.unsplash.com",
        serviceHost: "unsplash.com"
    )

    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let responseType: String
    let grantType: String

    let scheme: String
    let apiHost: String
    let serviceHost: String
}

struct ProfileDto {
    let username: String
    let name: String
    let loginName: String
    let bio: String

    static func fromProfileResponse(_ data: ProfileResponse) -> Self {
        let name: String
        if let lastName = data.lastName {
            name = "\(data.firstName) \(lastName)"
        } else {
            name = data.firstName
        }

        return Self(
            username: data.username,
            name: name,
            loginName: "@\(data.username)",
            bio: data.bio ?? ""
        )
    }
}

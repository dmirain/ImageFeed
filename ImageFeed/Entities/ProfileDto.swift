struct ProfileDto {
    let username: String
    let name: String
    let loginName: String
    let bio: String
    
    static func fromProfileResponse(_ data: ProfileResponse) -> ProfileDto {
        return ProfileDto(
            username: data.username,
            name: "\(data.firstName) \(data.lastName)",
            loginName: "@\(data.username)",
            bio: data.bio
        )
    }
}

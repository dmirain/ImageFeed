struct ProfileDto {
    let username: String
    let name: String
    let loginName: String
    let bio: String
    let smallPhotoUrl: String

    static func fromProfileResponse(_ data: ProfileResponse, photoData: ProfileImageResponse) -> Self {
        Self(
            username: data.username,
            name: "\(data.firstName) \(data.lastName)",
            loginName: "@\(data.username)",
            bio: data.bio,
            smallPhotoUrl: photoData.profileImage.small
        )
    }
}

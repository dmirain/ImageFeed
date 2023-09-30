struct ProfileResponse: Decodable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String
}

struct ProfileImageResponse: Decodable {
    let profileImage: ProfileImage
}

struct ProfileImage: Decodable {
    let small: String
    let medium: String
}

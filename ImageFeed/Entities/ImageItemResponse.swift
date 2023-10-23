import Foundation

struct ImageItemResponse: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: ImageLinks
}

struct ImageLinks: Decodable {
    let thumb: String
    let full: String
}

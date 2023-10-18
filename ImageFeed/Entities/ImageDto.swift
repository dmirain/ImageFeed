import Foundation

struct ImageDto {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let description: String?
    let thumbImageURL: URL?
    let largeImageURL: URL?
    let isLiked: Bool
    
    static func fromImageItemResponse(_ data: ImageItemResponse) -> Self {
        Self(
            id: data.id,
            size: CGSize(width: data.width, height: data.height),
            createdAt: data.createdAt.dateFromISO(),
            description: data.description,
            thumbImageURL: URL(string: data.urls.thumb),
            largeImageURL: URL(string: data.urls.full),
            isLiked: data.likedByUser
        )
    }
}

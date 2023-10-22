import Foundation

struct ImageDto: Hashable {
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
    
    static func ==(lhs: ImageDto, rhs: ImageDto) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func copy(isLiked: Bool) -> Self {
        Self(
            id: self.id,
            size: self.size,
            createdAt: self.createdAt,
            description: self.description,
            thumbImageURL: self.thumbImageURL,
            largeImageURL: self.largeImageURL,
            isLiked: isLiked
        )
    }
}

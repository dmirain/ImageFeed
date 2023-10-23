import UIKit

final class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImageListTableDidChange")

    weak var controller: ImagesListViewController?
    private let imageListGateway: ImagesListGateway
    private let imageLikeGateway: ImageLikeGateway
    private var images: [ImageDto] = []
    private var nextPage: Int = 1

    var imagesCount: Int { images.count }

    init(imageListGateway: ImagesListGateway, imageLikeGateway: ImageLikeGateway) {
        self.imageListGateway = imageListGateway
        self.imageLikeGateway = imageLikeGateway
    }

    func fetchPhotosNextPage() {
        self.imageListGateway.fetchImagesPage(page: nextPage) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    self.addPageData(data: data)
                }
            case .failure:
                break
                // TODO обработать ошибку
            }
        }
    }

    private func addPageData(data: [ImageDto]) {
        let oldCount = imagesCount
        images.append(contentsOf: data)
        nextPage += 1
        let newCount = imagesCount

        NotificationCenter.default.post(
            name: Self.didChangeNotification,
            object: nil,
            userInfo: ["addedIndexes": oldCount..<newCount]
        )
    }

    func imageHeight(byIndex index: Int, containerWidth: CGFloat) -> CGFloat {
        let image = imageCellModel(byIndex: index)
        return image.size.height * containerWidth / image.size.width
    }

    func imageCellModel(byIndex index: Int) -> ImageDto {
        images[index]
    }

    func toggleLike(byIndex index: Int) {
        let image = images[index]
        let newState = !image.isLiked

        imageLikeGateway.toggleLike(image: image, to: newState) { [weak self] error in
            guard let self else { return }

            let setState: Bool
            if error == nil {
                setState = image.isLiked
            } else {
                setState = newState
            }

            DispatchQueue.main.async {
                self.updateLiked(image: image, newState: setState)
            }
        }
    }

    private func updateLiked(image: ImageDto, newState: Bool) {
        let newImage = image.copy(isLiked: newState)
        guard let index = images.firstIndex(of: image) else { return }
        images[index] = newImage
        controller?.reloadRow(at: index)
    }
}

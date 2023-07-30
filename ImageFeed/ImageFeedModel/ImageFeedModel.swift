import UIKit

final class ImageFeedModel {
    private static let photos = (0..<20).map { UIImage(named: "\($0)") ?? UIImage() }

    var imagesCount: Int { Self.photos.count }

    func imageHeight(byIndex index: Int, containerWidth: CGFloat) -> CGFloat {
        let image = image(byIndex: index)
        return image.size.height * containerWidth / image.size.width
    }

    func rowState(byIndex index: Int) -> RowState {
        let image = image(byIndex: index)
        let rowState = RowState(
            date: Date(),
            liked: index % 2 != 0,
            image: image
        )
        return rowState
    }

    private func image(byIndex index: Int) -> UIImage {
        Self.photos[index]
    }
}

import Foundation

protocol ImagesListViewPresenter: ImagesListServiceDelegate {
    var delegate: ImagesListViewControllerDelegate? { get set }
    var imagesCount: Int { get }

    func reloadRow(at index: Int)
    func rowWillDisplay(index: Int)
    func toggleLike(byIndex index: Int)
    func fetchPhotosNextPage()
    func image(byIndex index: Int) -> ImageDto
    func imageHeight(byIndex index: Int, containerWidth: CGFloat) -> CGFloat
}

final class ImagesListViewPresenterImpl: ImagesListViewPresenter {

    private let imagesListService: ImagesListService
    private var imageTableObserver: NSObjectProtocol?
    weak var delegate: ImagesListViewControllerDelegate?

    var imagesCount: Int { imagesListService.imagesCount }

    init(imagesListService: ImagesListService) {
        self.imagesListService = imagesListService

        self.imagesListService.delegate = self
        subscribeOnTableUpdate()
    }

    func reloadRow(at index: Int) {
        delegate?.reloadRow(at: index)
    }

    func rowWillDisplay(index: Int) {
        if index > imagesListService.imagesCount - 3 {
            imagesListService.fetchPhotosNextPage()
        }
    }

    func toggleLike(byIndex index: Int) {
        imagesListService.toggleLike(byIndex: index)
    }

    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }

    func image(byIndex index: Int) -> ImageDto {
        imagesListService.image(byIndex: index)
    }

    func imageHeight(byIndex index: Int, containerWidth: CGFloat) -> CGFloat {
        imagesListService.imageHeight(byIndex: index, containerWidth: containerWidth)
    }

    private func subscribeOnTableUpdate() {
        imageTableObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification, object: nil, queue: .main
        ) { [weak delegate] data in
            guard let delegate else { return }

            if let addedIndexes = data.userInfo?["addedIndexes"] as? Range<Int> {
                delegate.updateTableViewAnimated(addedIndexes: addedIndexes)
            }
        }
    }
}

import Foundation
import UIKit
@testable import ImageFeed

final class ImagesListViewPresenterSpy: ImagesListViewPresenter {
    weak var delegate: ImagesListViewControllerDelegate?

    var imagesCountCalled = false
    var reloadRowCalled = false
    var rowWillDisplayCalled = false
    var toggleLikeCalled = false
    var fetchPhotosNextPageCalled = false
    var imageByIndexCalled = false
    var imageHeightCalled = false

    let count = 100_500
    let height = CGFloat(50)
    let image = ImageDto(
        id: "qwerty",
        size: CGSize(width: 10, height: 10),
        createdAt: Date(),
        description: nil,
        thumbImageURL: URL(string: "https://ya.ru")!,
        largeImageURL: URL(string: "https://ya.ru")!,
        isLiked: false
    )

    var imagesCount: Int {
        imagesCountCalled = true
        return count
    }

    func reloadRow(at index: Int) {
        reloadRowCalled = true
    }

    func rowWillDisplay(index: Int) {
        rowWillDisplayCalled = true
    }

    func toggleLike(byIndex index: Int) {
        toggleLikeCalled = true
    }

    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }

    func image(byIndex index: Int) -> ImageDto {
        imageByIndexCalled = true
        return image
    }

    func imageHeight(byIndex index: Int, containerWidth: CGFloat) -> CGFloat {
        imageHeightCalled = true
        return height
    }
}

final class ImagesListViewSpy: UIView, ImagesListTableUIView {
    var setDelegatesCalled = false
    var initOnDidLoadCalled = false
    var reloadRowCalled = false
    var updateTableViewAnimatedCalled = false
    var rowIndexCalled = false

    let cellRowIndex = 100_500

    func setDelegates(tableDataSource: UITableViewDataSource, tableDelegate: UITableViewDelegate) {
        setDelegatesCalled = true
    }

    func initOnDidLoad() {
        initOnDidLoadCalled = true
    }

    func reloadRow(at index: Int) {
        reloadRowCalled = true
    }

    func updateTableViewAnimated(addedIndexes: Range<Int>) {
        updateTableViewAnimatedCalled = true
    }

    func rowIndex(for cell: ImageFeed.ImagesListCell) -> Int? {
        rowIndexCalled = true
        return cellRowIndex
    }
}

final class SingleImageViewControllerSpy: UIViewController, SingleImageViewController {
    var setImageCalled = false
    var image: ImageDto!

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(image: ImageDto) {
        self.image = image
        setImageCalled = true
    }
}

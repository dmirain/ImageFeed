import XCTest
@testable import ImageFeed

final class ImagesListViewControllerTests: XCTestCase {

    var view: ImagesListViewSpy!
    var presenter: ImagesListViewPresenterSpy!
    var singleImageViewController: SingleImageViewControllerSpy!
    var controller: ImagesListViewController!

    override func setUpWithError() throws {
        view = ImagesListViewSpy()
        presenter = ImagesListViewPresenterSpy()
        singleImageViewController = SingleImageViewControllerSpy()

        controller = ImagesListViewController(
            singleImageViewController: singleImageViewController,
            presenter: presenter,
            contentView: view
        )
    }

    func testControllerViewLoad() throws {
        // when
        _ = controller.view

        // then
        XCTAssertTrue(view.initOnDidLoadCalled)
        XCTAssertTrue(view.setDelegatesCalled)
    }

    func testFetchPhotosNextPage() throws {
        // when
        controller.fetchPhotosNextPage()

        // then
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled)
    }

    func testReloadRow() throws {
        // given
        let index = 10

        // when
        controller.reloadRow(at: index)

        // then
        XCTAssertTrue(view.reloadRowCalled)
    }

    func testUpdateTableViewAnimatedBeforeTableInit() throws {
        // when
        controller.updateTableViewAnimated(addedIndexes: 10..<20)

        // then
        XCTAssertFalse(view.updateTableViewAnimatedCalled)
    }

    func testUpdateTableViewAnimatedAfterTableInit() throws {
        // when
        _ = controller.tableView(UITableView(), numberOfRowsInSection: 0)
        controller.updateTableViewAnimated(addedIndexes: 10..<20)

        // then
        XCTAssertTrue(view.updateTableViewAnimatedCalled)
    }

    func testNumberOfRowsInSection() throws {
        // when
        let result = controller.tableView(UITableView(), numberOfRowsInSection: 0)

        // then
        XCTAssertTrue(presenter.imagesCountCalled)
        XCTAssertEqual(presenter.count, result)
    }

    func testHeightForRowAt() throws {
        // when
        let result = controller.tableView(UITableView(), heightForRowAt: IndexPath(row: 1, section: 0))

        // then
        XCTAssertTrue(presenter.imageHeightCalled)
        XCTAssertEqual(presenter.height + Const.cellIndent, result)
    }

    func testRowWillDisplay() throws {
        // when
        controller.tableView(UITableView(), willDisplay: UITableViewCell(), forRowAt: IndexPath(row: 1, section: 0))

        // then
        XCTAssertTrue(presenter.rowWillDisplayCalled)
    }
}

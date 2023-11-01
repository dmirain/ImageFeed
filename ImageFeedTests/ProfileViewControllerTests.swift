import XCTest
@testable import ImageFeed

final class ProfileViewControllerTests: XCTestCase {

    var view: ProfileUIViewSpy!
    var presenter: ProfileViewPresenterSpy!
    var controller: ProfileViewController!
    var scene: ProfileViewControllerDelegateSpy!
    var allert: AlertPresenterSpy!

    override func setUpWithError() throws {
        view = ProfileUIViewSpy()
        presenter = ProfileViewPresenterSpy()
        scene = ProfileViewControllerDelegateSpy()
        allert = AlertPresenterSpy()
        controller = ProfileViewController(
            delegate: scene,
            presenter: presenter,
            alertPresenter: allert,
            contentView: view
        )
    }

    func testInitData() throws {
        // when
        controller.initData { _ in }

        // then
        XCTAssertTrue(presenter.initDataCalled)
    }

    func testUpdateAvatar() throws {
        // given
        let url = URL(string: "https://ya.ru")!

        // when
        controller.updateAvatar(url)

        // then
        XCTAssertTrue(view.updateAvatarCalled)
        XCTAssertEqual(view.photoUrl, url)
    }

    func testSetData() throws {
        // given
        let data = ProfileDto(username: "dmirain", name: "dmirain", loginName: "dmirain", bio: "")

        // when
        controller.set(profileData: data)

        // then
        XCTAssertTrue(view.setCalled)
        XCTAssertEqual(view.data.username, data.username)
    }

    func testExitButtonClicked() throws {
        // when
        controller.exitButtonClicked()

        // then
        XCTAssertTrue(allert.showCalled)
    }
}

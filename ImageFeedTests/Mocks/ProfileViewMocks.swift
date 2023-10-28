import Foundation
import UIKit
@testable import ImageFeed

final class ProfileViewPresenterSpy: ProfileViewPresenter {
    weak var delegate: ProfileViewPresenterDelegate?

    var initDataCalled = false
    var performExitCalled = false

    func initData(handler: @escaping (ImageFeed.NetworkError?) -> Void) {
        initDataCalled = true
    }

    func performExit() {
        performExitCalled = true
    }
}

final class ProfileUIViewSpy: UIView, ProfileUIView {
    weak var delegate: ProfileUIViewDelegat?

    var setCalled = false
    var updateAvatarCalled = false

    var data: ProfileDto!
    var photoUrl: URL!

    func set(profileData data: ProfileDto) {
        setCalled = true
        self.data = data
    }

    func updateAvatar(_ photoUrl: URL) {
        updateAvatarCalled = true
        self.photoUrl = photoUrl
    }
}

final class ProfileViewControllerDelegateSpy: ProfileViewControllerDelegate {
    var roteToRootCalled = false

    func roteToRoot() {
        roteToRootCalled = true
    }
}

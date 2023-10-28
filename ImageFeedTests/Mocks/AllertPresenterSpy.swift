import Foundation

@testable import ImageFeed

final class AlertPresenterSpy: AlertPresenter {
    weak var delegate: ImageFeed.AlertPresenterDelegate?

    var showCalled = false

    func show(with alertDto: AlertDto) {
        showCalled = true
    }
}

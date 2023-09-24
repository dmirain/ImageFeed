import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func presentAlert(_ alert: UIAlertController)
    func performAlertAction(action: AlertAction)
}

protocol AlertPresenter {
    var delegate: AlertPresenterDelegate? { get set }

    func show(with alertDto: AlertDto)
}

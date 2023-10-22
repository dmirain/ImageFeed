import UIKit

final class AlertPresenterImpl: AlertPresenter {
    weak var delegate: AlertPresenterDelegate?

    func show(with alertDto: AlertDto) {
        let alert = UIAlertController(
            title: alertDto.headerTitle,
            message: alertDto.message,
            preferredStyle: .alert
        )
        alert.view.accessibilityIdentifier = "Alert"

        alertDto.actions.forEach { actionType in
            let title: String
            switch actionType {
            case .reset(actionText: let actionText):
                title = actionText
            case .exit(actionText: let actionText):
                title = actionText
            case .doNothing(actionText: let actionText):
                title = actionText
            }
                        
            let action = UIAlertAction(title: title, style: .default) { [weak self] _ in
                guard let self else {
                    return
                }
                self.delegate?.performAlertAction(action: actionType)
            }
            alert.addAction(action)
        }

        delegate?.presentAlert(alert)
    }
}

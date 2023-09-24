import UIKit

final class AuthViewController: BaseUIViewController {
    private let showAuthWebViewIdentifier = "ShowAuthWebView"

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthWebViewIdentifier {
            guard let viewController = segue.destination as? WebViewViewController else {
                assertionFailure("unknown controller \(segue.destination)")
                return
            }
            viewController.delegate = self
        } else {
            assertionFailure("unknown segue identifier \(segue.identifier ?? "")")
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

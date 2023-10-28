import UIKit
import WebKit

protocol WebViewViewDelegat: AnyObject {
    func backButtonClicked()
    func extractCode(from url: URL) -> Bool
    func calculateProgress(for: Double) -> Progress
}

protocol WebViewView: UIView {
    var delegate: WebViewViewDelegat? { get set }
    func load(_ request: URLRequest)
    func willAppear()
}

final class WebViewViewImpl: UIView, WebViewView {

    weak var delegate: WebViewViewDelegat?
    private var observation: NSKeyValueObservation?

    @objc private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypWhite
        return view
    }()

    private lazy var backButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage.backBlack, for: .normal)
        view.setTitle("", for: .normal)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 44),
            view.widthAnchor.constraint(equalToConstant: 44)
        ])
        return view
    }()

    private var progressView: UIProgressView = {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.progressTintColor = .ypBlack
        return view
    }()

     init() {
        super.init(frame: .zero)
        backgroundColor = .ypBlack

        addSubview(webView)
        addSubview(backButton)
        addSubview(progressView)

        webView.navigationDelegate = self
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            webView.topAnchor.constraint(equalTo: self.topAnchor),
            webView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),

            backButton.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func load(_ request: URLRequest) {
        webView.load(request)
    }

    func willAppear() {
        observation = observe(\.webView.estimatedProgress) { [weak self] _, _ in
            self?.updateProgress()
        }
    }

    @objc
    private func backButtonClicked() {
        delegate?.backButtonClicked()
    }

    private func updateProgress() {
        guard let delegate else { return }
        let progress = delegate.calculateProgress(for: webView.estimatedProgress)

        progressView.progress = progress.value
        progressView.isHidden = progress.toHide
    }
}

extension WebViewViewImpl: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let delegate else {
            assertionFailure("Missed controller in WebViewView")
            return
        }

        if let url = navigationAction.request.url, delegate.extractCode(from: url) {
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

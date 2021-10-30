//
//  QRCodeView.swift
//  Libralize-iOS
//
//  Created by Libralize on 13/10/2021.
//

import UIKit
import WebKit

public class QRCodeView: UIView {

    private var size: Int
    private var qrString = ""

    private lazy var widthConstraint = widthAnchor.constraint(equalToConstant: CGFloat(size))
    private lazy var heightConstraint = heightAnchor.constraint(equalToConstant: CGFloat(size))

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.isHidden = true
        return indicator
    }()

    private lazy var webviewDelegate = WebviewDelegate { [weak self] in
        self?.loadingIndicator.isHidden = true
        self?.errorLabel.isHidden = true
        self?.loadingIndicator.stopAnimating()
        self?.webView.isHidden = false
    } onFailed: { [weak self] error in
        self?.loadingIndicator.isHidden = true
        self?.errorLabel.isHidden = false
        self?.loadingIndicator.stopAnimating()
        self?.webView.isHidden = true
    }

    private lazy var webView: WKWebView = {
        let webview = WKWebView()
        webview.navigationDelegate = webviewDelegate
        webview.scrollView.isScrollEnabled = false
        webview.isHidden = true
        return webview
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textColor = .red
        label.text = "Failed to load"
        return label
    }()
    
    /// Constructor
    ///
    /// - Parameter qrData: QRData from payment
    /// - Parameter source: Payment source
    /// - Parameter size: QRCode size, default is 256
    public init(qrData: String = "", source: String = "", size: Int = 256) {
        self.size = size
        super.init(frame:CGRect(x: 0, y: 0, width: size, height: size))
        makeUI()
        if !qrData.isEmpty && !source.isEmpty {
            loadQR(qrData: qrData, source: source)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
        addSubViews([webView, errorLabel, loadingIndicator])
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])
        webView.makeEdgesEqualToSuperview()
        errorLabel.makeConstraint(
            leftAnchor: leftAnchor, leftConstant: 4,
            rightAnchor: rightAnchor, rightConstant: -4,
            centerYAnchor: centerYAnchor
        )
        loadingIndicator.makeConstraint(
            centerXAnchor: centerXAnchor,
            centerYAnchor: centerYAnchor
        )
    }

    /// Display QR data
    ///
    /// - Parameter qrData: QRData from payment
    /// - Parameter source: Payment source
    public func loadQR(qrData: String, source: String) {
        self.qrString = qrData
        guard let qrData = qrData.base64 else { return }
        let target = QRTarget.getQRCode(qrData: qrData, source: source, size: size)
        guard let request = HTTPRequestProvider().buildRequest(from: target) else { return }
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        errorLabel.isHidden = true
        webView.load(request)
    }
}

class WebviewDelegate: NSObject, WKNavigationDelegate {
    
    private let onSuccess: Callback
    private let onFailed: ((Error) -> Void)
    
    init(onSuccess: @escaping Callback, onFailed: @escaping ((Error) -> Void)) {
        self.onSuccess = onSuccess
        self.onFailed = onFailed
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        onSuccess()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        onFailed(error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        onFailed(error)
    }
}


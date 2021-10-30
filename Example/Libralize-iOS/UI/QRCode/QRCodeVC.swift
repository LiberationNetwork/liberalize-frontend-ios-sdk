//
//  QRCodeVC.swift
//  Libralize-iOS
//
//  Created by Libralize on 13/10/2021.
//

import UIKit
import WebKit
import Liberalize_Frontend_iOS_SDK

class QRCodeVC: ViewController {
    
    private let provider = ApiProvider()
    
    private let qrData: String
    private let source: String
    private let paymentId: String

    private lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        return button
    }()
    
    // 3.1.a Init QRCode Component
    private lazy var qrCodeView = QRCodeView(size: 256)
    
    // 3.1.b Init Pay With OCBC Button
    private lazy var ocbcButton = PayWithOCBCButton()
    
    // Use timer to check payment status every 3 seconds
    private lazy var timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] timer in
        guard let self = self else { return }
        self.checkQRCodePaymentStatus()
    }
    
    init(qrData: String, source: String, paymentId: String) {
        self.qrData = qrData
        self.source = source
        self.paymentId = paymentId
        super.init(nibName: nil, bundle: nil)
        self.title = "QR Code"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func makeUI() {
        super.makeUI()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
            navigationController?.overrideUserInterfaceStyle = .light
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = title
        view.backgroundColor = .white
        navigationItem.setLeftBarButton(cancelButton, animated: false)
        view.addSubViews([qrCodeView, ocbcButton])
        ocbcButton.isHidden = true
        qrCodeView.makeConstraint(
            centerXAnchor: view.centerXAnchor,
            centerYAnchor: view.centerYAnchor
        )
        ocbcButton.makeConstraint(
            topAnchor: qrCodeView.bottomAnchor, topConstant: 8,
            leftAnchor: qrCodeView.leftAnchor,
            rightAnchor: qrCodeView.rightAnchor
        )
        loadData()
    }
    
    // 3.2 Display QRCode data and OCBC button
    private func loadData() {
        // 3.2.a  Display QRCode data
        qrCodeView.loadQR(qrData: qrData, source: source)
        
        // 3.2.b Show "Paywith OCBC" button when source is "paynow"
        // 3.2.c Config qrData and paymentId for OCBC button
        ocbcButton.isHidden = source != "paynow"
        ocbcButton.set(qrString: qrData, paymentId: paymentId)

        // 3.3 Start loop to check payment status
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.timer.fire()
        }
    }

    @objc private func cancel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // 3.3.a Check payment status
    @objc private func checkQRCodePaymentStatus() {
        provider.getPayment(paymentId: paymentId) { error, payment in
            print("Payment status: \(String(describing: payment?.state))")
            // 3.3.a Close this screen when payment state is "SUCCESS"
            if payment?.state == "SUCCESS" {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
}

extension QRCodeVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading(show: false)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loading(show: false)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        loading(show: false)
    }
}

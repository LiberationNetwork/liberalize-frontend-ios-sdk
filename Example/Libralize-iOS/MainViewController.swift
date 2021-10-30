//
//  ViewController.swift
//  Libralize-iOS
//
//  Created by Libralize on 09/25/2021.
//  Copyright (c) 2021 Libralize. All rights reserved.
//

import UIKit
import Liberalize_Frontend_iOS_SDK

class MainViewController: ViewController {

    private let provider = ApiProvider()
    private let amount: Double = 50.0
    private let currency = "SGD"

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Select payment method", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.addTarget(self, action: #selector(showPayment), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(button)
        navigationController?.setNavigationBarHidden(true, animated: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        
        // 1. Setup Libralize with environment and public key
        Liberalize.shared.setEnvironment(.staging)
        Liberalize.shared.register(publicKey: publicKey) // PUBLIC KEY
    }

    @objc func showPayment() {
        let vc = GeneralVC()
        vc.onSelectQRProvider = { [weak self] source in
            self?.onSelectQRProvider(source: source)
        }
        vc.onCardSelect = { [weak self] in
            self?.onCardSelect()
        }
        let controller = UINavigationController(rootViewController: vc)
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true, completion: nil)
    }

    func onSelectQRProvider(source: String) {
        loading(show: true)
        provider.createPayment(amount: amount, currency: currency, source: source, authorize: true) { [weak self] error, response in
            guard let self = self else { return }
            if let error = error {
                self.loading(show: false)
                self.showError(title: "Create payment failed", error: error)
                return
            }

            guard let paymentId = response?.paymentId, let qrData = response?.processor?.qrData else {
                self.loading(show: false)
                self.showDialog(title: "Create payment failed", message: "Could not get QR data")
                return
            }
            self.showQR(viewController: self, paymentId: paymentId, qrData: qrData, source: source)
            self.loading(show: false)
        }
    }

    func onCardSelect() {
        // 2. Mount card module
        Liberalize.shared.showCardInput(viewController: self) { [weak self] (paymentMethodId, securityCode) in
            guard let self = self else { return }
            guard let paymentMethodId = paymentMethodId else {
                self.showDialog(title: "Create payment failed", message: "Could not retrieve card data")
                return
            }
            // 2.1 Create payment with response from card module
            self.createPayment(amount: self.amount, currency: self.currency, source: "lib:customer:paymentMethods/\(paymentMethodId)", authorize: true)
        }
    }

    private func createPayment(amount: Double, currency: String, source: String, authorize: Bool) {
        self.loading(show: true)
        self.provider.createPayment(amount: self.amount, currency: self.currency, source: source, authorize: true) { error, payment in
            if let error = error {
                self.loading(show: false)
                self.showError(title: "Create payment failed", error: error)
                return
            }
            // 2.2 Capture created payment
            self.capturePayment(amount: self.amount, paymentId: payment?.paymentId ?? "")
        }
    }

    private func capturePayment(amount: Double, paymentId: String) {
        provider.capturePayment(paymentId: paymentId, amount: amount) { [weak self] error, response in
            guard let self = self else { return }
            if let error = error {
                self.loading(show: false)
                self.showError(title: "Capture payment failed", error: error)
                return
            }
            self.loading(show: false)
            print("Payment success \(paymentId)")
            self.showDialog(title: "Payment success", message: "Payment id \(paymentId)")
        }
    }
    
    func showQR(
        viewController: UIViewController,
        paymentId: String,
        qrData: String,
        source: String
    ) {
        // 3. Present ViewController with a QRCode inside
        let qrCodeVC = QRCodeVC(qrData: qrData, source: source, paymentId: paymentId)
        let controller = UINavigationController(rootViewController: qrCodeVC)
        controller.modalPresentationStyle = .fullScreen
        viewController.present(controller, animated: true, completion: nil)
    }
}


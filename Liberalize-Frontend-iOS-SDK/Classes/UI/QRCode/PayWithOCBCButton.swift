//
//  PayWithOCBCButton
//  Libralize-iOS
//
//  Created by Libralize on 24/10/2021.
//

import UIKit

public class PayWithOCBCButton: UIButton {
    
    private var qrString: String?
    private var paymentId: String?
    
    /// Initialize and config data for button
    ///
    /// - Parameter paymentId: Payment ID
    /// - Parameter qrString: QR data from payment
    public convenience init(paymentId: String? = nil, qrString: String? = nil) {
        self.init(frame: .zero)
        self.qrString = qrString
        self.paymentId = paymentId
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Config data
    ///
    /// - Parameter paymentId: Payment ID
    /// - Parameter qrString: QR data from payment
    public func set(qrString: String, paymentId: String) {
        self.paymentId = paymentId
        self.qrString = qrString
    }
    
    private func makeUI() {
        setTitle("Pay with OCBC Bank", for: .normal)
        semanticContentAttribute = .forceRightToLeft
        isHidden = true
        makeSize(height: 36)
        setTitleColor(.systemBlue, for: .normal)
        setTitleColor(.lightGray, for: .highlighted)
        imageView?.contentMode = .scaleAspectFit
        addTapGuesture { [weak self] in
            self?.onTap()
        }
    }

    private func onTap() {
        guard let paymentId = paymentId, let qrString = qrString else { return }
        let target = OCBCTarget.openOCBC(qrString: qrString, paymentId: paymentId)
        guard let url = HTTPRequestProvider().buildRequest(from: target)?.url else {
            print("OCBC COULD NOT CREATE URL")
            return
        }
        print("OCBC URL \(url)")
        guard UIApplication.shared.canOpenURL(url) else {
            print("OCBC COULD NOT OPEN URL")
            return
        }
        UIApplication.shared.open(url)
    }
}

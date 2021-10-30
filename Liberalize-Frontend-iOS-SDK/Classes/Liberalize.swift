//
//  Liberalize.swift
//  libralizetest
//
//  Created by Libralize on 03/10/2021.
//

import UIKit

public class Liberalize {
    
    public static let shared = Liberalize()
    var env = LiberalizeEnv.staging

    /// Set Libralize environment
    ///
    /// - Parameter env:
    ///         + dev: for development
    ///         + staging:  staging: for testing
    ///         + prod: prodction eviroment
    ///
    public func setEnvironment(_ env: LiberalizeEnv) {
        self.env = env
    }

    /// Set public key for Libralize
    ///
    /// - Parameter publicKey: Public key from Libralize dashboard
    ///
    public func register(publicKey: String) {
        AuthManager.shared.setKey(key: publicKey)
    }
    
    /// Mount card input module, allow users key in their card to proceed payment
    ///
    /// - Parameter viewController: used to present card input module
    /// - Parameter completion: The completion handler will be executed once users submit their card successfully.
    ///     +  The handler has 2 parameters are Payment method Id and Card Security Code
    ///
    ///
    public func showCardInput(
        viewController: UIViewController,
        completion: @escaping ((_ paymentMethodId: String?,_ securityCode: String?) -> Void)) {
        let cardInputVC = CardInputVC()
        cardInputVC.onSubmitCardSuccess = completion
        let controller = UINavigationController(rootViewController: cardInputVC)
        controller.modalPresentationStyle = .overCurrentContext
        viewController.present(controller, animated: true, completion: nil)
    }
}


//
//  CardInputVC.swift
//  libralizetest
//
//  Created by Libralize on 05/10/2021.
//

import UIKit

class CardInputVC: ViewController {
    
    let viewModel = CardInputVM()
    
    var onSubmitCardSuccess: ((_ paymentMethodId: String?,_ securityCode: String?) -> Void)?
    
    private lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        return button
    }()
    
    private lazy var confirmButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Pay", style: .plain, target: self, action: #selector(addCard))
        button.isEnabled = false
        return button
    }()
    
    private lazy var nameHolderTf: UITextField = {
        let textfield = UITextField()
        textfield.makeSize(height: 44)
        textfield.borderStyle = .roundedRect
        textfield.placeholder = "Cardholder Name"
        textfield.autocapitalizationType = .words
        textfield.autocorrectionType = .no
        textfield.addTarget(self, action: #selector(onCardHolderChanged), for: .editingChanged)
        return textfield
    }()
    
    private lazy var cardTf: CardInputField = {
        let textField = CardInputField()
        textField.onTextChange = { [weak self] _ in
            self?.validate()
        }
        return textField
    }()
    
    private lazy var expirationField: ExpirationDateField = {
        let textField = ExpirationDateField()
        textField.onTextChange = { [weak self] _ in
            self?.validate()
        }
        return textField
    }()
    
    private lazy var securityField: CardSecurityField = {
        let textField = CardSecurityField()
        textField.onTextChange = { [weak self] _ in
            self?.validate()
        }
        return textField
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubViews([nameHolderTf, cardTf, cardExpandView])
        stackView.spacing = 16
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var cardExpandView: UIView = {
        let view = UIView()
        view.addSubViews([expirationField, securityField])
        expirationField.makeConstraint(
            topAnchor: view.topAnchor,
            leftAnchor: view.leftAnchor,
            bottomAnchor: view.bottomAnchor,
            rightAnchor: view.centerXAnchor, rightConstant: -8)
        securityField.makeConstraint(
            topAnchor: expirationField.topAnchor,
            leftAnchor: expirationField.rightAnchor, leftConstant: 8,
            bottomAnchor: expirationField.bottomAnchor,
            rightAnchor: view.rightAnchor)
        return view
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
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
        view.backgroundColor = UIColor(250, 250, 250)
        navigationItem.title = "Card Details"
        navigationItem.setLeftBarButton(cancelButton, animated: false)
        navigationItem.setRightBarButton(confirmButton, animated: false)
        view.addSubview(stackView)
        stackView.makeConstraint(
            topAnchor: view.layoutMarginsGuide.topAnchor, topConstant: 40,
            leftAnchor: view.leftAnchor, leftConstant: 16,
            rightAnchor: view.rightAnchor, rightConstant: -16)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        viewModel.onError { [weak self] error in
            guard let error = error else { return }
            self?.showError(title: "Submit card failed", error: error)
        }
        viewModel.bindLoading { [weak self] loading in
            self?.loading(show: loading)
        }
        viewModel.bindSubmitCardSuccess { [weak self] response in
            self?.navigationController?.dismiss(animated: true) {
                self?.onSubmitCardSuccess?(response.id, self?.securityField.code)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let _ = nameHolderTf.becomeFirstResponder()
    }
    
    @objc private func cancel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func addCard() {
        let holderName = nameHolderTf.text ?? ""
        let cardNumber = cardTf.cardNumber ?? ""
        let expiredDate = expirationField.expiredDate ?? ""
        let securityCode = securityField.code ?? ""
        viewModel.submitCard(holderName: holderName, cardNumber: cardNumber, expiryDate: expiredDate, securityCode: securityCode)
    }
    
    @objc private func onCardHolderChanged() {
        validate()
    }
    
    func validate() {
        let holderName = nameHolderTf.text ?? ""
        let cardNumber = cardTf.cardNumber ?? ""
        let expiredDate = expirationField.expiredDate ?? ""
        let securityCode = securityField.code ?? ""
        confirmButton.isEnabled = !(holderName.isEmpty ||
                                    expiredDate.isEmpty ||
                                    securityCode.isEmpty ||
                                    !CardUtils.isValidCardNumber(cardNumber: cardNumber))
    }
    
}

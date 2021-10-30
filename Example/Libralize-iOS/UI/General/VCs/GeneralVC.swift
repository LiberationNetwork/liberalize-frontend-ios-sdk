//
//  GeneralVC.swift
//  libralizetest
//
//  Created by Libralize on 03/10/2021.
//

import UIKit
import Liberalize_Frontend_iOS_SDK

class GeneralVC: UIViewController {
    
    private let viewModel = GeneralVM()
    
    var onDismiss: Callback?
    var onSelectQRProvider: ((String) -> Void)?
    var onCardSelect: Callback?
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.startAnimating()
        return indicator
    }()
    
    private lazy var headerView: SelectPaymentHeader = {
        let view = SelectPaymentHeader()
        view.onCancel = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        return view
    }()
    
    private lazy var qrCodeView: QRCodeProvidersView = {
        let view = QRCodeProvidersView()
        view.isHidden = true
        view.onItemTap = { [weak self] provider in
            guard let self = self, let source = provider.source else { return }
            self.dismiss(animated: true) {
                self.onSelectQRProvider?(source)
            }
        }
        return view
    }()
    
    private lazy var cardView: EnterCardView = {
        let view = EnterCardView()
        view.isHidden = true
        view.onAddCardTap = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                self.onCardSelect?()
            }
        }
        return view
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .red
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.addArrangedSubViews([headerView, qrCodeView, cardView])
        stackView.setCustomSpacing(32, after: qrCodeView)
        return stackView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.addSubViews([stackView, loadingIndicator, errorLabel])
        stackView.makeConstraint(
            topAnchor: view.safeAreaLayoutGuide.topAnchor, topConstant: 8,
            leftAnchor: view.safeAreaLayoutGuide.leftAnchor, leftConstant: 16,
            bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, bottomConstant: -100,
            rightAnchor: view.safeAreaLayoutGuide.rightAnchor, rightConstant: -16)
        loadingIndicator.makeConstraint(
            centerXAnchor: view.centerXAnchor,
            centerYAnchor: view.centerYAnchor)
        errorLabel.makeConstraint(
            leftAnchor: view.leftAnchor,
            rightAnchor: view.rightAnchor,
            centerYAnchor: view.centerYAnchor)
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 0
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var dismissArea: UIView = {
       let view = UIView()
        view.addTapGuesture { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .lightGray.withAlphaComponent(0.8)
        view.addSubViews([contentView, dismissArea])
        contentView.makeConstraint(
            leftAnchor: view.leftAnchor, leftConstant: 8,
            bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, bottomConstant: -8,
            rightAnchor: view.rightAnchor, rightConstant: -8)
        dismissArea.makeConstraint(
            topAnchor: view.topAnchor,
            leftAnchor: view.leftAnchor,
            bottomAnchor: contentView.topAnchor,
            rightAnchor: view.rightAnchor)
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getPaymentMethods()
    }
    
    private func bindViewModel() {
        viewModel.bindLoading { [weak self] loading in
            guard let self = self else { return }
            self.loadingIndicator.isHidden = !loading
        }
        viewModel.onError { [weak self] error in
            self?.errorLabel.text = error?.message
        }

        viewModel.bindCardComponent { [weak self] isHidden in
            self?.cardView.isHidden = isHidden
        }
        
        viewModel.bindPaymentMethods { [weak self] methods in
            self?.qrCodeView.isHidden = methods.isEmpty
            self?.qrCodeView.paymentMethods = methods
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onDismiss?()
    }
}


//
//  QRCodeProvidersView.swift
//  Libralize-iOS
//
//  Created by Libralize on 07/10/2021.
//

import UIKit
import Liberalize_Frontend_iOS_SDK

class QRCodeProvidersView: View {
    
    var onEditTap: Callback?
    
    var onItemTap: ((PaymentMethod) -> Void)?
    
    var paymentMethods = [PaymentMethod]() {
        didSet {
            bindData()
        }
    }

    private lazy var titleLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "QR Codes"
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(cardStackView)
        cardStackView.makeEdgesEqualToSuperview()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var cardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 16
        return stackView
    }()
    
    override func makeUI() {
        super.makeUI()
        addSubViews([
            titleLbl,
            scrollView
        ])
        titleLbl.makeConstraint(topAnchor: topAnchor, leftAnchor: leftAnchor)
        scrollView.makeConstraint(
            topAnchor: titleLbl.bottomAnchor,
            topConstant: 16,
            leftAnchor: leftAnchor,
            leftConstant: 8,
            bottomAnchor: bottomAnchor,
            rightAnchor: rightAnchor,
            rightConstant: -8
        )
        scrollView.makeSize(height: 120)
    }
    
    private func bindData() {
        let cardViews = paymentMethods.compactMap { [weak self] method -> SquareCardView in
            let view = SquareCardView(paymentMethod: method)
            view.addTapGuesture {
                self?.onItemTap?(method)
            }
            return view
        }
        cardStackView.removeAllArrangedSubView()
        cardStackView.addArrangedSubViews(cardViews)
    }
}

class SquareCardView: View {
    
    let paymentMethod: PaymentMethod
    
    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.makeSize(width: 80, height: 80)
        if let url = paymentMethod.image, let url = URL(string: url) {
            imageView.load(url: url)
        }
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.text = paymentMethod.source?.uppercased()
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .center
        stackview.addArrangedSubViews([cardImageView, titleLbl])
        stackview.setCustomSpacing(4, after: cardImageView)
        return stackview
    }()
    
    init(paymentMethod: PaymentMethod) {
        self.paymentMethod = paymentMethod
        super.init()
    }
    
    override func makeUI() {
        super.makeUI()
        addSubview(stackView)
        stackView.makeEdgesEqualToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

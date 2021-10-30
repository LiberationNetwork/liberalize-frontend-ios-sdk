//
//  EnterCardView.swift
//  Libralize-iOS
//
//  Created by Libralize on 07/10/2021.
//

import UIKit

class EnterCardView: View {
    
    var onAddCardTap: Callback?

    private lazy var titleLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "CARD"
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var addCardView: CreditDebitCardAddButton = {
        let view = CreditDebitCardAddButton()
        view.addTapGuesture { [weak self] in
            self?.onAddCardTap?()
        }
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.addArrangedSubViews([titleLbl, addCardView])
        addCardView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        return stackView
    }()
    
    override func makeUI() {
        super.makeUI()
        addSubview(stackView)
        stackView.makeEdgesEqualToSuperview()
    }
}

class CreditDebitCardAddButton: View {
    
    private lazy var cardIcon: UIImageView = {
        let imageView = UIImageView(asset: .card)
        imageView.contentMode = .scaleAspectFit
        imageView.makeSize(width: 64, height: 64)
        return imageView
    }()
    
    private lazy var titleLbl: UILabel = {
        let label = UILabel()
        label.text = "Credit or Debit card"
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.makeSize(height: 1)
        return view
    }()
    
    override func makeUI() {
        super.makeUI()
        addSubViews([cardIcon, titleLbl, underLine])
        cardIcon.makeConstraint(
            topAnchor: topAnchor,
            leftAnchor: leftAnchor,
            bottomAnchor: bottomAnchor)
        titleLbl.makeConstraint(
            leftAnchor: cardIcon.rightAnchor, leftConstant: 16,
            rightAnchor: rightAnchor,
            centerYAnchor: cardIcon.centerYAnchor)
        underLine.makeConstraint(
            leftAnchor: titleLbl.leftAnchor,
            bottomAnchor: bottomAnchor,
            rightAnchor: rightAnchor)
    }
}

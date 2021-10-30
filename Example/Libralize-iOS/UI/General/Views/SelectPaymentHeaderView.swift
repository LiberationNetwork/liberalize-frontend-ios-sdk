//
//  SelectPaymentHeaderView.swift
//  Libralize-iOS
//
//  Created by Libralize on 07/10/2021.
//

import UIKit

class SelectPaymentHeader: View {
    
    var onCancel: Callback?
    
    private lazy var cancelBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.addTapGuesture { [weak self] in
            self?.onCancel?()
        }
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        return button
    }()
    
    private lazy var titleLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Select Payment Method"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    override func makeUI() {
        super.makeUI()
        addSubViews([cancelBtn, titleLbl])
        cancelBtn.makeConstraint(topAnchor: topAnchor, leftAnchor: leftAnchor, bottomAnchor: bottomAnchor)
        titleLbl.makeConstraint(centerXAnchor: centerXAnchor, centerYAnchor: centerYAnchor)
    }
}

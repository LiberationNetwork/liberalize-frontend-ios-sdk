//
//  CardInputField.swift
//  Libralize-iOS
//
//  Created by Libralize on 07/10/2021.
//

import UIKit

class CardInputField: View {
    
    var onTextChange: ((String) -> Void)?
    
    var cardNumber: String? {
        get {
            cardTf.text?.replacingOccurrences(of: " ", with: "")
        }
        set {
            cardTf.text = newValue
        }
    }

    private lazy var cardTf: UITextField = {
        let cardTextField = UITextField()
        cardTextField.borderStyle = .roundedRect
        cardTextField.makeSize(height: 44)
        cardTextField.placeholder = "Card Number"
        cardTextField.keyboardType = .numberPad
        cardTextField.delegate = self
        return cardTextField
    }()
    
    override func makeUI() {
        super.makeUI()
        addSubview(cardTf)
        backgroundColor = .white
        cardTf.makeEdgesEqualToSuperview()
    }
    
    override func becomeFirstResponder() -> Bool {
        cardTf.becomeFirstResponder()
    }
}

extension CardInputField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        textField.setText(to: currentText.grouping(every: 4, with: " "), preservingCursor: true)
        textFieldEditingChanged(textField)
        return false
    }
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text?.replacingOccurrences(of: " ", with: ""), text.count >= 9 else {
            return
        }
        onTextChange?(text)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
}

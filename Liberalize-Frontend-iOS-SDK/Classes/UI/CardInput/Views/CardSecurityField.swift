//
//  CardSecurityField.swift
//  Libralize-iOS
//
//  Created by Libralize on 07/10/2021.
//

import UIKit

class CardSecurityField: View {
    
    var onTextChange: ((String) -> Void)?

    var code: String? {
        get {
            textfield.text
        }
        set {
            textfield.text = newValue
        }
    }
    
    private lazy var textfield: UITextField = {
        let textfield = UITextField()
        textfield.makeSize(height: 44)
        textfield.placeholder = "Security Code"
        textfield.borderStyle = .roundedRect
        textfield.keyboardType = .numberPad
        textfield.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        return textfield
    }()

    override func makeUI() {
        super.makeUI()
        addSubview(textfield)
        textfield.makeEdgesEqualToSuperview()
    }
    
    @objc private func textFieldDidChanged() {
//        guard let text = textfield.text, text.count > 4 else {
//            onTextChange?(textfield.text ?? "")
//            return
//        }
//        textfield.text = String(text.prefix(4))
//        onTextChange?(String(text.prefix(4)))
        if let text = textfield.text {
            onTextChange?(text)
        }
    }
}

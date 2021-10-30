//
//  UITextFieldExtension.swift
//  Libralize-iOS
//
//  Created by Libralize on 07/10/2021.
//

import Foundation
import UIKit

extension UITextField {
    func setText(to newText: String, preservingCursor: Bool) {
        if preservingCursor {
            let cursorPosition = offset(from: beginningOfDocument, to: selectedTextRange!.start) + newText.count - (text?.count ?? 0)
            text = newText
            if let newPosition = self.position(from: beginningOfDocument, offset: cursorPosition) {
                selectedTextRange = textRange(from: newPosition, to: newPosition)
            }
        }
        else {
            text = newText
        }
    }
}

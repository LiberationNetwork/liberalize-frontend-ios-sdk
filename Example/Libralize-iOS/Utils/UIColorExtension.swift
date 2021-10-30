//
//  UIColorExtension.swift
//  Libralize-iOS
//
//  Created by Libralize on 07/10/2021.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(_ r: Int, _ g: Int, _ b: Int, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat(Double(r)/255.0),
            green: CGFloat(Double(g)/255.0),
            blue: CGFloat(Double(b)/255.0),
            alpha: alpha)
    }
}

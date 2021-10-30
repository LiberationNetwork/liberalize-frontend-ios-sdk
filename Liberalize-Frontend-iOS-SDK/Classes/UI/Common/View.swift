//
//  View.swift
//  libralizetest
//
//  Created by Libralize on 29/09/2021.
//

import UIKit

typealias Callback = (() -> Void)

class View: UIView {

    init() {
        super.init(frame: .zero)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        
    }
}

extension UIView {
    func addSubViews(_ subviews: [UIView]) {
        for view in subviews {
            addSubview(view)
        }
    }
    
    func makeEdgesEqualToSuperview(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        assert(superview != nil)
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            topAnchor.constraint(equalTo: superview.topAnchor, constant: top),
            leftAnchor.constraint(equalTo: superview.leftAnchor, constant: left),
            rightAnchor.constraint(equalTo: superview.rightAnchor, constant: right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func makeConstraint(topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil, topConstant: CGFloat = 0,
                        leftAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, leftConstant: CGFloat = 0,
                        bottomAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil, bottomConstant: CGFloat = 0,
                        rightAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, rightConstant: CGFloat = 0,
                        centerXAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, centerXConstant: CGFloat = 0,
                        centerYAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil, centerYconstant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        if let topAnchor = topAnchor {
            constraints.append(self.topAnchor.constraint(equalTo: topAnchor, constant: topConstant))
        }
        if let leftAnchor = leftAnchor {
            constraints.append(self.leftAnchor.constraint(equalTo: leftAnchor, constant: leftConstant))
        }
        if let bottomAnchor = bottomAnchor {
            constraints.append(self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomConstant))
        }
        if let rightAnchor = rightAnchor {
            constraints.append(self.rightAnchor.constraint(equalTo: rightAnchor, constant: rightConstant))
        }
        if let centerXAnchor = centerXAnchor {
            constraints.append(self.centerXAnchor.constraint(equalTo: centerXAnchor, constant: centerXConstant))
        }
        if let centerYAnchor = centerYAnchor {
            constraints.append(self.centerYAnchor.constraint(equalTo: centerYAnchor, constant: centerYconstant))
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    func makeSize(width: CGFloat? = nil, height: CGFloat? = nil) {
        var constraints = [NSLayoutConstraint]()
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            constraints.append(widthAnchor.constraint(equalToConstant: width))
        }
        if let height = height {
            constraints.append(heightAnchor.constraint(equalToConstant: height))
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    func addTapGuesture(_ callback: @escaping Callback) {
        let tap = TapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.callback = callback
        addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: TapGestureRecognizer) {
          sender.callback?()
      }
    
    func addTopLine(color: UIColor, height: CGFloat = 0.5) {
        let view = UIView()
        view.backgroundColor = color
        addSubview(view)
        view.makeConstraint(
            topAnchor: topAnchor,
            leftAnchor: leftAnchor,
            rightAnchor: rightAnchor)
        view.makeSize(height: height)
        bringSubviewToFront(view)
    }
    
    func addBottomLine(color: UIColor, height: CGFloat = 0.5) {
        let view = UIView()
        view.backgroundColor = color
        addSubview(view)
        view.makeConstraint(
            leftAnchor: leftAnchor,
            bottomAnchor: bottomAnchor,
            rightAnchor: rightAnchor)
        view.makeSize(height: height)
        bringSubviewToFront(view)
    }
}

extension UIStackView {
    func addArrangedSubViews(_ subViews: [UIView]) {
        for view in subViews {
            addArrangedSubview(view)
        }
    }
    
    func setBackgroundColor(_ color: UIColor) {
            let subview = UIView(frame: bounds)
            subview.backgroundColor = color
            subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            insertSubview(subview, at: 0)
        }
    
    func removeAllArrangedSubView() {
        for item in arrangedSubviews {
            item.removeFromSuperview()
        }
    }
}

internal class TapGestureRecognizer: UITapGestureRecognizer {
    var callback: Callback?
}

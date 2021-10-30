//
//  ViewController.swift
//  Libralize-iOS
//
//  Created by Libralize on 12/10/2021.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.isHidden = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bindViewModel()
        view.addSubview(loadingIndicator)
        loadingIndicator.makeConstraint(centerXAnchor: view.centerXAnchor, centerYAnchor: view.centerYAnchor)
    }
    
    func makeUI() {
        
    }
    
    func bindViewModel() {
        
    }
    
    func loading(show: Bool) {
        show ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = !show
    }
    
    func showError(title: String? = nil, error: ErrorResponse, firstCallback: Callback? = nil) {
        showDialog(title: title, message: error.message, firstCallback: firstCallback)
    }
    
    func showDialog(title: String? = nil, message: String?, firstCallback: Callback? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in firstCallback?() }))
        self.present(alert, animated: true, completion: nil)
    }
}

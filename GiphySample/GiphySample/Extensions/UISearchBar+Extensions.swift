//
//  UISearchBar+Extensions.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 07/12/20.
//

import UIKit

extension UISearchBar {

    private var activityIndicator: UIActivityIndicatorView? {
        return searchTextField.leftView?.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
    }

    var isLoading: Bool {
        get {
            return activityIndicator != nil
        }
        set {
            if newValue {
                if activityIndicator == nil {
                    let newActivityIndicator = UIActivityIndicatorView(style: .medium)
                    newActivityIndicator.startAnimating()
                    newActivityIndicator.backgroundColor = UIColor.systemGroupedBackground
                    newActivityIndicator.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    searchTextField.leftView?.addSubview(newActivityIndicator)
                    let leftViewSize = searchTextField.leftView?.frame.size ?? CGSize.zero
                    newActivityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                activityIndicator?.removeFromSuperview()
            }
        }
    }
}

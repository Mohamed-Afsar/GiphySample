//
//  UIViewController+Extensions.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 04/12/20.
//

import UIKit

extension UIViewController {
    static func gs_Instantiate<T>() -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: .main) // NO I18N
        let controller = storyboard.instantiateViewController(identifier: "\(T.self)") as! T // NO I18N
        return controller
    }
}

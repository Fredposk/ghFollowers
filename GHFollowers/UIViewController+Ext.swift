//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 06.11.21.
//

import UIKit

extension UIViewController {

    /// presents AlertViewController on main thread with animation
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async { [self] in
            let alertVC = GFAlertViewController(alertTitle: title, message: message, buttonTitle: buttonTitle)

            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            present(alertVC, animated: true, completion: nil)
        }
    }

}

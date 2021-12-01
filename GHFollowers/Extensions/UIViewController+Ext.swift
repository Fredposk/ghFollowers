//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 06.11.21.
//

import UIKit
import SafariServices

fileprivate var containerView: UIView!

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

    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)

        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0

        UIView.animate(withDuration: 0.5) {
            containerView.alpha = 0.8
        }

        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])

        activityIndicator.color = .systemGreen
        activityIndicator.startAnimating()

    }

    func dismissLoadingView() {
        DispatchQueue.main.async {
//            guard containerView == nil else {
//                return
//            }
            containerView.removeFromSuperview()
            containerView = nil
        }
    }

    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }

    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }

}



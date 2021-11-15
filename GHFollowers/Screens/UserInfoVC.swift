//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 15.11.21.
//

import UIKit

class UserInfoVC: UIViewController {

    var userName: String!

    let headerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton


        layoutUI()
        NetworkManager.shared.getUser(for: userName) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "\(error)", message: "Error fetching user", buttonTitle: "OK")
            case .success(let user):
                
                DispatchQueue.main.async {
                    self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
                }

            }
        }
    }

    func layoutUI() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }

    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self )
    }

    @objc func dismissVC() {
        dismiss(animated: true)
    }




}

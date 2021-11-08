//
//  FollowersListViewController.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 05.11.21.
//

import UIKit

class FollowersListViewController: UIViewController {

    var userName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true


        NetworkManager.shared.getFollowers(for: userName, page: 1) { [weak self] followers, errorMessage in

            guard let strongSelf = self else {return}

            guard let followers = followers else {
                strongSelf.presentGFAlertOnMainThread(title: "Bad stuff happened", message: errorMessage!.rawValue, buttonTitle: "OK")
                return
            }
            print(followers)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }



}

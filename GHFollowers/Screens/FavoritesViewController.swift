//
//  FavoritesViewController.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 03.11.21.
//

import UIKit

class FavoritesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBlue

        PersistanceManager.retrieveFavorites { result in
            switch result {

            case .success(let favourites):
                print(favourites)
            case .failure(_):
                break
            }
        }
    }
    


}

//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 29.11.21.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = .systemGreen
        UINavigationBar.appearance().tintColor = .systemGreen

        self.viewControllers = [createSearchNavigationController(), createFavoritesNavigationController()]
    }
        ///  Creates the search Navigation Controller
        /// - Returns:Search View Controller as  UINavigationController
        func createSearchNavigationController() -> UINavigationController {
            let searchVC = SearchViewController()
            searchVC.title = "Search"
            searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
            return UINavigationController(rootViewController: searchVC)
        }

        ///  Creates the search Favourites Controller
        /// - Returns:Favorites View Controller as  UINavigationController
        func createFavoritesNavigationController() -> UINavigationController {
            let favoritesVC = FavoritesViewController()
            favoritesVC.title = "Favorites"
            favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
            return UINavigationController(rootViewController: favoritesVC)
        }



}

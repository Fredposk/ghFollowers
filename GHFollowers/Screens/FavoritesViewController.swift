//
//  FavoritesViewController.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 03.11.21.
//

import UIKit

class FavoritesViewController: UIViewController {

    let tableView = UITableView()
    var favourites: [Follower] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }

    func configure() {
        title = "Favourites"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemGreen
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.ReUseIdentifier)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
    }

    func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favourites):
                if favourites.isEmpty {
                    self.showEmptyStateView(with: "You have no favourites", in: self.view)
                } else {
                    self.favourites = favourites
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.ReUseIdentifier) as! FavoriteCell
        let favourite = favourites[indexPath.row]
        cell.setData(with: favourite)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favourite = favourites[indexPath.row]
        let destVC = FollowersListViewController(username: favourite.login)
        navigationController?.pushViewController(destVC, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        let favourite = favourites[indexPath.row]

        PersistenceManager.updateWith(favourite: favourite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.favourites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                return
            }
            self.presentGFAlertOnMainThread(title: "Error deleting user", message: error.rawValue, buttonTitle: "OK")
        }
    }
}

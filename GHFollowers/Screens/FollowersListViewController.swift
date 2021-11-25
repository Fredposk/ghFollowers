//
//  FollowersListViewController.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 05.11.21.
//

import UIKit

class FollowersListViewController: UIViewController {

    enum section {
        case main
    }

    var userName: String!
    var collectionView: UICollectionView!
    var UICollectionDataSource: UICollectionViewDiffableDataSource<section, Follower>!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var isSearching: Bool = false
    var page = 1
    var hasMoreFollowers = true

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(for: userName, on: 1)
        configureDataSource()
        configureSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func getFollowers(for userName: String, on page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: userName, page: page) { [weak self] result in
            
            guard let self = self else {return}
            self.dismissLoadingView()
            switch result {
            case .success(let result):
                if result.count < 100 { self.hasMoreFollowers = false }
                self.followers.append(contentsOf: result)

                if self.followers.isEmpty {
                    let message = "this user doesn't have any followers"
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                    return
                }
//                strongSelf.followers = result
                self.updateData(on: self.followers)
            case .failure(let failure):
                self.presentGFAlertOnMainThread(title: "Oops", message: failure.rawValue, buttonTitle: "OK")
            }
        }
    }

 

    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createCollectionViewCompositionalLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.ReUseIdentifier)
    }

    func configureDataSource() {
        UICollectionDataSource = UICollectionViewDiffableDataSource<section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.ReUseIdentifier, for: indexPath) as! FollowerCell
            cell.setData(with: itemIdentifier)
            return cell
        })
    }

    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.UICollectionDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }

    }

    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
        searchController.delegate = self
    }



}

extension FollowersListViewController: UICollectionViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

//        origin of the scrollview (starts at zero)
        print("\(offsetY)")
//        whole height of collection view contents
        print("\(contentHeight)")
//        height of screen
        print("\(height)")


        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(for: userName, on: page)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]

        let destinationVC = UserInfoVC()
        destinationVC.userName = follower.login
        let nav = UINavigationController(rootViewController: destinationVC)
        present(nav, animated: true)

    }
}

extension FollowersListViewController: UISearchResultsUpdating, UISearchControllerDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, filter.isEmpty == false else {
            return
        }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateData(on: followers)
        isSearching = false
    }


}

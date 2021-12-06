//
//  FollowersListViewController.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 05.11.21.
//

import UIKit

protocol FollowerListVCDelegate: AnyObject {
    func didRequestFollower(for userName: String)
}

class FollowersListViewController: UIViewController {

    enum section {
        case main
        case notMain
    }

    var userName: String!
    var collectionView: UICollectionView!
    var UICollectionDataSource: UICollectionViewDiffableDataSource<section, Follower>!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var isSearching: Bool = false
    var page = 1
    var hasMoreFollowers = true
    var isLoadingMoreFollowers = false


    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.userName = username
        self.title = username
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc func didTapAddButton() {
        showLoadingView()

        NetworkManager.shared.getUser(for: userName) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let user):
                let favourite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.updateWith(favourite: favourite, actionType: .add) { [weak self] error in
                    guard let self = self else { return }
                    guard let error = error else {
                        self.presentGFAlertOnMainThread(title: "Success", message: "User Saved", buttonTitle: "OK")
                        return
                    }
                    self.presentGFAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "OK")
                }

            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "OK")
            }

        }
    }

    func getFollowers(for userName: String, on page: Int) {
        showLoadingView()

        isLoadingMoreFollowers = true
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
                self.updateData(on: self.followers)
            case .failure(let failure):
                self.presentGFAlertOnMainThread(title: "Oops", message: failure.rawValue, buttonTitle: "OK")
            }
        }
        isLoadingMoreFollowers = false
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

        if offsetY > contentHeight - height {
            guard hasMoreFollowers, isLoadingMoreFollowers == false else { return }
            page += 1
            getFollowers(for: userName, on: page)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]

        let destinationVC = UserInfoVC()
        destinationVC.delegate = self
        destinationVC.userName = follower.login
        let nav = UINavigationController(rootViewController: destinationVC)
        present(nav, animated: true)
    }
}

extension FollowersListViewController: UISearchResultsUpdating, UISearchControllerDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, filter.isEmpty == false else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

extension FollowersListViewController: FollowerListVCDelegate {
    func didRequestFollower(for userName: String) {
        self.userName = userName
        self.title = userName
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollsToTop = true
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(for: userName, on: page)
    }


}

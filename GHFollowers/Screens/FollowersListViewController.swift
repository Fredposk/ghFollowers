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

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers()
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func getFollowers() {
        NetworkManager.shared.getFollowers(for: userName, page: 1) { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let result):
                strongSelf.followers = result
                strongSelf.updateData()
            case .failure(let failure):
                strongSelf.presentGFAlertOnMainThread(title: "Oops", message: failure.rawValue, buttonTitle: "OK")
            }
        }
    }

    func createUICollectionViewFlowLayout () -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth/3

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth+35)

        return flowLayout
    }

    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createUICollectionViewFlowLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemPink
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.ReUseIdentifier)
    }

    func configureDataSource() {
        UICollectionDataSource = UICollectionViewDiffableDataSource<section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.ReUseIdentifier, for: indexPath) as! FollowerCell
            cell.setData(with: itemIdentifier)
            return cell
        })
    }

    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.UICollectionDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }

    }



}

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
    var page = 1
    var hasMoreFollowers = true

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(for: userName, on: 1)
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

    func getFollowers(for userName: String, on page: Int) {
        NetworkManager.shared.getFollowers(for: userName, page: page) { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let result):
                if result.count < 100 { self?.hasMoreFollowers = false }
                strongSelf.followers.append(contentsOf: result)
//                strongSelf.followers = result
                strongSelf.updateData()
            case .failure(let failure):
                strongSelf.presentGFAlertOnMainThread(title: "Oops", message: failure.rawValue, buttonTitle: "OK")
            }
        }
    }

 

    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createUICollectionViewFlowLayout(in: view))
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

    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.UICollectionDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }

    }



}

extension FollowersListViewController: UICollectionViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        print("\(offsetY)")
        print("\(contentHeight)")
        print("\(height)")


        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(for: userName, on: page)
        }
    }
}

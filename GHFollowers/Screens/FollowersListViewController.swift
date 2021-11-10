//
//  FollowersListViewController.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 05.11.21.
//

import UIKit

class FollowersListViewController: UIViewController {

    var userName: String!
    var collectionView: UICollectionView!




    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        getFollowers()
        configureCollectionView()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
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
                print(result)
            case .failure(let failure):
                strongSelf.presentGFAlertOnMainThread(title: "Oops", message: failure.rawValue, buttonTitle: "OK")
            }
        }
    }

    func createUICollectionViewFlowLayout () -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 20
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



}

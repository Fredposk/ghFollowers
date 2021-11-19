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
    let itemOne = UIView()
    let itemTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)

    var itemViews: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        layoutUI()
        getUserInfo()

    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }

    func getUserInfo() {
        NetworkManager.shared.getUser(for: userName) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "\(error)", message: "Error fetching user", buttonTitle: "OK")
            case .success(let user):
                DispatchQueue.main.async {
                    self.add(GFUserInfoHeaderVC(user: user), to: self.headerView)
                    self.add(GFRepoItemVC(user: user), to: self.itemOne)
                    self.add(GFFollowerItemVC(user: user), to: self.itemTwo)
                    self.dateLabel.text = "User Since \(user.createdAt.convertToDisplayFormat())"
                }
            }
        }
    }

    func layoutUI() {

        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140

        itemViews = [headerView, itemOne, itemTwo, dateLabel]

        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])


        }



        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
//            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            headerView.heightAnchor.constraint(equalToConstant: itemHeight + 40),

            itemOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
//            itemOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
//            itemOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemOne.heightAnchor.constraint(equalToConstant: itemHeight),

            itemTwo.topAnchor.constraint(equalTo: itemOne.bottomAnchor, constant: padding),
//            itemTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
//            itemTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemTwo.heightAnchor.constraint(equalToConstant: itemHeight),

            dateLabel.topAnchor.constraint(equalTo: itemTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)

        ])
    }

    /// https://www.swiftbysundell.com/basics/child-view-controllers/
    /// best explanation
    func add(_ childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self )
    }

    @objc func dismissVC() {
        dismiss(animated: true)
    }




}

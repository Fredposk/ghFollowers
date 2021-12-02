//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 16.11.21.
//

import UIKit

protocol RepoItemDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
}

class GFRepoItemVC: GFItemInfoVC {

    weak var delegate: RepoItemDelegate?
    var user: User!

    
    init(user: User, delegate: RepoItemDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }

    func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, with: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, with: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }

    override func didTapActionButton() {
        guard let delegate = delegate else { return }
        delegate.didTapGitHubProfile(for: user)
    }
}

//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 16.11.21.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {

    
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

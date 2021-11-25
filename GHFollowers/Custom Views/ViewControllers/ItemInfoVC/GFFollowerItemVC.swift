//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 16.11.21.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }

    func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, with: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, with: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Followers")
    }

    override func didTapActionButton() {
        guard let delegate = delegate else {return}
        delegate.didTapGetFollowers(for: user)
    }

}
 

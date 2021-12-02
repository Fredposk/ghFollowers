//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 16.11.21.
//

import UIKit

protocol FollowerItemVCDelegate: AnyObject {
    func didTapGetFollowers(for user: User)
}

class GFFollowerItemVC: GFItemInfoVC {

    weak var delegate: FollowerItemVCDelegate?
    var user: User!


    init(user: User, delegate: FollowerItemVCDelegate) {
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
        itemInfoViewOne.set(itemInfoType: .followers, with: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, with: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Followers")
    }

    override func didTapActionButton() {
        guard let delegate = delegate else {return}
        delegate.didTapGetFollowers(for: user)
    }
}
 

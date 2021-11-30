//
//  GFAvatarCell.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 10.11.21.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    static let ReUseIdentifier = "FollowerCell"
    let avatarImageView = GFAvatarImageView(frame: .zero)
    var usernameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)

    let padding: CGFloat = 8

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(with follower: Follower) {
        usernameLabel.text = follower.login
//        avatarImageView.downloadImage(from: follower.avatarUrl)
        NetworkManager.shared.downloadImage(from: follower.avatarUrl) { [weak self] result in
            guard let self = self else { return }
            self.avatarImageView.image = result
        }
    }

    private func configure() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

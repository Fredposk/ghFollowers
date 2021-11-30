//
//  GFImageView.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 10.11.21.
//

import UIKit

class GFAvatarImageView: UIImageView {

    
    let placeholderImage = UIImage(named: "avatar-placeholder")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 3
        contentMode = .scaleAspectFill
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }


    



}

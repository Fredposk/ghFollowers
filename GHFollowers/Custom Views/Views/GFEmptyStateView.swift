//
//  GFEmptyStateView.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 13.11.21.
//

import UIKit

class GFEmptyStateView: UIView {

    let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
    let logoImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        configureLogoImageView()
        configureMessageLabel()
    }

    private func configureLogoImageView() {
        addSubview(logoImageView)

        logoImageView.image = Images.emptyStateLogo
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 40)
        ])
    }

    private func configureMessageLabel() {
        addSubview(messageLabel)

        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel


        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),

        ])
    }

}

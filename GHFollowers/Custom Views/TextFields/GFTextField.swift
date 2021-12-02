//
//  GFTextField.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 04.11.21.
//

import UIKit

class GFTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor

        textColor = .label
        tintColor = .label
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        leftViewMode = .always
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        returnKeyType = .go
        keyboardType = .alphabet
        clearButtonMode = .whileEditing
        placeholder = "Enter a User Name"
    }
}

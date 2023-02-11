//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Karlis Berzins on 11/02/2023.
//

import UIKit

class GFAvatarImageView: UIImageView {
    private let placeholderImage = UIImage(named: "avatar-placeholder")

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)

        configure()
    }

    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
}

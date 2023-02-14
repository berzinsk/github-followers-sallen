//
//  GFUserInfoHeaderVC.swift
//  GHFollowers
//
//  Created by Karlis Berzins on 13/02/2023.
//

import UIKit

class GFUserInfoHeaderVC: UIViewController {
    var user: User!

    private let avatarImageView = GFAvatarImageView(frame: .zero)
    private let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 34)
    private let nameLabel = GFSecondaryTitleLabel(fontSize: 18)
    private let locationImageView = UIImageView()
    private let locationLabel = GFSecondaryTitleLabel(fontSize: 18)
    private let bioLabel = GFBodyLabel(textAlignment: .left)

    private lazy var locationStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .leading
        stack.distribution = .fill
        [self.locationImageView, self.locationLabel].forEach { stack.addArrangedSubview($0) }

        return stack
    }()

    private lazy var userInfoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .top
        stack.distribution = .fill
        [self.usernameLabel, self.nameLabel, self.locationStackView].forEach { stack.addArrangedSubview($0) }

        return stack
    }()

    init(user: User) {
        super.init(nibName: nil, bundle: nil)

        self.user = user
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubviews(avatarImageView, userInfoStackView, bioLabel)
        layoutUI()
        configureUIElements()
    }

    private func configureUIElements() {
        downloadAvatarImage()
        usernameLabel.text = user.login
        nameLabel.text = user.name ?? ""
        locationLabel.text = user.location ?? "No Location"
        bioLabel.text = user.bio ?? "No bio available"
        bioLabel.numberOfLines = 3

        locationImageView.image = SFSymbols.location
        locationImageView.tintColor = .secondaryLabel
    }

    private func downloadAvatarImage() {
        NetworkProvider.shared.downloadImage(from: user.avatarUrl) { [weak self] image in
            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
        }
    }

    private func layoutUI() {
        let padding: CGFloat = 20
        let textImagePadding: CGFloat = 12
        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        userInfoStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            locationImageView.widthAnchor.constraint(equalToConstant: 20),
            locationImageView.heightAnchor.constraint(equalTo: locationImageView.widthAnchor),

            userInfoStackView.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            userInfoStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            userInfoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userInfoStackView.heightAnchor.constraint(equalTo: avatarImageView.heightAnchor),

            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textImagePadding),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bioLabel.heightAnchor.constraint(equalToConstant: 90),
        ])
    }
}

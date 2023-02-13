//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by Karlis Berzins on 13/02/2023.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureItems()
    }

    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, with: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, with: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
    }

    override func actionButtonTapped() {
        delegate?.didTapGithubProfile(for: user)
    }
}

//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Karlis Berzins on 10/02/2023.
//

import UIKit

class FollowerListVC: UIViewController {
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        NetworkProvider.shared.getFollowers(for: username) { [weak self] result in
            switch result {
            case .success(let followers):
                print("Followers.count = \(followers.count)")
                print(followers)
            case .failure(let error):
                self?.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

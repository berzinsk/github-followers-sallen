//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Karlis Berzins on 12/02/2023.
//

import UIKit

class UserInfoVC: UIViewController {
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton

        NetworkProvider.shared.getUserInfo(for: username) { [weak self] result in
            switch result {
            case .success(let user):
                print(user)
            case .failure(let error):
                self?.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}

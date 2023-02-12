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
    }

    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}

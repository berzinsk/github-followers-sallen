//
//  FavoritesListVC.swift
//  GHFollowers
//
//  Created by Karlis Berzins on 10/02/2023.
//

import UIKit

class FavoritesListVC: GFDataLoadingVC {
    private let tableView = UITableView()
    private var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getFavorites()
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseId)
    }

    private func getFavorites() {
        do {
            let favorites = try PersistenceProvider.retrieveFavorites()
            updateUI(with: favorites)
        } catch let error as GFError {
            presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        } catch {
            presentDefaultError()
        }
    }

    private func updateUI(with favorites: [Follower]) {
        if favorites.isEmpty {
            showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen.", in: view)
        } else {
            self.favorites = favorites
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
}

extension FavoritesListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseId, for: indexPath) as! FavoriteCell
        let favorite = favorites[indexPath.row]

        cell.set(favorite: favorite)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC = FollowerListVC(username: favorite.login)

        navigationController?.pushViewController(destVC, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        do {
            try PersistenceProvider.updateWith(favorite: favorites[indexPath.row], actionType: .remove)
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            if favorites.isEmpty {
                showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen.", in: view)
            }
        } catch let error as GFError {
            presentGFAlert(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
        } catch {
            presentDefaultError()
        }
    }
}

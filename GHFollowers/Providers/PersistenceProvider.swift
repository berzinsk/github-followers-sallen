//
//  PersistenceProvider.swift
//  GHFollowers
//
//  Created by Karlis Berzins on 13/02/2023.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceProvider {
    enum Keys {
        static let favorites = "favorites"
    }

    static private let defaults = UserDefaults.standard

    static func updateWith(favorite: Follower, actionType: PersistenceActionType) throws {
        var favorites = try retrieveFavorites()

        switch actionType {
        case .add:
            guard !favorites.contains(favorite) else {
                throw GFError.alreadyInFavorites
            }

            favorites.append(favorite)
        case .remove:
            favorites.removeAll { $0.login == favorite.login }
        }

        try save(favorites: favorites)
    }

    static func retrieveFavorites() throws -> [Follower] {
        guard let favoritesData = defaults.data(forKey: Keys.favorites) else {
            return []
        }

        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            return favorites
        } catch {
            throw GFError.unableToFavorite
        }
    }

    static func save(favorites: [Follower]) throws {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
        } catch {
            throw GFError.unableToFavorite
        }
    }
}

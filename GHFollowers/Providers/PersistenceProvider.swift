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

    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completion: @escaping (GFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completion(.alreadyInFavorites)
                        return
                    }

                    favorites.append(favorite)
                case .remove:
                    favorites.removeAll { $0.login == favorite.login }
                }

                completion(save(favorites: favorites))
            case .failure(let error):
                completion(error)
            }
        }
    }

    static func retrieveFavorites(completion: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favoritesData = defaults.data(forKey: Keys.favorites) else {
            completion(.success([]))
            return
        }

        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }

    static func save(favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)

            return nil
        } catch {
            return .unableToFavorite
        }
    }
}

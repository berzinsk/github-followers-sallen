//
//  NetworkProvider.swift
//  GHFollowers
//
//  Created by Karlis Berzins on 11/02/2023.
//

import UIKit

class NetworkProvider {
    static let shared = NetworkProvider()
    private let baseUrl = "https://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>()

    private init() {}

    func getFollowers(for username: String, page: Int = 1, completion: @escaping (Result<[Follower], GFError>) -> Void) {
        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"

        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(.success(followers))
            } catch {
                completion(.failure(.invalidData))
            }
        }

        task.resume()
    }
}

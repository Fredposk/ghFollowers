//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 08.11.21.
//

import Foundation




final class NetworkManager {
    static let shared = NetworkManager()

    private let baseUrl = "https://api.github.com/users/"

    private init(){}
}



extension NetworkManager {
    
//    might need to become public
    typealias getFollowersResult = (Result<[Follower], ErrorMessage>) -> Void
//    typealias getFollowersCompletion = (([Follower]?, ErrorMessage?) -> Void)

    func getFollowers(for userName: String, page: Int, completed: @escaping getFollowersResult) {
        let endpoint = baseUrl + "\(userName)/followers?per_page=100&page=\(page)"

        guard let url = URL(string: endpoint) else {
//            completed(nil, .invalidUserName)
            completed(.failure(.invalidUserName))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let _ = error {
//                completed(nil, .unableToComplete)
                completed(.failure(.unableToComplete))
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completed(nil, .invalidHTTPResponse)
                completed(.failure(.invalidHTTPResponse))
                return
            }
            guard let data = data else {
//                completed(nil, .invalidData)
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
//                completed(followers, nil)
                completed(.success(followers))
            } catch {
//                completed(nil, .unableToParseData)
                completed(.failure(.unableToParseData))
            }

        }
        task.resume()
    }
}

//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 08.11.21.
//


import UIKit

typealias getFollowersResult = (Result<[Follower], ErrorMessage>) -> Void

 final class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl = "https://api.github.com/users/"
    private let cache = NSCache<NSString, UIImage>()

    private init(){}
}


extension NetworkManager {

    func getFollowers(for userName: String, page: Int, completed: @escaping getFollowersResult) {
        let endpoint = baseUrl + "\(userName)/followers?per_page=100&page=\(page)"

        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUserName))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let _ = error {
                completed(.failure(.unableToComplete))
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidHTTPResponse))
                return
            }
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.unableToParseData))
            }
        }
        task.resume()
    }
}

extension NetworkManager {

    public typealias getUserResult = (Result<User, ErrorMessage>) -> Void

     func getUser(for userName: String, completed: @escaping getUserResult) {
         let endpoint = baseUrl + "\(userName)"

         guard let url = URL(string: endpoint) else {
             completed(.failure(.invalidUserName))
             return
         }
         let task = URLSession.shared.dataTask(with: url) { data, response, error in
             if let _ = error {
                 completed(.failure(.unableToComplete))
             }
             guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                 completed(.failure(.invalidHTTPResponse))
                 return
             }
             guard let data = data else {
                 completed(.failure(.invalidData))
                 return
             }

             do {
                 let decoder = JSONDecoder()
                 decoder.keyDecodingStrategy = .convertFromSnakeCase
                 decoder.dateDecodingStrategy = .iso8601
                 let user = try decoder.decode(User.self, from: data)
                 completed(.success(user))
             } catch {
                 completed(.failure(.unableToParseData))
             }
         }
         task.resume()
     }

    /// download image and store into cache
    ///  - Returns: Image from URL or cached
    func downloadImage (from urlString: String, completed: @escaping ((UIImage?) -> Void)) {

        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }

        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil { return }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }

            self.cache.setObject(image, forKey: cacheKey)
            DispatchQueue.main.async {
                completed(image)
            }
        }
        task.resume()
    }
}

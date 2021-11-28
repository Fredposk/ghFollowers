//
//  PersistanceManager.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 26.11.21.
//

import Foundation

enum PersistanceManager {

    static private let defaults = UserDefaults.standard

    enum Keys {
        static let favorites = "favorites"
    }

    enum PersistanceActionType {
        case add, remove
    }

    static func updateWith(favourite: Follower, actionType: PersistanceActionType, completed: @escaping (ErrorMessage?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(let favourites):
                var retrieveFavourites = favourites

                switch actionType {
                case .add:
                    guard retrieveFavourites.contains(favourite) == false else {
                        completed(.alreadyFavorited)
                        return
                    }
                    retrieveFavourites.append(favourite)
                case .remove:
                    retrieveFavourites.removeAll { $0.login == favourite.login}
                }
                completed(save(favourites: retrieveFavourites))
            case .failure(let error):
                completed(error)
            }
        }
    }

    
    static func retrieveFavorites(completed:  getFollowersResult) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let favourites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favourites))
        } catch {
            completed(.failure(.unableToGetFavorite))
        }
    }

    static func save(favourites: [Follower]) -> ErrorMessage? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favourites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToSaveFavorite
        }
    }
}

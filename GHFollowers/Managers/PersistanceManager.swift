//
//  PersistanceManager.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 26.11.21.
//

import Foundation

enum PersistenceManager {

    static private let defaults = UserDefaults.standard

    enum Keys { static let favorites = "favorites" }

    enum PersistenceActionType {
        case add, remove
    }

    static func updateWith(favourite: Follower, actionType: PersistenceActionType, completed: @escaping (ErrorMessage?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favourites):
                switch actionType {
                case .add:
                    guard favourites.contains(favourite) == false else {
                        completed(.alreadyFavorited)
                        return
                    }
                    favourites.append(favourite)
                case .remove:
                    favourites.removeAll { $0.login == favourite.login}
                }
                completed(save(favourites: favourites))
            case .failure(_):
                completed(ErrorMessage.unableToGetFavorite)
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

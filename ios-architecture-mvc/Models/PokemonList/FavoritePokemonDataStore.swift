//
//  FavoritePokemonDataStore.swift
//  ios-architecture-mvc
//
//  Created by AIR on 2023/04/26.
//

import Foundation

protocol FavoritePokemonDataStore {
    typealias Object = Int
    func fetchAll() -> [Object]
    func add(_ objects: [Object]) -> Result<[Object], FavoritePokemonDataStoreError>
    func remove(_ objects: [Object]) -> Result<[Object], FavoritePokemonDataStoreError>
}

enum FavoritePokemonDataStoreError: Error {
    case unknown
}

struct FavoritePokemonDataStoreImpl: FavoritePokemonDataStore {
    enum Key: String {
        case favoriteNumbers = "FAVORITE_POKEMON_NUMBERS"
    }
    
    private let userDefaults = UserDefaults.standard
    
    public init() {
    }
    
    func fetchAll() -> [Object] {
        return userDefaults.array(forKey: Key.favoriteNumbers.rawValue) as? [Object] ?? []
    }
    
    func add(_ objects: [Object]) -> Result<[Object], FavoritePokemonDataStoreError> {
        var list = fetchAll()
        list.append(contentsOf: objects)
        userDefaults.set(list, forKey: Key.favoriteNumbers.rawValue)
        return .success(list)
    }
    
    func remove(_ objects: [Object]) -> Result<[Object], FavoritePokemonDataStoreError> {
        var list = fetchAll()
        list.removeAll{ objects.contains($0) }
        userDefaults.set(list, forKey: Key.favoriteNumbers.rawValue)
        return .success(list)
    }
}

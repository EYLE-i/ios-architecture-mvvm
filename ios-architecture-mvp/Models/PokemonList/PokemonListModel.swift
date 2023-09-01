//
//  PokemonListModel.swift
//  ios-architecture-mvp
//
//  Created by AIR on 2023/04/26.
//

import Foundation

protocol PokemonListModelInput {
    func fetchPokemonList(_ completion: @escaping (Result<[Pokemon], APIError>) -> Void)
    func pokemonFiltered(isFilterFavorite: Bool, favoriteNumbers: [Int], pokemonList: [Pokemon]) -> [Pokemon]
    func updateFavoriteIds(number: Int)
    var favoriteIds: [Int] { get }
}

final class PokemonListModel: PokemonListModelInput {
    private let pokemonListAPI: PokemonListAPI
    let dataStore: FavoritePokemonDataStore
    var favoriteIds: [Int]
    
    init(dataStore: FavoritePokemonDataStore, apiClient: APIClient) {
        self.dataStore = dataStore
        self.pokemonListAPI = .init(apiClient: apiClient)
        self.favoriteIds = dataStore.fetchAll()
    }
    
    func fetchPokemonList(_ completion: @escaping (Result<[Pokemon], APIError>) -> Void) {
        pokemonListAPI.requestPokemonList { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func pokemonFiltered(isFilterFavorite: Bool,
                         favoriteNumbers: [Int],
                         pokemonList: [Pokemon]) -> [Pokemon] {
        return pokemonList.filter {
            if isFilterFavorite {
                return favoriteNumbers.contains($0.number)
            } else {
                return true
            }
        }
    }
    
    func updateFavoriteIds(number: Int) {
        if favoriteIds.contains(number) {
            _ = dataStore.remove([number])
        } else {
            _ = dataStore.add([number])
        }
        favoriteIds = dataStore.fetchAll()
    }
}

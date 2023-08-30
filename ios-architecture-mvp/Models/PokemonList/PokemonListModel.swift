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
}

final class PokemonListModel: PokemonListModelInput {
    private let pokemonListAPI: PokemonListAPI
    let dataStore: FavoritePokemonDataStore
    
    init(dataStore: FavoritePokemonDataStore, apiClient: APIClient) {
        self.dataStore = dataStore
        self.pokemonListAPI = .init(apiClient: apiClient)
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
}

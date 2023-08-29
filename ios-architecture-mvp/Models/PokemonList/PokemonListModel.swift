//
//  PokemonListModel.swift
//  ios-architecture-mvp
//
//  Created by AIR on 2023/04/26.
//

import Foundation

protocol PokemonListModelInput {
    func fetchPokemonList(_ completion: @escaping (Result<[Pokemon], APIError>) -> Void)
}

final class PokemonListModel: PokemonListModelInput {
    private let pokemonListAPI: PokemonListAPI = .init(apiClient: DefaultAPIClient.shared)
    
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
}

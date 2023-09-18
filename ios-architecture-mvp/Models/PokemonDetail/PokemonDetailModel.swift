//
//  PokemonDetailModel.swift
//  ios-architecture-mvp
//
//  Created by AIR on 2023/05/22.
//

import Foundation

protocol PokemonDetailModelInput {
    func fetchPokemonDetail(_ completion: @escaping (_ result: Result<PokemonDetail, APIError>) -> Void)
}

final class PokemonDetailModel: PokemonDetailModelInput {
    private let pokemon: Pokemon!
    private let pokemonDetailAPI: PokemonDetailAPI
    
    init(pokemon: Pokemon, apiClient: APIClient) {
        self.pokemon = pokemon
        self.pokemonDetailAPI = .init(apiClient: apiClient)
    }
    
    func fetchPokemonDetail(_ completion: @escaping (Result<PokemonDetail, APIError>) -> Void) {
        guard let imageUrl = pokemon.imageUrl else {
            return
        }
        pokemonDetailAPI.requestPokemonDetail(
            pokeId: pokemon.number,
            imageUrl: imageUrl) { result in
                completion(result)
        }
    }
}
